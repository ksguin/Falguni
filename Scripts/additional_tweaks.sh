#!/bin/bash

# check if zenity is installed, if not install it
if [ "$(dpkg -l | awk '/zenity/ {print }'|wc -l)" -ge 1 ]; then
  	:
else
  	sudo apt install zenity -y
fi

# run only if a superuser
if [[ $EUID -ne 0 ]]; then
	#every zenity command will have height=480 and width=720 for the sake of uniformity
	zenity --error --icon-name=error --title="ROOT permission required!" --text="\nThis script requires ROOT permission. Run with sudo!" --no-wrap 2>/dev/null
	notify-send -u normal "ERROR" "Re-run "$(basename "$0")""
   	exit 1
else
#if all permissions granted
	TWEAK=$( zenity --list --checklist --multiple\
		2>/dev/null --height=480 --width=720\
		--title="Select options to Tweak"\
		--text="The following Setting(s) will be Modified"\
		--ok-label "Apply" --cancel-label "Skip"\
		--column "Pick" --column "Setting(s)" 	--column "Description"\
		FALSE		'Dual-Boot Time Fix' 		"Sync time on both OS when running Dual Boot with Windows"\
		FALSE		'Turn Bluetooth Off at StartUp'	"Automatically turn Bluetooth Off at system StartUp"\
		 );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$TWEAK"  ]]; then
		zenity --warning\
		--text "\nNo Option Selected. Nothing will be changed!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in the "Setting(s)" column, e.g. 'Dual-Boot Time Fix', also IFS unset later
		IFS=$'\n'

		for option in $(echo $TWEAK | tr "|" "\n"); do
			
			case $option in
			
			"Dual-Boot Time Fix")	
						zenity --question --title=""\
						--text "\nAre you running Dual Boot with Windows? Apply Dual Boot Time Fix?" --no-wrap\
						2>/dev/null
						if [[ $? -eq 0 ]]; then
							sudo timedatectl set-local-rtc 1 --adjust-system-clock
							zenity --info --title="Done" --text="\nTime is now in synchronisation across all OS"\
								--timeout=3 --no-wrap 2>/dev/null
						else
							sudo timedatectl set-local-rtc 0 --adjust-system-clock
							zenity --info --title="Done" --text="\nNothing Changed! Presumably, you already have the correct time!"\
								--timeout=3 --no-wrap 2>/dev/null
						fi	
					;;
			
			"Turn Bluetooth Off at StartUp")
						#if /etc/rc.local already contains "rfkill block bluetooth", then do nothing
						#else append it

						if [ -f /etc/rc.local ]; then
							if [[ $(head -1 "/etc/rc.local" | grep -wl "rfkill block bluetooth" ) ]] ; then	#error
								:	#if the cmd is found, do nothing
							else
								#Append
								echo "rfkill block bluetooth" >> /etc/rc.local
							fi
						else
							#Overwrite
							echo "rfkill block bluetooth" > /etc/rc.local
						fi

						zenity --info --title="Done" --text="\nBluetooth will not start automatically at StartUp"\
						--timeout=3 --no-wrap 2>/dev/null	
					;;
			esac
		done	
	fi
	unset IFS

	if [[ ! -z $TWEAK ]]; then
		#notify-send cannot work as root
		USER=$(cat /etc/passwd|grep 1000|sed "s/:.*$//g");
		su $USER -c "/usr/bin/notify-send -u normal 'Complete' 'Additional Tweaks'"
	fi
fi
