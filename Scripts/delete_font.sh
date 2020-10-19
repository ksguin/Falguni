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
	# selecting fonts to uninstall
	# here SEL=$ cannot contain whitespace
	SEL=$( zenity --list --multiple\
				--text "The following fonts will be removed" --window-icon="./Icons/falguni.png" 2>/dev/null\
				--checklist --height=480 --width=720 --ok-label "Remove"\
				--cancel-label "Skip"\
				--column "Pick" --column "Fonts" --column "Description"\
				TRUE 	fonts-arabeyes		"A set of TrueType Arabic fonts"\
				TRUE 	fonts-arphic-*		"Sets of Chinese Unicode/TrueType font"\
				TRUE 	fonts-beng*		"Metapackage of Bengali and Assamese fonts"\
				TRUE 	fonts-droid-fallback	"Handheld device font with extensive support (fallback)"\
				TRUE 	fonts-gargi		"OpenType Devanagari font"\
				TRUE 	fonts-gubbi		"Gubbi free font for Kannada script"\
				TRUE 	fonts-gujr*		"Metapackage of all Gujarati fonts"\
				TRUE 	fonts-guru*		"Metapackage of all Punjabi fonts"\
				TRUE 	fonts-kacst*		"KACST free TrueType Arabic fonts"\
				TRUE 	fonts-kalapi		"Kalapi Gujarati Unicode font"\
				TRUE 	fonts-khmeros-core		"Unicode fonts for the Khmer language of Cambodia"\
				TRUE 	fonts-lao		"TrueType font for Lao language"\
				TRUE 	fonts-lklug-sinhala		"Unicode Sinhala font by LKLUG"\
				TRUE 	fonts-lohit-*		"Sets of Lohit TrueType Indic fonts"\
				TRUE 	fonts-nakula		"Free Unicode compliant Devanagari font"\
				TRUE 	fonts-nanum		"Nanum Korean fonts"\
				TRUE 	fonts-navilu		"Handwriting font for Kannada"\
				TRUE 	fonts-noto-cjk		"No Tofu font families with large Unicode coverage"\
				TRUE 	fonts-orya-extra		"Free fonts for Odia script"\
				TRUE 	fonts-pagul		"Free TrueType font for the Sourashtra language"\
				TRUE 	fonts-sahadeva		"Free Unicode compliant Devanagari font"\
				TRUE 	fonts-samyak-*		"Metapackage of all Samyak TrueType fonts"\
				TRUE 	fonts-sarai		"TrueType font for Devanagari script"\
				TRUE 	fonts-sil-abyssinica		"Unicode font for Ethiopic script"\
				TRUE 	fonts-sil-padauk		"Burmese Unicode TrueType font"\
				TRUE 	fonts-smc		"Metapackage of TrueType fonts for Malayalam Language"\
				TRUE 	fonts-takao-pgothic		"Japanese gothic and mincho scalable fonts"\
				TRUE 	fonts-telu-extra		"Free fonts for Telugu script"\
				TRUE 	fonts-tibetan-machine		"Font for Tibetan, Dzongkha and Ladakhi"\
				TRUE 	fonts-tlwg-*		"Set of all Thai fonts for LaTeX from TLWG"\
				TRUE 	fonts-wqy-microhei 		"Sans-serif style CJK font derived from Droid" );

	# pressed Cancel or closed the dialog window 
	if [[ $? -eq 1 ]]; then 
  		zenity --warning --title="Operation Cancelled" --window-icon="./Icons/falguni.png" \
		--text "\nOperation cancelled by user. No Fonts will be removed!"\
		2>/dev/null --no-wrap
	elif [[ -z "$SEL"  ]]; then
		zenity --warning\
		--text "\nNo Font Selected. Nothing will be removed!" --window-icon="./Icons/falguni.png" \
		2>/dev/null --no-wrap
	else
		#removing all the selected languages
		(
			for i in $(echo $SEL | tr "|" "\n") ;
			do 
				( sudo apt-get autoremove --purge -y $i 2>/dev/null | \
						tee >(xargs -I % echo "#%")) | \
						zenity --progress --width=720 --window-icon="./Icons/falguni.png" --pulsate \
						--title "Removing $i"\
						--no-cancel --auto-kill --auto-close 2>/dev/null

				# For Droid Fonts:
				if [[ $i =~ "fonts-droid_fallback" ]]; then
    					cd /usr/share/fonts/truetype/droid/
					sudo rm DroidKufi-Bold.ttf DroidKufi-Regular.ttf DroidNaskh-Bold.ttf DroidNaskh-Regular.ttf DroidNaskhUI-Regular.ttf DroidSansArabic.ttf DroidSansArmenian.ttf DroidSansEthiopic-Bold.ttf DroidSansEthiopic-Regular.ttf DroidSansGeorgian.ttf DroidSansHebrew-Bold.ttf DroidSansHebrew-Regular.ttf DroidSansJapanese.ttf DroidSansFallbackFull.ttf
					cd 
				fi
				#sleep 0.01 ;
			done		
		) | zenity --progress --window-icon="./Icons/falguni.png" --auto-close --width=720 --pulsate --no-cancel --title "Removing Fonts" 2>/dev/null

		# Fixing font cache"
		(
			sudo fc-cache -fv
		) | zenity --progress --window-icon="./Icons/falguni.png" --auto-close --no-cancel --pulsate --width=720 --title "Refreshing Font Cache" 2>/dev/null

		(
		sudo dpkg-reconfigure fontconfig
		) | zenity --progress --window-icon="./Icons/falguni.png" --auto-close --no-cancel --pulsate --width=720 --title "Reconfiguring Fonts" 2>/dev/null
 
		(
		# Show the remaining installed fonts
		echo -e "This box will automatically close in 30s..."
		dpkg -l fonts\* | grep ^ii | awk '{print $2}'
		) | zenity --text-info --window-icon="./Icons/falguni.png" --title "(Installed) Remaining Fonts"\
		--height=480 --width=720 --no-wrap --ok-label "Done" --cancel-label "Proceed"\
		--timeout=30 2>/dev/null

		if [[ ! -z $SEL ]]; then
			COMPLETION_NOTIFICATION 'Complete' 'Fonts Removed'
		fi
	fi
fi
