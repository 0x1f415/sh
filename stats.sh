#!/bin/bash

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

export -f sed

hnames="luna ironduke Applejack Braeburn"

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
		UPTIME=$(timeout 2 ssh $1 "uptime" 2>/dev/null || return 1) || (echo -e "$RED$1: down$DEFAULT" && return 1) || return 1
	fi

	echo -en "$LIGHT_BLUE$1$DEFAULT: "
	echo $UPTIME | sed "$sedexp"
}

export -f info

echo -n $hnames | parallel -k -d " " --no-notice info {}
