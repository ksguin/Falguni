#!/bin/bash

#--How to USE--#
# SNAP_INSTALL "<snap software installation code>" "Package Display name in UI" "<package name in snap list>"
#--------------#

SNAP_INSTALL() {
	software=$1
	Name=$2
	snaplisting=$3
	classicflag=$4
	
	#if already present, don't install
	if [[ "$snaplisting" == $(snap list | awk {'print $1'} | grep $snaplisting) ]]; then
						zenity --info --timeout 5\
						--text="\n$Name Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
	else
		sudo snap install $software $classicflag 2>&1 | \
		tee >( \
		zenity --progress --pulsate --width=720\
		--text="Downloading $Name..." --auto-kill --auto-close --no-cancel\
		2>/dev/null)
			
		#Installation Complete Dialog
		zenity --info --timeout 5\
		--text="\nInstallation Complete\t\t"\
		--title "$Name" --no-wrap 2>/dev/null
	fi
}

					
					
