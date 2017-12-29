@echo off
setlocal enabledelayedexpansion
set args=%*
set args=%args:"='%
set args=%args:(=`(%
set args=%args:)=`)%
set invalid="='
if !args! == !invalid! ( set args= )
powershell.exe -noLogo -noProfile -executionPolicy Unrestricted -command "Invoke-Shimgen -path %args%; exit $lastExitCode"
