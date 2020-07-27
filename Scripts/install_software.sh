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
						sudo snap install spotify 2>&1 | \
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
						sudo snap install vlc 2>&1 | \
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

#--------- COMMUNICATION & BROWSERS ----------#
	CNB=$( zenity --list --checklist\
		2>/dev/null --height=480 --width=720\
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		Discord			"All-in-one voice and text chat for Gamers"\
		FALSE 		'Google Chrome' 	"A cross-platform web browser by Google" );
	
	#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
	IFS=:

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$CNB"  ]]; then
		zenity --warning\
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		for option in $(echo $CNB | tr "|" "\n"); do

			case $option in

			"Discord")		#Discord
					#if already present, don't install
					if [[ "discord" == $(snap list | awk {'print $1'} | grep 'discord') ]]; then
						zenity --info --timeout 5\
						--text="\nDiscord Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
					else
						sudo snap install discord 2>&1 | \
						tee >( \
						zenity --progress --pulsate --width=720\
						--text="Downloading Discord..." --auto-kill --auto-close --no-cancel\
						2>/dev/null)
				
						#Installation Complete Dialog
						zenity --info --timeout 5\
						--text="\nInstallation Complete\t\t"\
						--title "Discord" --no-wrap 2>/dev/null
					fi
				;;

			"Google Chrome")			#Google Chrome web browser
					#if already present, don't install
					if [[ $(which google-chrome-stable | grep -w "google-chrome-stable" | awk {'print $0'}) ]]; then
						zenity --info --timeout 5\
						--text="\nGoogle Chrome Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
					else
						wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
						sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
						
						#Refreshing apt
						(sudo apt update 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null

						#Installing Google Chrome
						(sudo apt-get -y install google-chrome-stable 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null

						#Installation Complete Dialog
						zenity --info --timeout 5\
						--text="\nInstallation Complete\t\t"\
						--title "Google Chrome" --no-wrap 2>/dev/null
					fi
				;;
			esac
		done
	fi
	unset IFS
#------------ COMMUNICATION & BROWSERS end ------------#

#----------------- UTILITIES -----------------#
	UTIL=$( zenity --list --checklist\
		2>/dev/null --height=480 --width=720\
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
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

			"Stacer")			#Stacer Linux Optimizer & Monitoring
					#if already present, don't install
					if [[ $(which stacer | grep -w "stacer" | awk {'print $0'}) ]]; then
						zenity --info --timeout 5\
						--text="\nStacer Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
					else
						#Adding ppa for Stacer
						(sudo add-apt-repository -y ppa:oguzhaninan/stacer 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null
						
						#Refreshing apt-get
						(sudo apt-get update 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null

						#Installing Stacer
						(sudo apt-get -y install stacer 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null

						#Installation Complete Dialog
						zenity --info --timeout 5\
						--text="\nInstallation Complete\t\t"\
						--title "Stacer" --no-wrap 2>/dev/null
					fi
				;;
			esac
		done
	fi
	unset IFS
#-------------------- UTILITIES end -------------------#
fi
