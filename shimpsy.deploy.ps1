# script for Invoke-PSDeploy ( https://github.com/RamblingCookieMonster/PSDeploy )

#
#    Invoke-PSDeploy -Path ./shimpsy.deploy.ps1
#

$script:Settings =     . ./shimpsy.settings.ps1

Deploy Module {
    By psGalleryModule {
        FromSource  z/Shimpsy
        To          CargonauticaRepo
        #WithOptions @{
            # ApiKey = $ENV:NugetApiKey
        #}
    }
}
