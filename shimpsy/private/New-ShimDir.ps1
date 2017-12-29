function New-ShimDir
{

    function GetInstallPaths( [Switch] $expand )
    {
        '${ENV:Shimpsy}',
        '${ENV:Scoop}\shims',
        '${ENV:UserProfile}\bin',
        '${ENV:LocalAppData}\Microsoft\WindowsApps',
        '${ENV:Shimpsy_Global}',
        '${ENV:ChocolateyInstall}\bin',
        '${ENV:Scoop_Global}\shims',
        '${ENV:ProgramData}\shimpsy' |
        ForEach-Object {
            if ($expand) {
                $ExecutionContext.InvokeCommand.ExpandString( $_ )
            }
            else {
                $_
            }
        }
    }

    function ForceInstallPath
    {
        $ShimDir = $script:defaultSettings.shimDir

        if (-not(Test-Path ENV:Shimpsy)) {
            [Environment]::SetEnvironmentVariable( 'Shimpsy', $ShimDir, 'User' )
            $ENV:Shimpsy = $shimDir
        }
        if (-not(Test-Path $ShimDir)) {
            New-Item -Directory -path $Shimdir
        } else {
            throw "Cannot find empty Directory in the list of Known Directories, Installation failed"
        }
        return $Shimdir
    }


    $autoShimPathOrder = (GetInstallPaths -expand) | Where-Object {$_ -and (Test-Path $_) } |
            Where-Object {
                $ENV:Path.toLower().indexOf( $_.toLower() ) -ne -1
            }
    $shimDir = $autoShimPathOrder | Select-Object -First 1

    if (-not $shimDir.Count) {
        $shimDir = ForceInstallPath
    }

    #$shimDir = Join-Path $ENV:UserProfile bin

    $shimDir

}


