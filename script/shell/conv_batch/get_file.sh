#!/bin/bash

# find all directory file name and path

INIT_PATH="/data/yinzd/tmp"

function read_dir()
{
	for file in ` ls $1`; do
		if [ -d $1"/"$file ]; then
			read_dir $1"/"$file
		else
			path=$1"/"$file					# full path of file
			full_name=$file					# full name of file
			name=${file%.*}					# file name remove .* example: file1.mkv --> file1
			media_type=${file##*.}
			#echo ${file##*.}				# get file name extension
			case $media_type in
				[Mm][Kk][Vv])
				echo $path >> ./video_file_path.out
				;;
				[Tt][Ss])
				echo $path >> ./video_file_path.out
				;;
				[Ww][Mm][Vv])
				echo $path >> ./video_file_path.out
				;;
				[Aa][Vv][Ii])
				echo $path >> ./video_file_path.out
				;;
				[Vv][Oo][Bb])
				echo $path >> ./video_file_path.out
				;;
				[Rr][Mm][Vv][Bb])
				echo $path >> ./video_file_path.out
				;;
				[Mm][Pp][Ee][Gg])
				echo $path >> ./video_file_path.out
				;;
				[Mm][Pp][Gg])
				echo $path >> ./video_file_path.out
				;;
				[Ff][Ll][Vv])
				echo $path >> ./video_file_path.out
				;;
				[Rr][Mm])
				echo $path >> ./video_file_path.out
				;;
				[Dd][Oo][Cc])
				echo $path >> ./doc_file_path.out
				;;
				[Tt][Xx][Tt])
				echo $path >> ./doc_file_path.out
				;;
				[Pp][Dd][Ff])
				echo $path >> ./doc_file_path.out
				;;
				[Xx][Ll][Ss])
				echo $path >> ./doc_file_path.out
				;;
				[Jj][Pp][Gg])
				echo $path >> ./img_file_path.out
				;;
				[Bb][Mm][Pp])
				echo $path >> ./img_file_path.out
				;;
				[Gg][Ii][Ff])
				echo $path >> ./img_file_path.out
				;;
			esac
		fi
	done
}

read_dir $INIT_PATH

