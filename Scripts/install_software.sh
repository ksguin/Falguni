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
	##Communication & Browsers
	#- Google Chrome
	#- Discord

	##Utilities
	#- Stacer
	
#------------- AUDIO & VIDEO -------------#
	AAV=$( zenity --list --checklist\
		2>/dev/null --height=480 --width=720\
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		Spotify			"Spotify Music Player"\
		TRUE 		VLC 			"VLC Media Player" );
	
	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$AAV"  ]]; then
		zenity --warning\
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		for option in $(echo $AAV | tr "|" "\n"); do

			case $option in

			"Spotify")		#Spotify Music Player
					#if already present, don't install
					if [[ "spotify" == $(snap list | awk {'print $1'} | grep 'spotify') ]]; then
						zenity --info --timeout 5\
						--text="\nSpotify Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
					else
						pkexec snap install spotify 2>&1 | \
						tee >( \
						zenity --progress --pulsate --width=720\
						--text="Downloading Spotify..." --auto-kill --auto-close --no-cancel\
						2>/dev/null)
				
						#Installation Complete Dialog
						zenity --info --timeout 5\
						--text="\nInstallation Complete\t\t"\
						--title "Spotify" --no-wrap 2>/dev/null
					fi
				;;

			"VLC")			#VLC Media Player
					#if already present, don't install
					if [[ "vlc" == $(snap list | awk {'print $1'} | grep 'vlc') ]]; then
						zenity --info --timeout 5\
						--text="\nVLC Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
					else
						pkexec snap install vlc 2>&1 | \
						tee >( \
						zenity --progress --pulsate --width=720\
						--text="Downloading VLC..." --auto-kill --auto-close --no-cancel\
						2>/dev/null)
				
						#Installation Complete Dialog
						zenity --info --timeout 5\
						--text="\nInstallation Complete\t\t"\
						--title "VLC" --no-wrap 2>/dev/null
					fi
				;;
			esac
		done
	fi
#----------------- AUDIO & VIDEO end ------------------#

#----------------- UTILITIES -----------------#
	UTIL=$( zenity --list --checklist\
		2>/dev/null --height=480 --width=720\
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Exit"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		'Android Studio'	"Android Studio IDE for Android"\
		FALSE 		Stacer 			"Linux System Optimizer & Monitoring" );
	
	#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
	IFS=:

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$UTIL"  ]]; then
		zenity --warning\
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		for option in $(echo $UTIL | tr "|" "\n"); do

			case $option in

			"Android Studio")		#Android Studio IDE
					#if already present, don't install
					if [[ "android-studio" == $(snap list | awk {'print $1'} | grep 'android-studio') ]]; then
						zenity --info --timeout 5\
						--text="\nAndroid Studio Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
					else
						sudo snap install android-studio --classic 2>&1 | \
						tee >( \
						zenity --progress --pulsate --width=720\
						--text="Downloading Android Studio..." --auto-kill --auto-close --no-cancel\
						2>/dev/null)
				
						#Installation Complete Dialog
						zenity --info --timeout 5\
						--text="\nInstallation Complete\t\t"\
						--title "Android Studio" --no-wrap 2>/dev/null
					fi
				;;
			esac
		done
	fi
	unset IFS
#-------------------- UTILITIES end -------------------#
fi
