<#
        .SYNOPSIS
	Build script for Invoke-Build (https://github.com/nightroman/Invoke-Build)

        .DESCRIPTION
	Builds project and properly deploys its artifacts

#>


# - Build script parameters are standard parameters
	Param(
        [Switch] $NoTestDiff
    )


# - Script-level initialization

    Set-StrictMode -version Latest
    Enter-Build {
        $script:Settings =     . ./shimpsy.settings.ps1
        $script:moduleName =   $Settings.ModuleName
        $script:toolsDir =     Join-Path -path $buildRoot -childPath $Settings.toolsDir
        Resolve-Module
    }


#   Synopsis: Remove generated and temp files
	task Clean      {
        Get-Item    z, Tests\z, Tests\z.*, $toolsDir,
                    README.html, Release-Notes.html, "$moduleName.*.nupkg" -errorAction SilentlyContinue |
        Remove-Item -force -recurse
	}


#   Synopsis: Warn about not empty git status if .git exists
	task GitStatus  -If (Test-Path .git) {
		$status = ( exec { git status -s } ) -join ', '
		if ($status) {
			Write-Warning "Git status: $status"
		}
	}



#   Synopsis: Set $Version variable
	task Version    {

		# get the version from Release-Notes
		# finds headers beginning with "[1.2.3]" pattern
		$script:Version = . {
			switch -regex -file Release-Notes.md
			{
				'(?x) \#\# \s+ \[( \d+ \. \d+ \. \d+ )\]'  {
					return $Matches[1]
				}
			}
		}

		"Version: $Version" | Write-Verbose
		assert $Version
	}



#   Synopsis: Build the project
    task Build      Module
	task Module     Version, {

		# mirror the module folder in temporary directory "z"
        Remove-Item [z] -force -recurse
        $dir = "$buildRoot\z\$moduleName"
        exec { $null = robocopy.exe $moduleName $dir /mir } 1


        # Markdown is off and there is no artifacts
            #Copy-Item   README.html,
            #            LICENSE,
            #            Release-Notes.html -destination $dir

		# make manifest
        Set-Content -path $dir\$moduleName.psd1 -value "
            @{
                ModuleVersion =         '$Version'
                RootModule =            '$moduleName.psm1'
                GUID =                  '14f3ecc0-e404-4653-b9d2-be4209939ea0'

                Author =                '$( $Settings.Author )'
                CompanyName =           '$( $Settings.CompanyName )'
                Copyright =             '$( $Settings.Copyright )'

                Description =           '$( $Settings.PackageDescription )'

                PowerShellVersion =     '5.0'
                RequiredModules =       @( @{ModuleName = 'PSini'; ModuleVersion = '1.2.0.39'} )
                FunctionsToExport =     @('Invoke-Shimpsy')
                AliasesToExport =       @('shimpsy', 'sy')

                PrivateData = @{
                    PSData = @{
                        Tags =          'profile', 'utilities', 'command prompt'
                        ProjectUri =    '$( $Settings.ProjectUri )'
                        LicenseUri =    '$( $Settings.LicenseUri )'
                        IconUri =       '$( $Settings.IconUri )'
                        ReleaseNotes =  '$( $Settings.ReleaseNotes )'
                    }
                }
            }"
	}


#   Synopsis: Make the NuGet package
	task NuGet      Module, {

		# rename the folder as per Nuget convention
			Rename-Item z\$moduleName tools

		# summary and description of a package
			$text = "

                $( $Settings.PackageDescription )

			" -replace '^\s+' -replace '\s+$'

		# manifest
			Set-Content -path z\Package.nuspec -value "<?xml version='1.0'?>
				<package xmlns='http://schemas.microsoft.com/packaging/2010/07/nuspec.xsd'>
					<metadata>
						<id>$moduleName</id>
						<version>$Version</version>
						<authors>$( $Settings.Author )</authors>
						<owners>$( $Settings.Owners )</owners>
						<projectUrl>$( $Settings.ProjectUri )</projectUrl>
						<iconUrl>$( $Settings.IconUri )</iconUrl>
						<licenseUrl>$( $Settings.LicenseUri )</licenseUrl>
						<requireLicenseAcceptance>false</requireLicenseAcceptance>
						<summary>$( $Settings.PackageDescription )</summary>
						<description>$( $Settings.PackageDescription )</description>
						<tags>'profile utilities'</tags>
						<releaseNotes>$( $Settings.ReleaseNotes )</releaseNotes>
						<developmentDependency>true</developmentDependency>
					</metadata>
				</package>"

		# package
			exec { NuGet.exe pack z\Package.nuspec -noDefaultExcludes -noPackageAnalysis }

	}



#   Synopsis: Push with a version tag
	task PushRelease    Version, {

		$changes = exec { git status --short }
		assert (-not $changes) "Please, commit changes"

		exec { git push }
		exec { git tag -a "v$Version" -m "v$Version" }
		exec { git push origin "v$Version" }

	}


#   Synopsis: Push NuGet package
	task PushNuGet     NuGet, {

            exec { NuGet.exe push "$moduleName.$Version.nupkg" -source nuget.org }

		},
		Clean

#   Synopsis: Unit tests
    task Test

#   Synopsis: Test, Clean and Build
    task .          Test, Clean, Build

#   Synopsis: Deploy to module gallery
    task Deploy     {
        Invoke-PSDeploy -force
    }
