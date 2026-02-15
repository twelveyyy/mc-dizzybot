@echo off
setlocal enableextensions
title Server Watchdog
echo [Watcher] Feuerbereit!
echo [Watcher] Pretty please :pleading: DO NOT close this.
echo [Watcher] Woof woof! This is the watchdog for your MC server.

:: Validate argument
set "SERVER_PID=%~1"

if "%SERVER_PID%"=="" (
    echo [Watcher][ERROR]: No PID provided.
    pause
    exit /b 1
)

:: Ensure PID is numeric
for /f "delims=0123456789" %%A in ("%SERVER_PID%") do (
    echo [Watcher][ERROR]: Invalid PID "%SERVER_PID%"
    pause
    exit /b 1
)

echo [Watcher] Monitoring PID %SERVER_PID%...
echo.

:loop
timeout /t 5 /nobreak >nul

:: Check if process exists
tasklist /fi "PID eq %SERVER_PID%" | find " %SERVER_PID% " >nul

if errorlevel 1 (
    echo [Watcher] Server stopped!
    echo [Watcher] Triggered notification.
    call "%~dp0notifyDizzy.bat" off
    echo [Starter]: Closing in 3 seconds...
    timeout /t 3
    exit 0
)

goto loop