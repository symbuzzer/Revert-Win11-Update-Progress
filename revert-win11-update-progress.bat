@echo off
setlocal EnableDelayedExpansion
mode con:cols=70 lines=6
cls
set ver=1.0.0
set name=Revert Win11 Update Progress
set title=%name% v%ver%
title %title%
color 0a
set updatefolder="%SYSTEMDRIVE%\Windows\SoftwareDistribution\Download"
set filename=%RANDOM%
echo.Welcome to %name% v%ver%
goto checkPrivileges

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (shift & goto gotPrivileges)
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs"
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs"
"%temp%\OEgetPrivileges.vbs"
exit /B

:gotPrivileges
setlocal & pushd .
goto stopservice

:stopservice
echo.-Stoping update services

:checkservice
sc query wuauserv | find "STOPPED" >nul 2>&1
net stop wuauserv >nul 2>&1
IF ERRORLEVEL 1 (
  Timeout /T 5 /Nobreak
  goto checkservice
) else (
  goto delete
)
 
:delete
echo.-Starting to revert...
rmdir /s /q %updatefolder% >nul 2>&1
goto startservice

:startservice
echo.-Restarting update services
net start wuauserv >nul 2>&1
goto exit

:exit
echo.Reverted succesfully!
pause
exit