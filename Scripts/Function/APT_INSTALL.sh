#!/bin/bash

#--How to USE--#
# APT_INSTALL_PPA_UPDATE_INSTALL "<PPA>" "<apt software code e.g. kdenlive>" "Package Display name in UI" "<package name in apt list>"
#--------------#

APT_INSTALL_PPA_UPDATE_INSTALL() {
	PPA=$1
	software=$2
	Name=$3
	Aptlisting=$4
	
	#if already present, don't install
	if [[ $(which $Aptlisting | grep -w "$Aptlisting" | awk {'print $0'}) ]]; then
		zenity --info --timeout 5\
		--text="\n$Name Already Installed\t\t"\
		--title "Installed" --no-wrap 2>/dev/null
	else
		#Adding ppa
		(sudo add-apt-repository -y $PPA 2>/dev/null | \
		tee >(xargs -I % echo "#%")) | \
		zenity --progress --width=720 --pulsate --title="$Name: $PPA" \
		--no-cancel --auto-kill --auto-close 2>/dev/null
		
		#Refreshing apt
		APT_REFRESH
		
		#Installing
		(sudo apt-get -y install $software 2>/dev/null | \
		tee >(xargs -I % echo "#%")) | \
		zenity --progress --width=720 --pulsate --title="$Name" \
		--no-cancel --auto-kill --auto-close 2>/dev/null
		
		#Installation Complete Dialog
		INSTALLATION_COMPLETE $Name
	fi		
}


#--How to USE--#
# APT_REFRESH
#--------------#

APT_REFRESH() {
	(sudo apt update 2>/dev/null | \
	tee >(xargs -I % echo "#%")) | \
	zenity --progress --width=720 --pulsate --title="Refreshing Apt List" \
	--no-cancel --auto-kill --auto-close 2>/dev/null
}

INSTALLATION_COMPLETE() {
	Name=$1
	
	zenity --info --timeout 5\
	--text="\nInstallation Complete\t\t"\
	--title "$Name" --no-wrap 2>/dev/null
}
