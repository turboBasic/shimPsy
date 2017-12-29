
function Set-ShimpsyConfiguration {
<#
        .SYNOPSIS
Creates and changes settings of Shimpsy

        .DESCRIPTION
Creates and changes settings of Shimpsy application stored in shimpsy.config.ini file

        .EXAMPLE
Set-ShimpsyConfiguration [-ShimPath] <String> [-Scope <String>] [-Force]

Set-ShimpsyConfiguration ~\scoop\bin
    config.ini -> ~/Appdata/shimpsy
    shims -> ~\scoop\bin
    scope local
    noforce

        .EXAMPLE
Set-ShimpsyConfiguration -AutoShimPath [-Scope <String>] [-Force]


#>

    [CmdletBinding()]
    Param(
        [Parameter( ParameterSetName = 'ShimPath', Mandatory, Position=0, ValueFromPipeline )]
        [Alias( 'Path' )]
        [String] $ShimPath,

        [Parameter( ParameterSetName = 'AutoShimPath', Mandatory )]
        [Switch] $AutoShimPath,

        [Parameter( ParameterSetName = 'AutoShimPath' )]
        [Parameter( ParameterSetName = 'ShimPath' )]
        [String] $Scope = 'User',

        [Parameter( ParameterSetName = 'AutoShimPath' )]
        [Parameter( ParameterSetName = 'ShimPath' )]
        [Alias( 'AppendToPath' )]
        [Switch] $Force
    )

    if ($PSboundParameters.containsKey('Scope') -and
        -not $PSboundParameters.containsKey('Force')
    ) {
        $Force = $True
    }

    Switch ($psCmdlet.ParameterSetName) {
        'ShimPath'
        {
            $Settings = @{
                ShimPath = $ShimPath
                AppendToPath = $Force
            }
            $Paths = $ENV:Path -split ';' | ForEach-Object { $_.Trim().TrimEnd('/\') }

            if (-not $Force -and
                $ShimPath -notIn $Paths
            ) {
                Write-Warning "'$ShimPath' is not in your {ENV:Path} and current settings do not allow me to add this directory to {ENV:Path}.  Use AppendToPath parameter to force adding your shimDir to {ENV:Path}"
            }
            break
        }

        'AutoShimPath'
        {  }
    }



}
