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
		FALSE		Kdenlive		"Free, Open-source, Non-Linear Video Editor by KDE"\
		FALSE 		Spotify			"Spotify Music Player"\
		TRUE 		VLC 			"VLC Media Player" );
	
	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$AAV"  ]]; then
		zenity --warning\
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in the names in "Software(s)" column, also IFS unset later
		IFS=$'\n'

		for option in $(echo $AAV | tr "|" "\n"); do

			case $option in

			"Kdenlive")			#Free, Open-source, Non-Linear Video Editor by KDE
					#if already present, don't install
					if [[ $(which kdenlive | grep -w "kdenlive" | awk {'print $0'}) ]]; then
						zenity --info --timeout 5\
						--text="\nKdenlive Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
					else
						#Adding ppa for Kdenlive
						(sudo add-apt-repository -y ppa:kdenlive/kdenlive-stable 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null
						
						#Refreshing apt-get
						(sudo apt-get update 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null

						#Installing Kdenlive
						(sudo apt-get -y install kdenlive 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null

						#Installation Complete Dialog
						zenity --info --timeout 5\
						--text="\nInstallation Complete\t\t"\
						--title "Kdenlive" --no-wrap 2>/dev/null
					fi
				;;

			"Spotify")		#Spotify Music Player

					source "$(dirname \"${0}\")"/Scripts/Function/SNAP_INSTALL.sh
					
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "spotify" "Spotify" "spotify"
				;;

			"VLC")			#VLC Media Player
			
					source "$(dirname \"${0}\")"/Scripts/Function/SNAP_INSTALL.sh

					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "vlc" "VLC" "vlc"
				;;
			esac
		done
	fi
	unset IFS
#----------------- AUDIO & VIDEO end ------------------#

#--------- COMMUNICATION & BROWSERS ----------#
	CNB=$( zenity --list --checklist\
		2>/dev/null --height=480 --width=720\
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		Discord			"All-in-one voice and text chat for Gamers"\
		TRUE 		'Google Chrome' 	"A cross-platform web browser by Google"\
		FALSE		'Telegram Desktop'	"Official Desktop Client for the Telegram Messenger" );
	
	
	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$CNB"  ]]; then
		zenity --warning\
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
		IFS=$'\n'

		for option in $(echo $CNB | tr "|" "\n"); do

			case $option in

			"Discord")				#Discord
						
					source "$(dirname \"${0}\")"/Scripts/Function/SNAP_INSTALL.sh
					
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "discord" "Discord" "discord"
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

			"Telegram Desktop")		#Official Desktop Client for the Telegram Messenger
						
					source "$(dirname \"${0}\")"/Scripts/Function/SNAP_INSTALL.sh
					
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "telegram-desktop" "Telegram Desktop" "telegram-desktop"
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
		TRUE		'Git'			"A Fast, Scalable, Distributed Free & Open-Source VCS"\
		TRUE 		Stacer 			"Linux System Optimizer & Monitoring"\
		FALSE		'Visual Studio Code'	"A Free Source-Code Editor made by Microsoft (vscode)" );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$UTIL"  ]]; then
		zenity --warning\
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
		IFS=$'\n'

		for option in $(echo $UTIL | tr "|" "\n"); do

			case $option in

			"Android Studio")		#Android Studio IDE
					
					source "$(dirname \"${0}\")"/Scripts/Function/SNAP_INSTALL.sh
					
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "android-studio --classic" "Android Studio" "android-studio"
						
				;;

			"Git")				#A fast, scalable, distributed free & open-source VCS
					#if already present, don't install
					if [[ $(which git | grep -w "git" | awk {'print $0'}) ]]; then
						zenity --info --timeout 5\
						--text="\nGit Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
					else
						#Installing Git
						(sudo apt-get -y install git 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null

						#Setup Git name & email? (if installed)
						if [[ $(which git | grep -w "git" | awk {'print $0'}) ]]; then
							zenity --question --title="Git Setup" \
							--text="\nDo you want to Setup Git Name &amp; Email right now?" --width=720 --no-wrap \
							2>/dev/null
							#If Yes, setup
							if [[ $? -eq 0 ]]; then
								#git username
								username=$(zenity --entry --title="Git Setup" --text="Enter Git Username" --width=480 2>/dev/null)
								#if $username isn't blank, execute command
								if [[ ! -z "$username" ]]; then
									git config --global user.name "\"$username\""
								fi
								#git useremail
								useremail=$(zenity --entry --title="Git Setup" --text="Enter Git Email" --width=480 2>/dev/null)
								#if $useremail isn't blank, execute command
								if [[ ! -z "$useremail" ]]; then
									git config --global user.email "\"$useremail\""
								fi
							fi
						fi

						#Installation Complete Dialog
						zenity --info --timeout 5\
						--text="\nInstallation Complete\t\t"\
						--title "Git" --no-wrap 2>/dev/null
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

			"Visual Studio Code")		#A Free Source-Code Editor made by Microsoft (vscode)
					
					source "$(dirname \"${0}\")"/Scripts/Function/SNAP_INSTALL.sh
					
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "code --classic" "Visual Studio Code" "code"
				;;
			esac
		done
	fi
	unset IFS
#-------------------- UTILITIES end -------------------#

	if [[ ! -z $AAV || ! -z $CNB || ! -z $UTIL ]]; then
		#notify-send cannot work as root
		USER=$(cat /etc/passwd|grep 1000|sed "s/:.*$//g");
		su $USER -c "/usr/bin/notify-send -u normal 'Complete' 'Softwares Installed'"
	fi
fi
