#!/bin/bash

#Inclusion of Essential Scripts
source ./Scripts/Function/FIND_EXECUTE_SCRIPT.sh
FIND_EXECUTE_SCRIPT /Scripts/Function/ FUNC_IN_RAW_SCRIPT.sh
FIND_EXECUTE_SCRIPT /Scripts/Function/ SNAP_INSTALL.sh
FIND_EXECUTE_SCRIPT /Scripts/Function/ APT_INSTALL.sh

# check if zenity is installed
CHECK_ZENITY_ELSE_INSTALL

# run only if a superuser
if [[ $EUID -ne 0 ]]; then
	IF_NOT_SUPERUSER $(basename "$0")
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
			
					# APT_INSTALL_PPA_UPDATE_INSTALL "<PPA>" "<apt software code e.g. kdenlive>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_PPA_UPDATE_INSTALL "ppa:kdenlive/kdenlive-stable" "kdenlive" "Kdenlive" "kdenlive"
				;;

			"Spotify")		#Spotify Music Player

					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "spotify" "Spotify" "spotify"
				;;

			"VLC")			#VLC Media Player
			
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
						
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "discord" "Discord" "discord"
				;;

			"Google Chrome")			#Google Chrome web browser
					
					Arch=$(GET_SYSTEM_ARCH)
					Url="https://dl.google.com/linux/direct/google-chrome-stable_current_$Arch.deb"
					
					# APT_INSTALL_WGET "<Refined static URL to download>""<Term in .deb package to search for>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_WGET $Url "google-chrome-stable" "Google Chrome" "google-chrome-stable"
				;;

			"Telegram Desktop")		#Official Desktop Client for the Telegram Messenger
						
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
					
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "android-studio" "Android Studio" "android-studio" "--classic"
				;;

			"Git")				#A fast, scalable, distributed free & open-source VCS
					
					#APT_INSTALL_DIRECT "<apt software code e.g. git>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_DIRECT "git" "Git" "git"
					
					#Setup Git name & email? (if installed)
						if [[ $(which git | grep -w "git" | awk {'print $0'}) ]]; then
							zenity --question --title="Git Setup" \
							--text="\nDo you want to Setup Git Name &amp; Email right now?" --width=720 --no-wrap \
							2>/dev/null
							#If Yes, setup
							if [[ $? -eq 0 ]]; then
								#git username
								username=$(zenity --entry --title="Git Setup" --text="Enter Your Name" --width=480 2>/dev/null)
								#if $username isn't blank, execute command
								if [[ ! -z "$username" ]]; then
									git config --global user.name "\"$username\""
								fi
								#git useremail
								useremail=$(zenity --entry --title="Git Setup" --text="Enter Your Email" --width=480 2>/dev/null)
								#if $useremail isn't blank, execute command
								if [[ ! -z "$useremail" ]]; then
									git config --global user.email "\"$useremail\""
								fi
							fi
						fi
				;;

			"Stacer")			#Stacer Linux Optimizer & Monitoring
			
					# APT_INSTALL_PPA_UPDATE_INSTALL "<PPA>" "<apt software code e.g. kdenlive>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_PPA_UPDATE_INSTALL "ppa:oguzhaninan/stacer" "stacer" "Stacer" "stacer"
				;;

			"Visual Studio Code")		#A Free Source-Code Editor made by Microsoft (vscode)
					
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "code" "Visual Studio Code" "code" "--classic"
				;;
			esac
		done
	fi
	unset IFS
#-------------------- UTILITIES end -------------------#

	if [[ ! -z $AAV || ! -z $CNB || ! -z $UTIL ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
