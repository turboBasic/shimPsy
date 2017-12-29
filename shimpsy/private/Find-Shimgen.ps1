function Find-Shimgen {

    function Find-LocalShimgen {

        $shimExe = (where.exe $defaultSettings.shimExeOriginal)
        if ($lastExitCode -gt 0) {
          Write-Verbose "Cannot find '$shimExeOriginal'"
        }

        $shimExe
    }

    function Download-Shimgen {

        $chocolateyPackageUri = 'https://chocolatey.org/api/v2/package/chocolatey'
        $pathInsideZip = "tools\chocolateyInstall\tools\shimgen.*"


        $zip = [IO.Path]::GetTempFileName() + '.zip'
        Write-Verbose "Downloading '$shimExeOriginal' from '$chocolateyPackageUri'"
        Invoke-WebRequest -uri $chocolateyPackageUri -outFile $zip

        $dir = New-TempDir
        Expand-Archive -path $zip -destinationPath $dir
        Get-Item -Path (Join-Path $dir.FullName $pathInsideZip)  |  Select-Object -First 1

    }

    $shimgen = Find-LocalShimgen
    if ( $shimgen ) {
        Copy-Item -path (Join-Path (Split-Path $shimgen) shimgen*) -destination $Settings.shimDir
        Copy-Item -path "$($Settings.shimDir)\shimgen.exe" -destination shimpsy.exe

        Write-Verbose "Shimgen.exe has been copied to $($Settings.shimDir)"

        $Settings.shimExe = "$($Settings.shimDir)\shimpsy.exe"
        return
    }

    $shimgen = Download-Shimgen
    if ( ! $shimgen ) {
        Write-Error "Cannot find 'shimgen.exe', please consider installing Chocolatey package manager"
        exit
    }

    Copy-Item -path $shimgen* -destination $Settings.shimDir
    Copy-Item -path "$($Settings.shimDir)\shimgen.exe" -destination shimpsy.exe

    Write-Verbose "Shimgen.exe has been copied to $($Settings.shimDir)"

}
