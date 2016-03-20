#!/bin/bash

export CONVERT_REGEX=".*/.*.(flac|FLAC|wav|WAV)"
export DO_NOT_COPY_REGEX=".*\.(zip|sh|part|gif|log|cue|CUE|m3u|avi|mp4|txt|nsf|it|sfv|pdf|swp)$"

export SOURCE_DIR="/media/secondary/Music/"
export TARGET_DIR='/media/secondary/ogg/'

export BITRATE="128k"

IFS='
'

function handleFile (){ # $FILE

	FILE="$1"

	if [[ "$FILE" =~ $DO_NOT_COPY_REGEX ]]
	then
		exit 0
	elif [[ $FILE =~ $CONVERT_REGEX ]] && [[ -e "$TARGET_DIR/$FILE.ogg" ]]
	then
		exit 0
	elif [[ -e "$TARGET_DIR/$FILE" ]]
	then
		exit 0
	fi

	# test if file should be ignored
	path=`dirname "$SOURCE_DIR/$FILE"`
	while [ "$(stat -c "%d:%i" "$path")" != "$(stat -c "%d:%i" "$SOURCE_DIR")" ]
	do
		if [ -f "$path/.no-oggify" ]
		then
			echo $path | sed "s#$SOURCE_DIR#$TARGET_DIR#g" | xargs -d $"\n" rm -rf
			exit 0
		else
	 		path="$(readlink -f "$path/..")"
		fi
	done

	mkdir -p "$TARGET_DIR/""`dirname "$FILE"`"

	if [[ $FILE =~ $CONVERT_REGEX ]] && [[ ! -e "$TARGET_DIR/$FILE.ogg" ]]
	then
		ffmpeg -i "$SOURCE_DIR/$FILE" -c:a libvorbis -b:1 $BITRATE -vn "$TARGET_DIR/$FILE.ogg" 2>/dev/null
	else
		cp -n "$SOURCE_DIR/$FILE" "$TARGET_DIR/$FILE"
	fi

	echo -e "\r$FILE\033[K"
}

export -f handleFile

find "$SOURCE_DIR" -type f | sed -e "s#$SOURCE_DIR##g" |  parallel --bar --no-notice handleFile "{}" 1>&2

for FILE in `find $TARGET_DIR -type f | sed -e "s#$TARGET_DIR##g"`
do
	if [[ $FILE =~ .*\.ogg ]] && [[ ! -e "$SOURCE_DIR/"${FILE%.*} ]]
	then
		rm "$TARGET_DIR/$FILE"
	elif [[ $FILE =~ $DO_NOT_COPY_REGEX ]]
	then
		rm "$TARGET_DIR/$FILE"	
	fi
done

find $TARGET_DIR -type d -empty -delete
