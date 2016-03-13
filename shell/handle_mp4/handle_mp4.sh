#!/bin/bash

transcode_root=/home/media/video

cat out | while read LINE; do
	echo "file_hash+file_path is --> $LINE"
	file_hash=`echo $LINE | cut -d ':' -f 1`
	echo "file_hash is --> $file_hash"

	file_path=`echo $LINE | cut -d ':' -f 2`
	echo "file_path is --> $file_path"

	file_name=${file_path##*/}
	echo $file_name

	file_height=`mediainfo --Output="Video;%Height%" "$file_path"`
	echo $file_height	

	file_width=`mediainfo --Output="Video;%Width%" "$file_path"`
	echo $file_width

	#file_size=`mediainfo --Output="General;%FileSize%" "$file_path"`
	#echo $file_size

	#file_duration=`mediainfo --Output="General;%Duration%" "$file_path"`
	#echo $file_duration

	cd $transcode_root
	mkdir $file_hash	
	echo "cp \"$file_path\" \"$transcode_root/$file_hash/${file_width}_${file_height}.mp4\""
	`cp "$file_path" "$transcode_root/$file_hash/${file_width}_${file_height}.mp4"`
	
	echo "--------------"
done
