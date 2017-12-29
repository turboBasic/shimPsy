@{
    psDeploy =          '0.2.2'
    psScriptAnalyzer =  '1.16.1'
    BuildHelpers =      '0.0.55'
    Pester =            @{
        Version = '4.0'
        Target = 'CurrentUser'
    }

    buildToolsDir = @{
        DependencyType = 'Command'
        Source =  'if (-not (Test-Path .buildTools -pathType Container)) {
                      New-Item -itemType Directory -name .buildTools
                  }'
    }

    'nightroman/PowerShelf' = @{
        DependencyType = 'GitHub'
        DependsOn =      'buildToolsDir'
        Parameters = @{
            ExtractPath = 'Assert-SameFile.ps1',
                          'Save-NuGetTool.ps1'
        }
        Target = '.buildTools/PowerShelf'
    }

    PSDepend_Runtime = @{
        Name =    'PSDepend'
        Version = '0.1.56'
        Target =  'Shimpsy\Private'
        Tags =    'Runtime'
    }

    PSini = @{
        Version = 'latest'
        Target =  'Shimpsy\Private'
        Tags =    'Runtime'
    }

}
