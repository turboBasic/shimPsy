function New-ConfigFile
{
    function Add-UniquePrefix([string] $fileName)
    {
        (Get-Date -format FileDateTime),
        (New-Guid).toString().subString(0,8),
        [IO.Path]::GetFileName($fileName)    -join '.'

    }

    $path =       $script:defaultSettings.configPath
    $fileName =   $script:defaultSettings.configFileName

    $configFile =   Join-Path $path $fileName

    if (Test-Path $configFile) {
        Rename-Item -path $configFile -newName (Add-UniquePrefix $configFile)
    }
    elseif (Test-Path $path -pathType Leaf) {
        $newName = Join-Path (Split-Path $path) (Add-UniquePrefix $path)
        New-Item -itemType Directory -path $newName > $Null
        Move-Item -path $path -destination $newName
        Rename-item -path $newName -newName $path
    }

    New-Item -itemType File -path $configFile > $Null
    if(! (Test-Path $configFile)) {
        Write-Error "[New-ConfigFile] : Cannot create $configFile"
    }

    $configFile
}
