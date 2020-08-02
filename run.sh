#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "Run with sudo";
	exit 0
else
	if [ -f .flagfile.txt ]; then
		if [[ $(head -1 ".flagfile.txt" | grep -wl "DONE" ) ]] ; then	#error
			:
		else
			rm .flagfile.txt
			echo "DONE" > .flagfile.txt
			sudo update-manager 2>/dev/null
		fi
	else
		echo "DONE" > .flagfile.txt
		sudo update-manager 2>/dev/null
	fi
fi

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
	## Dual Boot Time Fix ##
	zenity --question --title=""\
	--text "\nAre you running Dual Boot with Windows? Apply Dual Boot Time Fix?" --no-wrap\
	2>/dev/null
	if [[ $? -eq 0 ]]; then
		sudo timedatectl set-local-rtc 1 --adjust-system-clock
	else
		sudo timedatectl set-local-rtc 0 --adjust-system-clock
	fi

	#Zenity Checklist for all the scripts
	SEL=$( zenity --list --checklist\
		2>/dev/null --height=480 --width=720\
		--text="Don't worry! You will get sub-choices for each selection."\
		--ok-label "Start" --cancel-label "Exit"\
		--column "Pick" --column "Operation" 	--column "Description"\
		TRUE		LANGUAGE		"Tweaks Language Settings"\
		TRUE 		FONT			"Deletes Unnecessary Fonts"\
		TRUE 		BLOATWARE 		"Deletes Pre-installed Softwares"\
		TRUE		INSTALL			"Installs Your Preferred Softwares" );

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
		for option in $(echo $SEL | tr "|" "\n"); do

			case $option in

			"LANGUAGE")	#Language setup script
				if find ./Scripts/delete_language.sh -quit;	then
					source ./Scripts/delete_language.sh
				else
					zenity --error --title="File Not Found"\
						2>/dev/null --no-wrap\
						--text="\nCannot locate File!"
				fi
				;;

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

			"INSTALL")	#Software Installation script
				if find ./Scripts/install_software.sh -quit; then
					source ./Scripts/install_software.sh
				else
					zenity --error --title="File Not Found"\
						2>/dev/null --no-wrap\
						--text="\nCannot locate File!"
				fi
				;;
			esac
		done	
		
	fi

	if [[ ! -z $SEL ]]; then
		#notify-send cannot work as root
		USER=$(cat /etc/passwd|grep 1000|sed "s/:.*$//g");
		su $USER -c "/usr/bin/notify-send -u normal 'Complete' 'Enjoy your system!'"
	fi
fi
