function Set-PathVariable {

    [CmdletBinding( SupportsShouldProcess )]
    Param(
        [Parameter( Mandatory )]
        [String] $newLocation
    )


    BEGIN {     # was: requires –runasadministrator
        $registry = @{
                hklm =  @{
                    branch = [Microsoft.Win32.Registry]::LocalMachine
                    subKey = "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
                }
                hkcu =  @{
                    branch = [Microsoft.Win32.Registry]::CurrentUser
                    subKey = "Environment"
                }
        }

        function getOldPath()
        {
            $registry.hkcu.branch.OpenSubKey(
                $registry.hkcu.subKey, $False
            ).GetValue(
                'Path',
                '',
                [Microsoft.Win32.RegistryValueOptions]::DoNotExpandEnvironmentNames
            )
        }
    }

    PROCESS {

        # Win32API error codes
            $ERROR_SUCCESS = 0
            $ERROR_DUP_NAME = 34
            $ERROR_INVALID_DATA = 13

        $newLocation = $newLocation.Trim();

        if ( -not $newLocation )
        {
            exit $ERROR_INVALID_DATA
        }

        [String] $oldPath = getOldPath

        # Check whether the new location is already in the path
        if ($oldPath.toLower().split(';') -contains $newLocation.toLower())
        {
            Write-Warning "The new location is already in the path"
            exit $ERROR_DUP_NAME
        }

        # Build the new path, make sure we don't have double semicolons
        $newPath = "$oldPath;$newLocation" -replace ';;+', ';'

        if ($psCmdlet.ShouldProcess( '%Path%', "Add $newLocation" )){

            # Add to the current session
            $ENV:Path += ";$newLocation"

            # Save into registry
            $registry.hkcu.branch.OpenSubKey(
                $registry.hkcu.subKey, $True
            ).SetValue(
                'Path',
                $newPath,
                [Microsoft.Win32.RegistryValueKind]::ExpandString
            )

        }
        exit $ERROR_SUCCESS
    }
}
