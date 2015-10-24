#!/bin/bash

dir_root=/data/yinzd/

function read_dir()
{
	for file in `ls $1`; do
		echo $file
		if [[ -d $1"/"$file ]]; then
			read_dir $1"/"$file
		else
			echo "$1"/"$file"
		fi
	done
}

read_dir
