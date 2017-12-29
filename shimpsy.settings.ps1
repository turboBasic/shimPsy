# Customize these properties and tasks
    Param(
        $ModuleName =           'shimpsy',
        $ModulePath =           'shimpsy',
        $ToolsDir =             '.buildTools',
        $BuildNumber =          $ENV:BUILD_NUMBER,
        $PercentCompliance =    '60'
    )


# Static settings -- no reason to include these in the param block
    @{
        SMBRepoName =           'CargonauticaRepo'
        SMBRepoPath =           '\\dns323\psGallery'

        Author =                'Andriy Melnyk / @turboBasic'
        Owners =                '@turboBasic'
        CompanyName =           'Cargonautica'
        Copyright =             '(c) 2017 Andriy Melnyk / @turboBasic. All rights reserved'
        ProjectUri =            "https://github.com/turboBasic/$ModuleName"
        Repository =            "https://github.com/turboBasic/$ModuleName.git"
        LicenseUri =            "https://github.com/turboBasic/$ModuleName/blob/master/LICENSE"
        IconUri =               'https://gist.githubusercontent.com/turboBasic/9dfd228781a46c7b7076ec56bc40d5ab/raw/03942052ba28c4dc483efcd0ebf4bfc6809ed0d0/hexagram3D.png'
        PackageDescription =    'Shimpsy creates executable shims for user files to avoid polluting ENV:PATH, making your configuration easier to maintain, change and replicate'
        ReleaseNotes =          "https://github.com/turboBasic/$moduleName/blob/master/Release-Notes.md"

        # TODO: fix any redundant naming
        GitRepo =               'turboBasic/shimpsy'
        CIUrl =                 ''
    } +
    @{
        ModuleName              = $ModuleName
        ModulePath              = $ModulePath
        ToolsDir                = $ToolsDir
        BuildNumber             = $BuildNumber
        PercentCompliance       = $PercentCompliance
    }

