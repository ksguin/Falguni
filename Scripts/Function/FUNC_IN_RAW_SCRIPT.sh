#!/bin/bash

#--How to USE--#
# RUN_UPDATE_MANAGER_ONCE
#--------------#
RUN_UPDATE_MANAGER_ONCE() {
	if [ -f .flagfile.txt ]; then
		if [[ $(head -1 ".flagfile.txt" | grep -wl "DONE" ) ]] ; then	#error
			:
		else
			rm .flagfile.txt
			echo "DONE" > .flagfile.txt
			sudo update-manager 2>/dev/null
		fi
	else
		echo "DONE" > .flagfile.txt
		sudo update-manager 2>/dev/null
	fi
}


#--How to USE--#
# CHECK_ZENITY_ELSE_INSTALL
#--------------#
CHECK_ZENITY_ELSE_INSTALL() {
	# check if zenity is installed, if not install it
	if [ "$(dpkg -l | awk '/zenity/ {print }'|wc -l)" -ge 1 ]; then
  	:
	else
  		sudo apt install zenity -y
	fi
}

#--How to USE--#
# IF_NOT_SUPERUSER 
#--------------#
IF_NOT_SUPERUSER() {
	ScriptName=$1
	#every zenity command will have height=480 and width=720 for the sake of uniformity
	zenity --error --icon-name=error --title="ROOT permission required!" --text="\nThis script requires ROOT permission. Run with sudo!" --no-wrap 2>/dev/null
	notify-send -u normal "ERROR" "Re-run $1"
}


#--How to USE--#
# COMPLETION_NOTIFICATION "<Title of Notification within single quotes>" "<Text in the notification within single quotes>"
#--------------#
COMPLETION_NOTIFICATION() {
	Title=$1
	Text=$2
	
	#notify-send cannot work as root
	USER=$(cat /etc/passwd|grep 1000|sed "s/:.*$//g");
	su $USER -c "/usr/bin/notify-send -u normal '$Title' '$Text'"
}


