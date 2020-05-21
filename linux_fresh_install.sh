#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   	echo $'This script REQUIRES root permission.\nRun this as root.'
   	exit 1
else

	#Screen Resolution Change (1600x900 16:9 works the best for me)
	#You might comment out the command below to leave it at DEFAULT resolution.
	xrandr --size 1600x900


	#BUG in GNOME 3.08+ (Please find a fix)
#<<------------------------------------------------------------------------------------------------------->>#
	#Touchpad Sensitivity Settings (best for me)
	#You might add/delete the two '#' below to keep/leave it at DEFAULT settings by commenting out the entire thing.
: '
 	gsettings set org.gnome.desktop.peripherals.touchpad speed 1.0
	gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
	gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
	gsettings set org.gnome.desktop.peripherals.touchpad scroll-method 'two-finger-scrolling'
'
#<<------------------------------------------------------------------------------------------------------->>#

	#Disable Language translations (for user who wants English/single-language only)
	

	#-----------------------------------UNINSTALLS---------------------------------------#
	#Put comments before the app category you don't want to remove.
	apt-get --purge remove aisleriot gnome-mahjongg gnome-mines gnome-sudoku			#Games
	apt-get --purge remove rhythmbox rhythmbox-client rhythmbox-plugins rhythmbox-plugin-zeitgeist	#Music Players
	apt-get --purge remove thunderbird evolution							#Email clients
	apt-get --purge remove brasero cheese cheese-common remmina					#Utilities					
	


	#Update, Upgrade, Autoremove & Clean
	echo "Updating and Upgrading..."
	apt-get update && sudo apt-get upgrade -y
	echo "Removing unused dependencies and Cleaning Stuffs..."
	apt-get autoremove
	apt-get clean

	#---------------------------------INSTALLATIONS--------------------------------------#
	sudo apt-get install dialog
	cmd = (dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
	
	options = (	1 "Google Chrome" off    # any option can be set to default to "on"
			2 "VLC" off
	         	3 "Stacer" off
	         	4 "Discord" off
		  )
	
	choices = $("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	clear

		for choice in $choices
		do
		    case $choice in

		1)	#Google Chrome
			cd ~/Downloads
			echo "Downloading Google Chrome..."
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
			echo "Installing..."
			apt install ./google-chrome-stable_current_amd64.deb -y
			rm google-chrome-stable_current_amd64.deb 
			cd
			;;

		2)	#VLC Media Player
			echo "Downloading & Installing VLC..."
			snap install vlc -y
			;;

		3)	#Stacer
			add-apt-repository ppa:oguzhaninan/stacer -y
			apt-get update
			echo "Downloading & Installing Stacer..."
			apt-get install stacer -y
			;;

		4)	#Discord
			echo "Downloading & Installing Discord..."
			snap install discord -y			
			;;

    			esac
		done
fi
