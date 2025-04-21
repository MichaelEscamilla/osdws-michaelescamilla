@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0 ::","","runas",1)(window.close)&&exit
cls
echo Checking Minisforum Log folder path...
if not exist C:\Minisforum.sav\DrverInstall md C:\Minisforum.sav\DrverInstall & attrib +H C:\Minisforum.sav

echo Start Installing Intel Ethernet driver...
@set L=C:\Minisforum.sav\DrverInstall\IntelEthernet.log
@set IP=[===========Install Pass===========]
@set IPR=[===========Install Pass, Restart is need===========]
@set IF=[===========Install Fail===========]

@echo [%time%]=========Install Ethernet driver========= >> %L%
pnputil /add-driver "%~dp0Drivers\*.inf" /subdirs /install >> %L%

@if %errorlevel%==0 (echo [%time%]%IP% >> %L% & goto resultpass)
@if %errorlevel%==259 (echo [%time%]%errorlevel% >> %L% & goto resultpass)
@if %errorlevel%==3010 (echo [%time%]%IPR% >> %L% & goto resultpass)
@if not %errorlevel%==0 goto ERR

:resultpass
@echo [%time%]=========Intel Ethernet Install Complete========= >> %L%
ECHO ERRRORLEVEL=%ERRORLEVEL% >> %L%
EXIT /B 0

:ERR
echo [%time%]%IF% >> %L%
ECHO ERRRORLEVEL=%ERRORLEVEL% >> %L%
EXIT /B 1