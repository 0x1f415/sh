#!/bin/bash

MINE="luna Big-Macintosh raspberrypi Applejack Braeburn"
THEIRS="ironduke grid.cs.gsu"

# use GNU sed
source .env
# because non-login non-interactive mode doesn't have gnu coreutils installed via homebrew in its $PATH
sed() {
if hash gsed 2>/dev/null;
	then
		gsed "$@"
	else
		sed "$@"
	fi
}

test() {
	if [[ `ssh -q $1 exit 2>/dev/null` -eq 0 || `ping -c 1 $1 2>/dev/null` -eq 0 ]] 
	then
		echo "$LIGHT_BLUE$1$DEFAULT: up"
	else
		echo "$RED$1: down$DEFAULT"
	fi
}

export -f test

echo -n $THEIRS | parallel -k -d " " --no-notice test {}

updates() {
	if [[ `brew --version 2>/dev/null` ]]
	then
		brew outdated | wc -w
	elif [[ `apt-get --version` ]]
	then
		apt-get -s upgrade | grep -Po --color=never "^\d+ (?=upgraded)"
	fi
}

export -f sed updates


source ~/sh/conkify.sh $1
if [[ $1 == "geektool" ]]
then
	export LIGHT_BLUE="$CYAN"
fi


export sedexp="s/.*load averages\?: [0-9]\+\.[0-9]\+,\? \([0-9]\+\.[0-9]\+\).*/\1/g"

info(){
	if [[ $1 == $(hostname | sed -e "s/.local$//g") ]]
	then
		UPTIME=$(uptime | sed "$sedexp")
	else
		UPTIME=$(timeout 5 ssh $1 "uptime" 2>/dev/null || return 1) || (echo -e "$RED$1: unreachable$DEFAULT" && return 1) || return 1
	fi

	echo -en "$LIGHT_BLUE$1$DEFAULT: "
	UPTIME=$(echo $UPTIME | sed "$sedexp")

	if [[ $1 == $(hostname | sed -e "s/.local$//g") ]]
	then
		UPDATES=$(updates)
	else
		UPDATES=$(ssh $1 "$(typeset -f updates); updates")
	fi

	UPDATES=${UPDATES//[[:blank:]]/}

	if [[ ! $UPDATES == 0 ]]; then UPTIME="$UPTIME, $UPDATES updates"; fi

	echo "$UPTIME"
}

export -f info

echo -n $MINE | parallel -k -d " " --no-notice info {}
