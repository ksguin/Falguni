#!/bin/bash

#Inclusion of Essential Scripts
source ./Scripts/Function/FIND_EXECUTE_SCRIPT.sh
FIND_EXECUTE_SCRIPT /Scripts/Function/ FUNC_IN_RAW_SCRIPT.sh

# check if zenity is installed
CHECK_ZENITY_ELSE_INSTALL

# run only if a superuser
if [[ $EUID -ne 0 ]]; then
	IF_NOT_SUPERUSER $(basename "$0")
   	exit 1
else
#if all permissions granted
	TWEAK=$( zenity --list --checklist --multiple --window-icon="./Icons/falguni.png" \
		2>/dev/null --height=480 --width=720\
		--title="Select options to Tweak"\
		--text="The following Setting(s) will be Modified"\
		--ok-label "Apply" --cancel-label "Skip"\
		--column "Pick" --column "Setting(s)" 	--column "Description"\
		FALSE		'Dual-Boot Save Last OS Selection'	"Save the Last OS even on restart/shutdown and open by default boot on next boot"\
		FALSE		'Dual-Boot Time Fix' 			"Sync time on both OS when running Dual Boot with Windows"\
		FALSE		'Turn Bluetooth Off at StartUp'		"Automatically turn Bluetooth Off at system StartUp"\
		 );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$TWEAK"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be changed!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in the "Setting(s)" column, e.g. 'Dual-Boot Time Fix', also IFS unset later
		IFS=$'\n'

		for option in $(echo $TWEAK | tr "|" "\n"); do
			
			case $option in
			
			"Dual-Boot Save Last OS Selection")
						zenity --question --window-icon="./Icons/falguni.png" --title=""\
						--text "\nAre you running Dual Boot? Apply Dual-Boot Save Last OS Selection?" --no-wrap\
						2>/dev/null
						if [[ $? -eq 0 ]]; then
							#search for file '/etc/default/grub'
							if [ -f /etc/default/grub ]; then
								#find and replace GRUB_DEFAULT=0 with GRUB_DEFAULT=saved with root permission
								sudo sed -i 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/g' /etc/default/grub
								#only if GRUB_SAVEDEFAULT=true doesn't exist, append it to the file (with root permission)
								grep -qxF "GRUB_SAVEDEFAULT=true" /etc/default/grub || sudo sed -i "$ a GRUB_SAVEDEFAULT=true" /etc/default/grub
								# update-grub for saving changes to system
								(sudo update-grub 2>/dev/null | \
								tee >(xargs -I % echo "#%")) | \
								zenity --progress --window-icon="./Icons/falguni.png" --width=720 --pulsate --title="update-grub" \
								--no-cancel --auto-kill --auto-close 2>/dev/null
							fi
							zenity --info --title="Done" --text="\nLast used OS will open by default boot on next boot"\
								--timeout=3 --no-wrap 2>/dev/null
						else
							zenity --info --title="Done" --text="\nNothing Changed! The first selection in GRUB will open by default."\
								--timeout=3 --no-wrap 2>/dev/null
						fi	
					;;
			
			"Dual-Boot Time Fix")	
						zenity --question --window-icon="./Icons/falguni.png" --title=""\
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

						zenity --info --window-icon="./Icons/falguni.png" --title="Done" --text="\nBluetooth will not start automatically at StartUp"\
						--timeout=3 --no-wrap 2>/dev/null	
					;;
			esac
		done	
	fi
	unset IFS

	if [[ ! -z $TWEAK ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Additional Tweaks'
	fi
fi
