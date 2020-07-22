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
# if all permissions granted
	
#--------- AUDIO ---------#
	# selecting Audio Software(s) to uninstall
	AUDIO=$( zenity --list --multiple --title "Select items to Uninstall"\
				--text "The following Audio Software(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)" --column "Description"\
				TRUE rhythmbox "RhythmBox Music Player");

	#column="2" is sent to output by default
	#removing the selected Audio Software(s)
	(
		for i in $(echo $AUDIO | tr "|" "\n") ;
		do
			echo -e "#Removing $i";
			sudo apt-get autoremove --purge -y $i
		done
	) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Audio Software(s)" 2>/dev/null


#--------- EMAIL CLIENT ---------#
	# selecting Email Client(s) to uninstall
	EMAIL=$( zenity --list --multiple --title "Select items to Uninstall"\
				--text "The following Email Client(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)"\
				TRUE evolution );

	#removing the selected Email Client(s)
	(
		for i in $(echo $EMAIL | tr "|" "\n") ;
		do
			echo -e "#Removing $i";
			sudo apt-get autoremove --purge -y $i
		done
	) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Email Client(s)" 2>/dev/null


#--------- GAMES ---------#
	# selecting Game(s) to uninstall
	GAME=$( zenity --list --multiple --title "Select items to Uninstall"\
				--text "The following Game(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)"\
				TRUE aisleriot\
				TRUE gnome-mahjongg\
				TRUE gnome-mines\
				TRUE gnome-sudoku\
				TRUE quadrapassel );

	#removing the selected Game(s)
	(
		for i in $(echo $GAME | tr "|" "\n") ;
		do
			echo -e "#Removing $i";
			sudo apt-get autoremove --purge -y $i
		done
	) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Game(s)" 2>/dev/null


#--------- PHOTO ---------#
	# selecting Photo Software(s) to uninstall
	PHOTO=$( zenity --list --multiple --title "Select items to Uninstall"\
				--text "The following Photo Software(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)"\
				TRUE cheese\
				FALSE eog\
				TRUE gimp\
				TRUE shotwell );

	#removing the selected Photo Software(s)
	(
		for i in $(echo $PHOTO | tr "|" "\n") ;
		do
			echo -e "#Removing $i";
			sudo apt-get autoremove --purge -y $i
		done
	) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Photo Software(s)" 2>/dev/null


#--------- UTILITY ---------#
	# selecting Utility Software(s) to uninstall
	UTILITY=$( zenity --list --multiple --title "Select items to Uninstall"\
				--text "The following Utility Software(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)"\
				TRUE brasero\
				TRUE deja-dup\
				FALSE gnome-font-viewer\
				TRUE gnome-calendar\
				TRUE gnome-characters\
				TRUE gnome-clocks\
				TRUE gnome-contacts\
				TRUE gnome-maps\
				TRUE remmina\
				TRUE yelp );

	#removing the selected Utility Software(s)
	(
		for i in $(echo $UTILITY | tr "|" "\n") ;
		do
			echo -e "#Removing $i";
			sudo apt-get autoremove --purge -y $i
		done
	) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Utility Software(s)" 2>/dev/null


#--------- VIDEO ---------#
	# selecting Video Software(s) to uninstall
	VIDEO=$( zenity --list --multiple --title "Select items to Uninstall"\
				--text "The following Video Software(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)"\
				TRUE pitivi\
				TRUE totem );

	#removing the selected Utility Software(s)
	(
		for i in $(echo $VIDEO | tr "|" "\n") ;
		do
			echo -e "#Removing $i";
			sudo apt-get autoremove --purge -y $i
		done
	) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Video Software(s)" 2>/dev/null
fi
