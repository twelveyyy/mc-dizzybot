@echo off
setlocal enabledelayedexpansion

:: --- CONFIGURATION ---
set "BOT_FOLDER="
set "SERVER_NAME=Minecraft Server"
set "PYTHON_EXE=%BOT_FOLDER%\.venv\Scripts\python.exe"
:: ---------------------

set "MODE=%~1"
if "%MODE%"=="" set "MODE=on"

echo [DEBUG] Current Batch Folder: "%~dp0"
echo [DEBUG] Target Bot Folder:    "%BOT_FOLDER%"
echo [DEBUG] Mode selected:        %MODE%

:: Check if venv python exists
if not exist "%PYTHON_EXE%" (
    echo [ERROR] Python not found at: "%PYTHON_EXE%"
    echo [DEBUG] Please check if the .venv folder exists in %BOT_FOLDER%
    pause
    exit /b
)

echo [DEBUG] Moving to Bot Folder...
pushd "%BOT_FOLDER%"
echo [DEBUG] Now in: "%CD%"

if /I "%MODE%"=="off" (
    echo [Updater] Sending Offline signal...
    "%PYTHON_EXE%" mc_announce.py off
    if %ERRORLEVEL% NEQ 0 echo [ERROR] mc_announce.py failed with code %ERRORLEVEL%
    popd
    goto :eof
)

:: 1. Resolve IPv6
echo [Updater] Running get_temp_ipv6.py...
for /f "tokens=*" %%a in ('"%PYTHON_EXE%" get_temp_ipv6.py') do (
    set "S_IPV6=%%a"
    echo [DEBUG] Captured IPv6: "%%a"
)

if "%S_IPV6%"=="" (
    echo [WARNING] temp_IPv6_resolver.py returned nothing!
)

:: 2. Extract Port from server.properties
echo [Updater] Reading Port from "%~dp0server.properties"...
set "S_PORT="
for /f "tokens=2 delims==" %%a in ('findstr /C:"server-port=" "%~dp0server.properties"') do (
    set "S_PORT=%%a"
    echo [DEBUG] Captured Port: "%%a"
)

if "%S_PORT%"=="" (
    echo [ERROR] Could not find server-port in server.properties!
)

:: 3. Send signal to the Bot
echo [Updater] Signaling Bot: %MODE% [%S_IPV6%]:%S_PORT%
"%PYTHON_EXE%" mc_announce.py on "%SERVER_NAME%" "%S_IPV6%" "%S_PORT%"

if %ERRORLEVEL% NEQ 0 (
	echo [ERROR] mc_announce.py failed to send signal!
) else (
	echo [DEBUG] Successfully signaled bot.
)

popd
echo [DEBUG] Returned to: "%CD%"
echo [DEBUG] Script complete.
:eof