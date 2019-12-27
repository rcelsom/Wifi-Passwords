@echo off


:show_passwords
	NETSH WLAN SHOW PROFILE
	echo Note: All wifi password combinations are stored in wifiPasswords.txt in current directory
	set printFlag=0
	set /P wifiName="Enter wifi profile name to see password: "
	NETSH WLAN SHOW PROFILE "%wifiName%" KEY=CLEAR > wifiInfoTmpPasswordFinder.txt
	SETLOCAL ENABLEDELAYEDEXPANSION
	for /f "tokens=1, 2 delims=:" %%a in (wifiInfoTmpPasswordFinder.txt) do (
		if "%%a" == "    Key Content            " (
			set tempStr=%%b
			echo Password for "%wifiName%" is "!tempStr:~1%!"
			set printFlag=1
			echo Wifi: "%wifiName%"			Password: "!tempStr:~1%!" >> wifiPasswords.txt
		)
	)
	if %printFlag%==0 (
		echo No password found, WiFi is probably an open network
	)
	del wifiInfoTmpPasswordFinder.txt
	PAUSE
	goto show_passwords
cmd /k