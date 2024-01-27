@echo off
setlocal enabledelayedexpansion

rem --- First we will check your logged in account.. ---
for /f "tokens=3" %%i in ('reg query "HKCU\Software\Valve\Steam" /v AutoLoginUser 2^>nul ^| find "REG_SZ"') do (
	if "%%i"=="%~n0" (
		tasklist /FI "IMAGENAME eq steam.exe" 2>NUL | find /I /N "steam.exe">NUL
		if "!ERRORLEVEL!"=="0" (
			color 0C
			echo -----
			echo You are already logged in as "%~n0".
			echo -----
			pause
			exit
		) else (
			color 0E
			echo -----
			echo You are already logged in as "%~n0", but Steam is not running.
			echo -----
			echo Open Steam?
			echo.
			echo 1. Yes
			echo 2. No
			echo.
			CHOICE /C 12 /N /M "Enter your choice:"
			if errorlevel 2 (
				exit
			) else (
				start steam://open/main
				exit
			)
		)
	) else (
		powershell -window minimized -command ""
		rem --- Check if the Steam process is running and kill it ---
		tasklist /FI "IMAGENAME eq steam.exe" 2>NUL | find /I /N "steam.exe">NUL
		if "!ERRORLEVEL!"=="0" (
			taskkill.exe /F /IM steam.exe
		)
		rem --- Set the username in AutoLogin so that Steam recognises your saved account and open steam ---
		reg add "HKCU\Software\Valve\Steam" /v AutoLoginUser /t REG_SZ /d "%~n0" /f
		reg add "HKCU\Software\Valve\Steam" /v RememberPassword /t REG_DWORD /d 1 /f
		cls
		echo Shh... Don't look. I will start Steam for you. Just wait..
		timeout /t 3 /nobreak  >nul 2>&1
		start steam://open/main

		rem 1. (If you wish, you can delete from here..)
		rem --- This code will minimise the Steam window to the system tray when opened (If you wish, you can delete this)
		timeout /t 10 /nobreak  >nul 2>&1
		tasklist /FI "WINDOWTITLE eq Steam" 2>NUL | find /I "Steam" >NUL
		if "!ERRORLEVEL!"=="0" (
			taskkill /FI "WINDOWTITLE eq Steam"
		)
		rem 1. (..to there)

		rem --- Optional: Start a game after switching account (REMOVE "REM" from "START" below) ---
		rem start "Game" "C:\Program Files (x86)\Steam\steamapps\common\Game.exe"

		exit
	)
	echo Script launch failed.
	echo If you need help: Discord: xadamowy or Telegram: @AdamowY
	pause
	exit
)
