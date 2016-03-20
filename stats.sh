#!/bin/bash

hnames="luna ironduke Applejack Braeburn"

source ~/sh/conkify.sh $1

export sedexp="s/.*load averages\?: [0-9]\+\.[0-9]\+,\? \([0-9]\+\.[0-9]\+\).*/\1/g"

info(){
	UPTIME=$(timeout 2 ssh $1 "uptime" 2>/dev/null || return 1) || (echo -e "$RED$1: down$DEFAULT" && return 1) || return 1

	echo -en "$LIGHT_BLUE$1$DEFAULT: "
	echo $UPTIME | sed "$sedexp"
}

echo -en "$LIGHT_BLUE$(hostname)$DEFAULT: "
uptime | sed "$sedexp"

export -f info

echo -n $hnames | parallel -k -d " " --no-notice info {}
