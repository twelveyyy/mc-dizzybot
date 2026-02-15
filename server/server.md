## READ THE README.MD 

### How it works
1. `startServer.bat` starts the server

2. The script records the Java process PID

3. A minimized background watchdog monitors that PID

4. When Java exits for any reason → OFF announcement is sent

### Installation
1. Copy these 3 files into your minecraft folder - the place with the `server.properties` file.

2. Right-click `notifyDizzy.bat` and select Edit

3. Find this line: `set "BOT_FOLDER="`

4. Change the path to the actual folder where your bot files are saved.
    
   Example: `set "BOT_FOLDER=C:\Users\Admin\Desktop\MyBot"`

5. Creating the launcher `startServer.bat`
   - Assume your start command is (Forge):
   > java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.20.1-47.4.16/win_args.txt %*
   - Create a new file named startServer.bat and wrap the command with the following script:
   ```
   :: -----------------------  ABOVE  -------------------------
   
   @echo off
   
   echo [Starter]: Feuerbereit!
   :: Notify DizzyBot
   call "%~dp0notifyDizzy.bat" on
   echo [Starter]: ON SIGNAL passed to notifyDizzy.bat
   
   :: -----------------------  ABOVE  -------------------------
   
   set "SERVER_ARGS=@user_jvm_args.txt @libraries/net/minecraftforge/forge/1.20.1-47.4.16/win_args.txt %*"
   
   :: -----------------------  BELOW  -------------------------
   
   :: Launch & Capture PID
   for /f "usebackq tokens=*" %%A in (`powershell -Command "Start-Process java -ArgumentList $env:SERVER_ARGS -PassThru | Select-Object -ExpandProperty Id"`) do (
       set SERVER_PID=%%A
   )
   echo [Starter]: Server PID %SERVER_PID%
   :: Start watchdog using the PID as the first argument (%1)
   echo [Starter]: Starting watchdog watchServer.bat
   start "Watchdog" /min "%~dp0watchServer.bat" %SERVER_PID%
   echo [Starter]: Exiting..
   echo [Starter]: Closing in 5 seconds (Press Ctrl+C to keep terminal open)
   timeout /t 5
   exit /b 0
   
   :: -----------------------  BELOW  -------------------------
   ```
   - **Always start the server using `startServer.bat`**
