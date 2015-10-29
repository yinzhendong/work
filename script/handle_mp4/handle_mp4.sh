#!/bin/bash

cat out | while read LINE; do
	echo "file_hash+file_path is --> $LINE"
	file_hash=`echo $LINE | cut -d ':' -f 1`
	echo "file_hash is --> $file_hash"

	file_path=`echo $LINE | cut -d ':' -f 2`
	echo "file_path is --> $file_path"

	echo "cp \"$file_path\" /home/store/$file_hash.mp4"
	echo "--------------"
done
