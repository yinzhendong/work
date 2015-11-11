#!/bin/bash

# find all directory file name and path

function read_dir()
{
	for file in ` ls $1`; do
		if [ -d $1"/"$file ]; then
			read_dir $1"/"$file
		else
			path=$1"/"$file					# full path of file
			full_name=$file					# full name of file
			name=${file%.*}					# file name remove .* example: file1.mkv --> file1
			if [[ $1 == $INIT_PATH ]]; then
				echo $name"-->"$name"-->"$path
			else
				echo $1"-->"$name"-->"$path
			fi
		fi
	done
}

INIT_PATH="/root/import_res/movie"
read_dir $INIT_PATH
