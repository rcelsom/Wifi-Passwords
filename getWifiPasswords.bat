
@echo off

echo -----------PASSWORD FINDER---------------- >wifiPasswords.txt
echo This file is saved in directory: >> wifiPasswords.txt
echo %cd% >> wifiPasswords.txt
echo Last run was on %date% at %time%>>wifiPasswords.txt
echo ------------------------------------------ >>wifiPasswords.txt
NETSH WLAN SHOW PROFILE > wifiNameTmpPasswordFinder.txt
SETLOCAL ENABLEDELAYEDEXPANSION
for /f "tokens=1, 2 delims=:" %%x in (wifiNameTmpPasswordFinder.txt) do (
	if "%%x" == "    All User Profile     "	(
		set wifiName=%%y
		set wifiName=!wifiName:~1%!
		echo Getting info for !wifiName!...
		set printFlag=0
		NETSH WLAN SHOW PROFILE ^"!wifiName!^" KEY=CLEAR > wifiInfoTmpPasswordFinder.txt
		for /f "tokens=1, 2 delims=:" %%a in (wifiInfoTmpPasswordFinder.txt) do (
			if "%%a" == "    Key Content            " (
				set tempStr=%%b
				set printFlag=1
				echo ------------------------------------------ >>wifiPasswords.txt
				echo Wifi: "!wifiName!"	>>wifiPasswords.txt
				echo Password: "!tempStr:~1%!" >> wifiPasswords.txt
				echo ------------------------------------------ >>wifiPasswords.txt
			)
		)
		if !printFlag!==0	(
				echo ------------------------------------------ >>wifiPasswords.txt
				echo Wifi:"!wifiName!" >> wifiPasswords.txt
				echo Password: None >> wifiPasswords.txt
				echo ------------------------------------------ >>wifiPasswords.txt
		)
	del wifiInfoTmpPasswordFinder.txt
	)
)
del wifiNameTmpPasswordFinder.txt

start wifiPasswords.txt