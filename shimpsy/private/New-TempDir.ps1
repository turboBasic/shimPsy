function New-TempDir {
    New-Item -name ([IO.Path]::GetRandomFileName()) -path $ENV:Temp -itemType Directory
}
