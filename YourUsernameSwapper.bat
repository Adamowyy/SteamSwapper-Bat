@echo off

rem --- First we will check your logged in account.. ---
for /f "tokens=3" %%i in ('reg query "HKCU\Software\Valve\Steam" /v AutoLoginUser 2^>nul ^| find "REG_SZ"') do (
    if "%%i"=="%~n0" (
		echo -----
		echo You are already logged in as "%~n0"!
		echo -----
		pause
		exit
rem --- ..and if the current user is not the same as filename, we can change the account ---
    ) else (
		powershell -window minimized -command ""
rem --- Kill the Steam process and set the username from filename in AutoLogin so that Steam recognises your saved account. ---
		taskkill.exe /F /IM steam.exe
        reg add "HKCU\Software\Valve\Steam" /v AutoLoginUser /t REG_SZ /d "%~n0" /f
        reg add "HKCU\Software\Valve\Steam" /v RememberPassword /t REG_DWORD /d 1 /f
		timeout /t 3 /nobreak  >nul 2>&1
        start steam://open/main
rem (If you wish, you can delete from here..)
rem --- This code will minimise the Steam window to the system tray when opened (If you wish, you can delete this)
		timeout /t 10 /nobreak  >nul 2>&1
        tasklist /FI "IMAGENAME eq steamwebhelper" 2>NUL | find /I /N "steamwebhelper">NUL
        if "%ERRORLEVEL%"=="0" (
            powershell -command "(Get-Process -Name 'steamwebhelper').MainWindowHandle | ForEach-Object { Add-Type -MemberDefinition '[DllImport(\"user32.dll\")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);' -Name Win32 -Namespace Utils -PassThru | Out-Null; [Utils.Win32]::ShowWindowAsync($_, 0) | Out-Null }"
        )
rem (..to there)

rem --- If you want to start your game after switching account, simply remove "rem" below and add the correct game location.exe. ---
        rem start "Game" "C:\Program Files (x86)\Steam\steamapps\common\Game.exe"
		exit
    )
	powershell -window normal -command ""
	echo Script launch failed!
	echo If you need help: (Discord: xadamowy or Telegram: @AdamowY)
	pause
	exit
)
