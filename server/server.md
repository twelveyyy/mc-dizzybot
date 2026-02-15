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
   @echo off
   :: ############### ABOVE ###############
   echo [Launcher] Notifying DizzyBot (Online)...
   call "%~dp0notifyDizzy.bat" on
   echo [Launcher] Starting Minecraft Forge...
   start "" /b ^
   :: ############### ABOVE ###############
   
   java @user_jvm_args.txt @libraries/net/minecraftforge/forge/1.20.1-47.4.16/win_args.txt %*
   
   :: ############### BELOW ###############
   :: Get the newest java process (the one we just launched)
   for /f "tokens=2 delims=," %%p in ('
       wmic process where "name='java.exe'" get processid /format:csv ^| findstr /r "[0-9]"
   ') do (
       set SERVER_PID=%%p
   )
   echo [Launcher] Server PID = %SERVER_PID%
   echo %SERVER_PID% > "%~dp0server.pid"
   echo [Launcher] Starting watchdog...
   start "" /min cmd /c "%~dp0watchServer.bat %SERVER_PID%"
   pause
   :: ############### BELOW ###############
   ```
   - **Always start the server using `startServer.bat`**
