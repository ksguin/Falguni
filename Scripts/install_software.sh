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
		2>/dev/null --height=480 --width=720 --window-icon="./Icons/falguni.png" \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE		Kdenlive		"Free, Open-source, Non-Linear Video Editor by KDE"\
		FALSE 		Spotify			"Spotify Music Player"\
		TRUE 		VLC 			"VLC Media Player" );
	
	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$AAV"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in the names in "Software(s)" column, also IFS unset later
		IFS=$'\n'

		for option in $(echo $AAV | tr "|" "\n"); do

			case $option in

			"Kdenlive")			#Free, Open-source, Non-Linear Video Editor by KDE
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "kdenlive.png" "https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/kdenlive-icon.png"
					# APT_INSTALL_PPA_UPDATE_INSTALL "<PPA>" "<apt software code e.g. kdenlive>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_PPA_UPDATE_INSTALL "ppa:kdenlive/kdenlive-stable" "kdenlive" "Kdenlive" "kdenlive"
				;;

			"Spotify")		#Spotify Music Player
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "spotify.png" "https://icons.iconarchive.com/icons/dakirby309/simply-styled/64/Spotify-icon.png"
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "spotify" "Spotify" "spotify"
				;;

			"VLC")			#VLC Media Player
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "vlc.png" "https://icons.iconarchive.com/icons/cornmanthe3rd/plex/64/Media-vlc-icon.png"
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
		2>/dev/null --height=480 --width=720 --window-icon="./Icons/falguni.png" \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		TRUE		'Brave'			"Secure, Fast & Private Brave Browser with Adblocker"\
		FALSE 		Discord			"All-in-one voice and text chat for Gamers"\
		FALSE 		'Google Chrome' 	"A cross-platform web browser by Google"\
		FALSE		'Signal'		"Signal - Private Messenger: Say Hello to Privacy"\
		FALSE		'Telegram Desktop'	"Official Desktop Client for the Telegram Messenger" );
	
	
	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$CNB"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
		IFS=$'\n'

		for option in $(echo $CNB | tr "|" "\n"); do

			case $option in
			
			"Brave")				#Brave Browser
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "brave-browser.png" "https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/brave-icon.png"
					
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "brave" "Brave" "brave"
				;;

			"Discord")				#Discord
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "discord.png" "https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/discord-icon.png"
					Url="https://discordapp.com/api/download?platform=linux&format=deb"
					
					#APT_INSTALL_WGET "<Refined static URL to download>""<Term in .deb package to search for>" "Package Display name in UI" "<package name in apt list>" "<-O name_of_deb_you_want.deb>"
					APT_INSTALL_WGET $Url "discord" "Discord" "discord" "-O discord.deb"
				;;

			"Google Chrome")			#Google Chrome web browser
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "google-chrome-stable.png" "https://icons.iconarchive.com/icons/google/chrome/64/Google-Chrome-icon.png"
					
					Arch=$(GET_SYSTEM_ARCH)
					Url="https://dl.google.com/linux/direct/google-chrome-stable_current_$Arch.deb"
					
					# APT_INSTALL_WGET "<Refined static URL to download>""<Term in .deb package to search for>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_WGET $Url "google-chrome-stable" "Google Chrome" "google-chrome-stable"
				;;
				
			"Signal")			#Signal - Private Messenger: Say Hello to Privacy
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "signal-desktop.png" "https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/signal-desktop-icon.png"
					
					PubKey="https://updates.signal.org/desktop/apt/keys.asc"
					RepoCmd="deb [arch=amd64] https://updates.signal.org/desktop/apt xenial main"
					RepoList="/etc/apt/sources.list.d/signal-xenial.list"
					
					#APT_INSTALL_PUBKEY_ADDREPO_INSTALL "<Public software signing key>" "<Repository command to be added>" "<Repository List where it's being added>" "<apt software code e.g. kdenlive>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_PUBKEY_ADDREPO_INSTALL $PubKey $RepoCmd $RepoList "signal-desktop" "Signal" "signal-desktop"
				;;

			"Telegram Desktop")		#Official Desktop Client for the Telegram Messenger
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "telegram-desktop.png" "https://icons.iconarchive.com/icons/froyoshark/enkel/64/Telegram-icon.png"
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
		2>/dev/null --height=480 --width=720 --window-icon="./Icons/falguni.png" \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		'Android Studio'	"Android Studio IDE for Android"\
		TRUE		'Git'			"A Fast, Scalable, Distributed Free & Open-Source VCS"\
		TRUE 		'Stacer' 		"Linux System Optimizer & Monitoring"\
		FALSE		'TeamViewer'		"TeamViewer: The Remote Desktop Software"\
		FALSE		'Visual Studio Code'	"A Free Source-Code Editor made by Microsoft (vscode)" );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$UTIL"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
		IFS=$'\n'

		for option in $(echo $UTIL | tr "|" "\n"); do

			case $option in

			"Android Studio")		#Android Studio IDE
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "android-studio.png" "https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/androidstudio-icon.png"
					#SNAP_INSTALL <snap software installation code> <Package Display name in UI> <package name in snap list>
					SNAP_INSTALL "android-studio" "Android Studio" "android-studio" "--classic"
				;;

			"Git")				#A fast, scalable, distributed free & open-source VCS
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "git.png" "https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/git-icon.png"
					#APT_INSTALL_DIRECT "<apt software code e.g. git>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_DIRECT "git" "Git" "git"
					
					#Setup Git name & email? (if installed)
						if [[ $(which git | grep -w "git" | awk {'print $0'}) ]]; then
							zenity --question --title="Git Setup" --window-icon="./Icons/Install/git.png" \
							--text="\nDo you want to Setup Git Name &amp; Email right now?" --width=720 --no-wrap \
							2>/dev/null
							#If Yes, setup
							if [[ $? -eq 0 ]]; then
								#git username
								username=$(zenity --entry --title="Git Setup" --text="Enter Your Name" --width=480 --window-icon="./Icons/Install/git.png" 2>/dev/null)
								#if $username isn't blank, execute command
								if [[ ! -z "$username" ]]; then
									git config --global user.name "\"$username\""
								fi
								#git useremail
								useremail=$(zenity --entry --title="Git Setup" --text="Enter Your Email" --width=480 --window-icon="./Icons/Install/git.png" 2>/dev/null)
								#if $useremail isn't blank, execute command
								if [[ ! -z "$useremail" ]]; then
									git config --global user.email "\"$useremail\""
								fi
							fi
						fi
				;;

			"Stacer")			#Stacer Linux Optimizer & Monitoring
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "stacer.png" "https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/stacer-icon.png"
					# APT_INSTALL_PPA_UPDATE_INSTALL "<PPA>" "<apt software code e.g. kdenlive>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_PPA_UPDATE_INSTALL "ppa:oguzhaninan/stacer" "stacer" "Stacer" "stacer"
				;;

			"TeamViewer")			#TeamViewer: The Remote Desktop Software
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "teamviewer.png" "https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/teamviewer-icon.png"
					
					Arch=$(GET_SYSTEM_ARCH)
					Url="https://download.teamviewer.com/download/linux/teamviewer_$Arch.deb"
					
					# APT_INSTALL_WGET "<Refined static URL to download>""<Term in .deb package to search for>" "Package Display name in UI" "<package name in apt list>"
					APT_INSTALL_WGET $Url "teamviewer" "TeamViewer" "teamviewer"
				;;
				
			"Visual Studio Code")		#A Free Source-Code Editor made by Microsoft (vscode)
					CHECK_ICON_PRESENT_ELSE_FETCH /Icons/Install/ "code.png" "https://icons.iconarchive.com/icons/papirus-team/papirus-apps/64/visual-studio-code-icon.png"
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
