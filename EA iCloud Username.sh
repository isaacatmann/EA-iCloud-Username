#!/bin/bash

# Purpose: to grab iCloud status

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
homedir=$(dscl . -read /Users/$loggedInUser NFSHomeDirectory | cut -d' ' -f2)

if [ ! -f "$homedir"/Library/Preferences/MobileMeAccounts.plist ]; then
	echo "<result>false</result>"
	exit
fi

iCloudStatus=$(/usr/libexec/PlistBuddy -c "print :Accounts:0:AccountID" "$homedir"/Library/Preferences/MobileMeAccounts.plist)

echo "<result>$iCloudStatus</result>"