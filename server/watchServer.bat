@echo off
setlocal enableextensions

title Server Watchdog
echo [Watcher] Feuerbereit!
echo [Watcher] Woof woof! This is the watchdog for your server.
echo [Watcher] Pretty please :pleading: DO NOT close this; otherwise the notification breaks

:: Validate argument
set "SERVER_PID=%~1"

if "%SERVER_PID%"=="" (
    echo [Watcher][ERROR]: No PID provided.
    exit /b 1
)

:: Ensure PID is numeric
for /f "delims=0123456789" %%A in ("%SERVER_PID%") do (
    echo [Watcher][ERROR]: Invalid PID "%SERVER_PID%"
    exit /b 1
)

echo [Watcher] Monitoring PID %SERVER_PID%...
echo.

:loop
timeout /t 5 /nobreak >nul

:: Check if process exists
tasklist /fi "PID eq %SERVER_PID%" | find " %SERVER_PID% " >nul
if errorlevel 1 (
    echo [Watcher] Server stopped
    call "%~dp0notifyDizzy.bat" off
    echo [Watcher] OFF SIGNAL passed to notifyDizzy.bat
    echo [Starter]: Exiting..
    echo [Starter]: Closing in 3 seconds (Press Ctrl+C to keep terminal open)
    timeout /t 3
    exit /b
)

goto loop