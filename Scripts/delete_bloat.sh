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
# if all permissions granted
	
#--------- AUDIO ---------#
	# selecting Audio Software(s) to uninstall
	AUDIO=$( zenity --list --multiple --window-icon="./Icons/falguni.png" --title "Select items to Uninstall"\
				--text "The following Audio Software(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)" --column "Description"\
				TRUE rhythmbox "Default Music Player for GNOME");

	#column="2" is sent to output by default
	
	if [[ $? -eq 0 && -z "$AUDIO"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be removed!"\
		2>/dev/null --no-wrap
	else 
	#removing the selected Audio Software(s)
		(
			for i in $(echo $AUDIO | tr "|" "\n") ;
			do
				echo -e "#Removing $i";
				sudo apt-get autoremove --purge -y $i
			done
		) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Audio Software(s)" 2>/dev/null
	fi


#--------- EMAIL CLIENT ---------#
	# selecting Email Client(s) to uninstall
	EMAIL=$( zenity --list --multiple --window-icon="./Icons/falguni.png" --title "Select items to Uninstall"\
				--text "The following Email Client(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)" --column "Description"\
				TRUE 		evolution 		"Default GNOME Email & Personal Information Manager" );
	
	if [[ $? -eq 0 && -z "$EMAIL"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be removed!"\
		2>/dev/null --no-wrap
	else 
	#removing the selected Email Client(s)
		(
			for i in $(echo $EMAIL | tr "|" "\n") ;
			do
				echo -e "#Removing $i";
				sudo apt-get autoremove --purge -y $i
			done
		) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Email Client(s)" 2>/dev/null
	fi


#--------- GAMES ---------#
	# selecting Game(s) to uninstall
	GAME=$( zenity --list --multiple --window-icon="./Icons/falguni.png" --title "Select items to Uninstall"\
				--text "The following Game(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)" --column "Description"\
				TRUE 		aisleriot		"Collection of Card Games"\
				TRUE 		gnome-mahjongg		"Solitare version of Eastern tile game, Mahjongg"\
				TRUE 		gnome-mines		"A Puzzle Game where you locate Mines"\
				TRUE 		gnome-sudoku		"The Japanese logic Game, Sudoku"\
				TRUE 		quadrapassel 		"The classic falling-block Game, Tetris" );

	if [[ $? -eq 0 && -z "$GAME"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be removed!"\
		2>/dev/null --no-wrap
	else 
	#removing the selected Game(s)
		(
			for i in $(echo $GAME | tr "|" "\n") ;
			do
				echo -e "#Removing $i";
				sudo apt-get autoremove --purge -y $i
			done
		) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Game(s)" 2>/dev/null
	fi


#--------- PHOTO ---------#
	# selecting Photo Software(s) to uninstall
	PHOTO=$( zenity --list --multiple --window-icon="./Icons/falguni.png" --title "Select items to Uninstall"\
				--text "The following Photo Software(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)" --column "Description"\
				TRUE 		cheese			"Webcam application for GNOME Desktop"\
				FALSE 		eog			"Eye of GNOME is the Default Image Viewer"\
				TRUE 		gimp			"A versatile Image & Graphics Manipulation Software"\
				TRUE 		shotwell 		"An Image Organizer & simple Image Editor for GNOME" );

	if [[ $? -eq 0 && -z "$PHOTO"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be removed!"\
		2>/dev/null --no-wrap
	else 
	#removing the selected Photo Software(s)
		(
			for i in $(echo $PHOTO | tr "|" "\n") ;
			do
				echo -e "#Removing $i";
				sudo apt-get autoremove --purge -y $i
			done
		) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Photo Software(s)" 2>/dev/null
	fi


#--------- UTILITY ---------#
	# selecting Utility Software(s) to uninstall
	UTILITY=$( zenity --list --multiple --window-icon="./Icons/falguni.png" --title "Select items to Uninstall"\
				--text "The following Utility Software(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)" --column "Description"\
				TRUE 		brasero			"GNOME application to burn CD/DVD"\
				TRUE 		deja-dup		"Simple backup tool for GNOME"\
				FALSE 		gnome-font-viewer	"Shows overview of Installed Fonts in GNOME"\
				TRUE 		gnome-calendar		"Simple & Beautiful Calendar application for GNOME"\
				TRUE 		gnome-characters	"Utility to find & insert unusual characters in GNOME"\
				TRUE 		gnome-clocks		"Stopwatch, timer & world clock in GNOME"\
				TRUE 		gnome-contacts		"Integrated contact address book for GNOME"\
				TRUE 		gnome-maps		"A simple map client for GNOME"\
				TRUE 		remmina			"Default remote desktop client for Linux"\
				TRUE 		yelp 			"Default help viewer in GNOME" );

	if [[ $? -eq 0 && -z "$UTILITY"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be removed!"\
		2>/dev/null --no-wrap
	else 
	#removing the selected Utility Software(s)
		(
			for i in $(echo $UTILITY | tr "|" "\n") ;
			do
				echo -e "#Removing $i";
				sudo apt-get autoremove --purge -y $i
			done
		) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Utility Software(s)" 2>/dev/null
	fi


#--------- VIDEO ---------#
	# selecting Video Software(s) to uninstall
	VIDEO=$( zenity --list --multiple --window-icon="./Icons/falguni.png" --title "Select items to Uninstall"\
				--text "The following Video Software(s) will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove" --cancel-label "Skip"\
				--column "Pick" --column "Software(s)" --column "Description"\
				TRUE 		pitivi		"An open-source, free non-linear video editor for GNOME"\
				TRUE 		totem		"A movie player for GNOME desktop" );
	
	if [[ $? -eq 0 && -z "$VIDEO"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be removed!"\
		2>/dev/null --no-wrap
	else 
	#removing the selected Utility Software(s)
		(
			for i in $(echo $VIDEO | tr "|" "\n") ;
			do
				echo -e "#Removing $i";
				sudo apt-get autoremove --purge -y $i
			done
		) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Video Software(s)" 2>/dev/null
	fi

	if [[ ! -z $AUDIO || ! -z $EMAIL || ! -z $GAME || ! -z $PHOTO || ! -z $UTILITY || ! -z $VIDEO ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Removed'
	fi	
fi
