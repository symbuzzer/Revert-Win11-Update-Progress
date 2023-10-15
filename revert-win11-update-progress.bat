@echo off
setlocal EnableDelayedExpansion
mode con:cols=70 lines=8
cls
set ver=1.0.4
set name=Revert Win11 Update Progress
set author=Ali BEYAZ
set title=%name% v%ver% by %author%
title %title%
color 0a
set updatefolder="%SYSTEMDRIVE%\Windows\SoftwareDistribution\Download"
echo.Welcome to %title%
goto privileges

:privileges
echo. 
echo.It needs to work with admin rights
pause
goto stopservice

:stopservice
echo.-Stoping update services
goto checkservice

:checkservice
sc query wuauserv | find "STOPPED" >nul 2>&1
net stop wuauserv >nul 2>&1
IF ERRORLEVEL 1 (
  Timeout /T 5 /Nobreak >nul 2>&1
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
