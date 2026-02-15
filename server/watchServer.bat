@echo off

echo [Watcher] Woof woof! This is a watchdog for your server, please DO NOT close this; This terminal will automatically closes once your servers offline

set SERVER_PROCESS=java.exe

:loop
timeout /t 5 >nul

tasklist /fi "imagename eq %SERVER_PROCESS%" | find /i "%SERVER_PROCESS%" >nul
if errorlevel 1 (
    echo [Watcher] Server stopped — notifying DizzyBot OFF
    call "%~dp0notifyDizzy.bat" off
    exit /b
)

goto loop
