@echo off
echo [Notifier]: Feuerbereit!
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set "BOT_FOLDER=E:\minecraftIP_dizzybot"
set "SERVER_NAME=Minecraft Server"
set "PYTHON_EXE=%BOT_FOLDER%\.venv\Scripts\python.exe"
:: ---------------------

set "MODE=%~1"
if "%MODE%"=="" set "MODE=on"

echo [Notifier] Mode selected:        %MODE%

:: Check if venv python exists
if not exist "%PYTHON_EXE%" (
    echo [Notifier][ERROR] Python not found at: "%PYTHON_EXE%"
    echo [Notifier][ERROR] Please check if the .venv folder exists in %BOT_FOLDER%
    pause
    exit /b
)

pushd "%BOT_FOLDER%"

if /I "%MODE%"=="off" (
    echo [Updater] Sending Offline signal...
    "%PYTHON_EXE%" mc_announce.py off
    if %ERRORLEVEL% NEQ 0 echo [Notifier][ERROR] mc_announce.py failed with code %ERRORLEVEL%
    popd
    goto :eof
)

:: 1. Resolve IPv6
echo [Notifier] Running get_temp_ipv6.py...
for /f "usebackq delims=" %%a in (`
    cmd /c ""%PYTHON_EXE%" "%~dp0get_temp_ipv6.py""
`) do (
    set "S_IPV6=%%a"
    echo [Notifier] Captured IPv6: "%%a"
)

if "%S_IPV6%"=="" (
    echo [Notifier][Warning] temp_IPv6_resolver.py returned nothing!
)

:: 2. Extract Port from server.properties
echo [Notifier] Extracting infos from server.properties
set "S_PORT="
for /f "tokens=2 delims==" %%a in ('findstr /C:"server-port=" "%~dp0server.properties"') do (
    set "S_PORT=%%a"
    echo [Notifier] Captured Port: "%%a"
)

if "%S_PORT%"=="" (
    echo [Notifier][ERROR] Could not find server-port in server.properties!
)

:: 3. Send signal to the Bot
echo [Notifier] Signaling Bot: %MODE% [%S_IPV6%]:%S_PORT%
"%PYTHON_EXE%" mc_announce.py on "%SERVER_NAME%" "%S_IPV6%" "%S_PORT%"

if %ERRORLEVEL% NEQ 0 (
	echo [Notifier][ERROR] mc_announce.py failed to send signal!
) else (
	echo [Notifier] Successfully signaled bot.
)

popd
echo [Notifier] Exiting..
:eof