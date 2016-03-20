#!/bin/bash
# shell script to prepend i3status with more stuff

i3status | while :
do
        read line
		todos=$(todo.sh ls | wc -l)
		if [ "$todos" != 0 ]
			then line="todo: $todos | $line"
		else
			:
		fi
		nowplaying=$(deadbeef --nowplaying-tf "%artist% - %title%" 2>/dev/null)
		if [ "$nowplaying" == "nothing" ]
			then
				:
			else
				if [[ $(deadbeef --nowplaying-tf \"%isplaying%\" 2>/dev/null) == *1* ]]
					then
						line="$nowplaying | $line"
				fi
		fi
        echo "$line" || exit 1
done
