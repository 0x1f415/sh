#!/bin/bash

if [ "$1" == "conky" ]
then
	export BLACK='${color black}'
	export RED='${color red}'
	export GREEN='${color green}'
	export BROWN='${color brown}'
	export BLUE='${color blue}'
	export PURPLE='${color purple}'
	export CYAN='${color cyan}'
	export LIGHT_GREY='${color LightGrey}'
	export DARK_GREY='${color DarkGrey}'
	export LIGHT_RED='${color LightRed}'
	export LIGHT_GREEN='${color LightGreen}'
	export YELLOW='${color yellow}'
	export LIGHT_BLUE='${color LightBlue}'
	export LIGHT_PURPLE='${color LightPurple}'
	export LIGHT_CYAN='${color LightCyan}'
	export WHITE='${color white}'
	export DEFAULT='${color}'
elif [ "$1" == "html" ]
then
	# use responsibly

	for i in BLACK WHITE RED ORANGE YELLOW GREEN BLUE CYAN PURPLE LIGHT_RED LIGHT_ORANGE LIGHT_YELLOW LIGHT_GREEN LIGHT_BLUE LIGHT_CYAN LIGHT_PURPLE
	do
		declare "$i=<span class=\"$i\">"
		export $i
	done

	export DEFAULT='</span>'
else
	export GREEN="\x1b[0;32m"
	export PURPLE="\x1b[0;35m"
	export CYAN="\x1b[0;36m"
	export LIGHT_BLUE="\x1b[0;34m"
	export RED="\x1b[0;31m"
	export DEFAULT="\x1b[0;0m"
fi
