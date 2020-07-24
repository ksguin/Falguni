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
	#Zenity Checklist for all the scripts
	SEL=$( zenity --list --checklist\
		2>/dev/null --height=480 --width=720\
		--text="Don't worry! You will get sub-choices for each selection."\
		--ok-label "Remove" --cancel-label "Exit"\
		--column "Pick" --column "Remove What" 	--column "Description"\
		TRUE 		FONT			"Deletes Unnecessary Fonts"\
		TRUE 		BLOATWARE 		"Deletes Pre-installed Softwares" );

	# pressed Cancel or closed the dialog window 
	if [[ $? -eq 1 ]]; then 
  		zenity --warning --title="Cancelled"\
		--text "\nOperation cancelled by user. Nothing will be removed!"\
		2>/dev/null --no-wrap
	elif [[ -z "$SEL"  ]]; then
		zenity --warning\
		--text "\nNo Option Selected. Nothing will be removed!"\
		2>/dev/null --no-wrap
	else
		for option in $(echo $SEL | tr "|" "\n"); do

			case $option in

			"FONT")		#Font deletion script
				if find ./Scripts/delete_font.sh -quit;	then
					source ./Scripts/delete_font.sh
				else
					zenity --error --title="File Not Found"\
						2>/dev/null --no-wrap\
						--text="\nCannot locate File!"
				fi
				;;

			"BLOATWARE")	#Bloatware deletion script
				if find ./Scripts/delete_bloat.sh -quit; then
					source ./Scripts/delete_bloat.sh
				else
					zenity --error --title="File Not Found"\
						2>/dev/null --no-wrap\
						--text="\nCannot locate File!"
				fi
				;;
			esac
		done	
		
	fi
fi
