#!/bin/bash

#Inclusion of Essential Scripts
source ./Scripts/Function/FIND_EXECUTE_SCRIPT.sh
FIND_EXECUTE_SCRIPT /Scripts/Function/ FUNC_IN_RAW_SCRIPT.sh

if [[ $EUID -ne 0 ]]; then
	echo "Run with sudo";
	exit 0
else
	RUN_UPDATE_MANAGER_ONCE
fi

# check if zenity is installed
CHECK_ZENITY_ELSE_INSTALL

# run only if a superuser
if [[ $EUID -ne 0 ]]; then
	IF_NOT_SUPERUSER $(basename "$0")
   	exit 1
else
	#Zenity Checklist for all the scripts
	SEL=$( zenity --list --checklist\
		2>/dev/null --height=480 --width=720\
		--text="Don't worry! You will get sub-choices for each selection."\
		--ok-label "Start" --cancel-label "Exit"\
		--column "Pick" --column "Operation" 	--column "Description"\
		TRUE		LANGUAGE		"Tweaks Language Settings"\
		TRUE 		FONT			"Deletes Unnecessary Fonts"\
		TRUE 		BLOATWARE 		"Deletes Pre-installed Softwares"\
		TRUE		INSTALL			"Installs Your Preferred Softwares"\
		FALSE		"ADDITIONAL TWEAKS"	"Some Additional System Settings" );

	# pressed Cancel or closed the dialog window 
	if [[ $? -eq 1 ]]; then 
  		zenity --warning --title="Cancelled"\
		--text "\nOperation cancelled by user. Nothing will be done!"\
		2>/dev/null --no-wrap
	elif [[ -z "$SEL"  ]]; then
		zenity --warning\
		--text "\nNo Option Selected. Nothing will be done!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in checklist to work eg. "ADDITIONAL TWEAKS"
		IFS=$'\n'

		for option in $(echo $SEL | tr "|" "\n"); do

			case $option in

			"LANGUAGE")	#Language setup script
					FIND_EXECUTE_SCRIPT /Scripts/ delete_language.sh
				;;

			"FONT")		#Font deletion script
					FIND_EXECUTE_SCRIPT /Scripts/ delete_font.sh
				;;

			"BLOATWARE")	#Bloatware deletion script
					FIND_EXECUTE_SCRIPT /Scripts/ delete_bloat.sh
				;;

			"INSTALL")	#Software Installation script
					FIND_EXECUTE_SCRIPT /Scripts/ install_software.sh
				;;

			"ADDITIONAL TWEAKS") 	#Additonal Settings Script
					FIND_EXECUTE_SCRIPT /Scripts/ additional_tweaks.sh
				;;
			esac
		done	
		
	fi
	unset IFS

	if [[ ! -z $SEL ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Enjoy your system!'
	fi
fi
