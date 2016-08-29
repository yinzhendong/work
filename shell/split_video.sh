#!/bin/sh

# Name: split_video.sh
# Author: Trent
# Create Date: 2016-03-25
# 使用方法，调用脚本，传入要分割的视频文件完整路径、分割的时间间隔，调用ffmpeg，执行原始码率、分辨率输出分割视频到源文件路径
# Call the shell script pass file_path duration, then script use the ffmpeg to output original resolution/bitrate file to the original file path
#
# define var
file_path=$1
duration=$2
file_type=${1##*.}

echo "file resolut path is $file_path"
echo "file spilt duration is $duration"
echo "file type is $file_type"



# check parameter correct，if not correct output the usage
# use mediainfo get file total seconds

total_seconds=`mediainfo --Output="General;%Duration%" $file_path`
echo "file duration in seconds is $((total_seconds/1000))"
echo "file spilt in $((total_seconds/1000/60)) clips"

# work bug have some problem
for (( i = 1; i <= ((total_seconds/1000/60)); i++ )); do
	#echo $i
	#echo "ffmpeg -ss $(((i-1)*60)) -t 60 -i $file_path -acodec copy -vcodec copy $file_path-$i.$file_type"
	ffmpeg -ss $(((i-1)*60)) -t 60 -i $file_path -acodec copy -vcodec copy $file_path-$i.$file_type
	#echo $file_path-$i.$file_type
done
