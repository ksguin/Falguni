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
	# selecting fonts to uninstall
	# here SEL=$ cannot contain whitespace
	SEL=$( zenity --list --multiple\
				--text "The following fonts will be removed" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove"\
				--column "Pick" --column "Fonts"\
				TRUE fonts-arabeyes\
				TRUE fonts-arphic-*\
				TRUE fonts-beng*\
				TRUE fonts-droid-fallback\
				TRUE fonts-gargi\
				TRUE fonts-gubbi\
				TRUE fonts-gujr*\
				TRUE fonts-guru*\
				TRUE fonts-kacst*\
				TRUE fonts-kalapi\
				TRUE fonts-khmeros-core\
				TRUE fonts-lao\
				TRUE fonts-lklug-sinhala\
				TRUE fonts-lohit-*\
				TRUE fonts-nakula\
				TRUE fonts-nanum\
				TRUE fonts-navilu\
				TRUE fonts-noto-cjk\
				TRUE fonts-orya-extra\
				TRUE fonts-pagul\
				TRUE fonts-sahadeva\
				TRUE fonts-samyak-*\
				TRUE fonts-sarai\
				TRUE fonts-sil-abyssinica\
				TRUE fonts-sil-padauk\
				TRUE fonts-smc\
				TRUE fonts-takao-pgothic\
				TRUE fonts-telu-extra\
				TRUE fonts-tibetan-machine\
				TRUE fonts-tlwg-*\
				TRUE fonts-wqy-microhei );
	
	#removing all the selected languages
	(
		for i in $(echo $SEL | tr "|" "\n") ;
		do 
			echo -e "#Removing $i";
			sudo apt-get autoremove --purge -y $i
			# For Droid Fonts:
			if [[ $i =~ "fonts-droid_fallback" ]]; then
    				cd /usr/share/fonts/truetype/droid/
				sudo rm DroidKufi-Bold.ttf DroidKufi-Regular.ttf DroidNaskh-Bold.ttf DroidNaskh-Regular.ttf DroidNaskhUI-Regular.ttf DroidSansArabic.ttf DroidSansArmenian.ttf DroidSansEthiopic-Bold.ttf DroidSansEthiopic-Regular.ttf DroidSansGeorgian.ttf DroidSansHebrew-Bold.ttf DroidSansHebrew-Regular.ttf DroidSansJapanese.ttf DroidSansFallbackFull.ttf
				cd 
			fi
			#sleep 0.01 ;
		done		
	) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Removing Fonts" 2>/dev/null

	# Fixing font cache"
	(
		sudo fc-cache -fv
	) | zenity --progress --auto-close --no-cancel --pulsate --width=720 --title "Refreshing Font Cache" 2>/dev/null

	(
	sudo dpkg-reconfigure fontconfig
	) | zenity --progress --auto-close --no-cancel --pulsate --width=720 --title "Reconfiguring Fonts" 2>/dev/null
 
	(
	# Show the remaining installed fonts
	dpkg -l fonts\* | grep ^ii | awk '{print $2}'
	) | zenity --text-info --title "(Installed) Remaining Fonts" --height=480 --width=720 --no-wrap --ok-label "Done" 2>/dev/null

fi
