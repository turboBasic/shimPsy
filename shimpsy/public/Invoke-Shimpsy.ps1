function Invoke-Shimpsy {
    [CmdletBinding()]
      Param(
        [Parameter( Mandatory, Position=0 )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({
            try {
                if (  Resolve-Path -path $_ | Where-Object { Test-Path -path $_ -pathType Leaf } )
                {
                    $True
                }
                else {
                    throw
                }
            } catch {
                Write-Error "There are no files specified by '$Path'"
            }
        })]
        [String] $Path,

        [String] $DestinationName,

        [Switch] $Gui
      )


    $guiSwitch = ''
    if ($Gui) {
      $guiSwitch = '--gui'
    }

    $fileName = $False

    Resolve-Path -path $Path |
    Where-Object { Test-Path -path $_ -pathType Leaf } |
    ForEach-Object {
        $fileName = Split-Path -Path $_ -Leaf
        if (-not $DestinationName) {
            Test-PathWarnIfExists $shimDir\$fileName
            & $shimExe -p $_.Path -o $shimDir\$fileName $guiSwitch
        } else {
            Test-PathWarnIfExists $shimDir\$DestinationName
            & $shimExe -p $_.Path -o $shimDir\$DestinationName $guiSwitch
        }
    }

    if (! $fileName) {
      Write-Warning "There are no files specified by '$Path'"
    }

  }
