#!/bin/sh

file_path=/data/yinzd/tmp/
file_name=Wildlife.wmv

# mediainfo get file vb/ab
file_vb_bps=`mediainfo --Output="Video;%BitRate%" $file_path$file_name`
echo "${file_vb_bps}bps"
file_vb_kbps=`expr $file_vb_bps / 1000`
echo "${file_vb_kbps}kbps"

file_ab_bps=`mediainfo --Output="Audio;%BitRate%" $file_path$file_name`
echo "${file_ab_bps}bps"
file_ab_kbps=`expr $file_ab_bps / 1000`
echo "${file_ab_kbps}kbps"

# use HandBrake conv file to mp4
#echo "HandBrakeCLI -i $file_path$file_name -o $file_path$file_name.mp4 -e x264 --vb $file_vb_kbps --ab $file_ab_kbps"
convcmd=`HandBrakeCLI -i $file_path$file_name -o $file_path$file_name.mp4 -e x264 --vb $file_vb_kbps --ab $file_ab_kbps`
