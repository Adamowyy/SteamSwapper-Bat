@echo off
setlocal enabledelayedexpansion

TITLE SteamSwapper

rem --- First we will check your logged in account.. ---
for /f "tokens=3" %%i in ('reg query "HKCU\Software\Valve\Steam" /v AutoLoginUser 2^>nul ^| find "REG_SZ"') do (
	color 0E
	echo -----
	echo You are already logged in as "%%i"!
	echo -----
	echo Choose your account:

	rem -!- NAME OF YOUR ACCOUNTS DISPLAYED IN THE WINDOW (put here whatever you want) -!-
	echo 1. "YourAccount1"
	echo 2. "YourAccount2"
	rem echo 3. "PutYour3rdUsername"
	rem echo 4. "PutYour4thUsername"

	echo -----
	set /P "Select=Enter the number: "

	rem -!- PUT YOUR STEAM USERNAME BELOW -!- 
	if "!Select!"=="1" ( set "login=YourUsername1" )
	if "!Select!"=="2" ( set "login=YourUsername2" )
	rem if "!Select!"=="3" ( set "login=PutYour3rdUsername ")
	rem if "!Select!"=="4" ( set "login=PutYour4thUsername ")

	if "!login!"=="%%i" (
		cls
		color 0C
		echo -----
		echo You are already logged in to this account. Choose another one.
		echo -----
		pause
		exit
	) else (
		if "!login!"=="" (
			cls
			color 0C
			echo -----
			echo You don't have "!Select!" account.
			echo Having trouble adding another account? I'll help - Discord: xadamowy or Telegram: @AdamowY
			echo -----
			pause
			exit
		) else (
			powershell -window minimized -command ""
			rem --- Check if the Steam process is running and kill it ---
			tasklist /FI "IMAGENAME eq steam.exe" 2>NUL | find /I "steam.exe">NUL
			if "!ERRORLEVEL!"=="0" (
				taskkill.exe /F /IM steam.exe
			)

			rem --- Set the username in AutoLogin so that Steam recognises your saved account and open steam ---
			reg add "HKCU\Software\Valve\Steam" /v AutoLoginUser /t REG_SZ /d !login! /f
			reg add "HKCU\Software\Valve\Steam" /v RememberPassword /t REG_DWORD /d 1 /f
			cls
			echo Shh... Don't look. I will start Steam for you. Just wait..
			timeout /t 3 /nobreak  >nul 2>&1
			start steam://open/main

			exit
		)
	)
	echo Script launch failed.
	echo If you need help: Discord: xadamowy or Telegram: @AdamowY
	pause
	exit
)
