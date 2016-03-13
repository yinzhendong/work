#!/bin/bash

# delete other file from file

#video="{mp4,avi,wmv,mpg}"
video="[mp4][avi][wmv][mpg]"

for type in `awk -F '.' '{print $2}' file`; do
	#echo $type
	if [[ "$type" =~ "$video" ]]; then
		echo "$type is a video."
	else
		echo "$type is another type."
	fi
done