#!/bin/bash

#--How to USE--#
# FIND_EXECUTE_SCRIPT "<path relative to project folder with beginning and trailing / >" "<script name to execute>"
#--------------#

FIND_EXECUTE_SCRIPT() {
	Path=$1
	Sh=$2
	
	Fullpath="$(dirname \"${0}\")"$Path$Sh

	if find $Fullpath -quit; then
		source $Fullpath
	else
		zenity --error --title="File Not Found" --window-icon="./Icons/falguni.png" \
		2>/dev/null --no-wrap\
		--text="\nCannot locate File!"
	fi
}
