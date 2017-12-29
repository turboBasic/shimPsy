# Constants

#region     Inject all functions
    $Public = $Private = $PrivateModules = @()
    $Public  += (Get-ChildItem $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue).FullName
    $Private += (Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue).FullName
    $PrivateModules += (Get-ChildItem $PSScriptRoot\Private -Directory -ErrorAction SilentlyContinue).FullName

    foreach ($importFile in $Private + $Public) {
        try     {
            . $importFile
        }
        catch   { Write-Error "Failed to import function ${importFile}: $_" }
    }
#endregion  Inject

#region     Load up dependency modules
    foreach($module in $PrivateModules) {
        try     {
            Import-Module $module -ErrorAction Stop
        }
        catch   { Write-Error "Failed to import module ${module}: $_" }
    }
#endregion  Load Modules


### Initialization

$defaultSettings = @{
    shimDir =           "${ENV:UserProfile}\bin"
    shimExeOriginal =   'shimgen.exe'
    shimLicenseFile =   'shimgen.license.txt'
    configPath =        "$ENV:LocalAppData\shimpsy"
    configFileName =    "Shimpsy.config.ini"
}

$Settings = @{
    configFile =    New-ConfigFile
    shimDir =       New-ShimDir
}
$Settings | Out-IniFile -Append -filePath ($Settings.configFile)



# Dependencies


Test-PathWarnIfExists ALIAS:\shimpsy
Test-PathWarnIfExists ALIAS:\sy
New-Alias -name shimpsy -value Invoke-shimpsy -force
New-Alias -name sy -value Invoke-shimpsy -force

Export-ModuleMember -function '*' -Variable '*'
