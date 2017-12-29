function Test-PathWarnIfExists {
    Param(
      [Parameter( Mandatory, Position=0 )]
      [String] $Path
    )

    $result = Test-Path -path $Path
    if ($result) {
        Write-Warning "Item '$Path' already exists, it will be overwritten"
    }

    $result
}
