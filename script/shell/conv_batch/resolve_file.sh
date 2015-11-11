#!/bin/bash

file_name=/root/file_path

for file_path in `cat $file_name`; do
	#echo $file_path
	file_name=${file_path##*/}
	#echo $file_name
	#echo ${file_name%.*}
	#echo ${file_name%.*}.mp4
done
