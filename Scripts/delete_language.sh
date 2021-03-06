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
	LAN=$( zenity --list --checklist --multiple --window-icon="./Icons/falguni.png" \
		2>/dev/null --height=480 --width=720\
		--title="Select items to Remove"\
		--text="The following Language(s) will be Removed"\
		--ok-label "Remove" --cancel-label "Skip"\
		--column "Pick" --column "Language(s)" 	--column "Description"\
		TRUE		'Language Settings' 		"Uninstall unused languages + set Regional format"\
		TRUE		'Language Translations'		"Stop Getting and Remove Language Translations from apt entries"\
		TRUE		ibus-libpinyin			"Chinese Pinyin input method for IBus"\
		 );
	
	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$LAN"  ]]; then
		zenity --warning --window-icon="./Icons/falguni.png" \
		--text "\nNo Option Selected. Nothing will be removed!"\
		2>/dev/null --no-wrap
	else 
		#this is mandatory for the space in the "Language(s)" column, e.g. 'Language Translations', also IFS unset later
		IFS=$'\n'
		
		for option in $(echo $LAN | tr "|" "\n"); do
			
			case $option in

			"Language Settings")
						#invoking gnome-language-selector (GNOME 3)
						(sudo gnome-language-selector 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --title "Running Language Support"\
						--width=720 --pulsate --window-icon="./Icons/falguni.png" \
						--no-cancel --auto-kill --auto-close 2>/dev/null				
					;;
			
			"Language Translations")	
							#Stop Getting & Remove Language Translations from apt entries
						(
						#to stop getting translation files
						sudo sh -c 'echo "Acquire::Languages \"none\";" > /etc/apt/apt.conf.d/99translations'
						) | zenity --progress --window-icon="./Icons/falguni.png" --timeout=1 --width=720 --pulsate --no-cancel --title "Removing Language Translations" 2>/dev/null

						#to remove existing translations
						( sudo rm -r /var/lib/apt/lists/*Translation* 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --window-icon="./Icons/falguni.png" --title "Removing ibus-libpinyin"\
						--width=720 --pulsate \
						--no-cancel --auto-kill --auto-close 2>/dev/null
					;;

			"ibus-libpinyin")
							#Chinese Pinyin input method for IBus
						(sudo apt-get autoremove --purge -y ibus-libpinyin 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --title "Removing ibus-libpinyin"\
						--width=720 --pulsate --window-icon="./Icons/falguni.png" \
						--no-cancel --auto-kill --auto-close 2>/dev/null
					;;
			
			esac
		done	
	fi
	unset IFS

	if [[ ! -z $LAN ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Language SetUp'
	fi
fi
