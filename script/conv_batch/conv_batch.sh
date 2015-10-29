#!/bin/sh

file_name=/data/yinzd/conv_batch/video_file_path.out

for file_path in `cat $file_name`; do
	#echo $file_path
	file_name=${file_path##*/}
	#echo $file_name
	#echo ${file_name%.*}
	#echo ${file_name%.*}.mp4

	# mediainfo get file vb/ab
	file_vb_bps=`mediainfo --Output="Video;%BitRate%" $file_path`
	#echo "${file_vb_bps}bps"
	file_vb_kbps=`expr $file_vb_bps / 1000`
	#echo "${file_vb_kbps}kbps"

	file_ab_bps=`mediainfo --Output="Audio;%BitRate%" $file_path`
	#echo "${file_ab_bps}bps"
	file_ab_kbps=`expr $file_ab_bps / 1000`
	#echo "${file_ab_kbps}kbps"

	file_width=`mediainfo --Output="Video;%Width%" $file_path`
	#echo $file_width
	file_height=`mediainfo --Output="Video;%Height%" $file_path`
	#echo $file_height

	# use HandBrake conv file to mp4
	echo "HandBrakeCLI -i \"$file_path\" -o \"${file_path%/*}/${file_name%.*}.mp4\" -e x264 --vb $file_vb_kbps --ab $file_ab_kbps" --width $file_width --height $file_height >> ./conv_file.cmd
	#convcmd=`HandBrakeCLI -i $file_path -o $file_path$file_name.mp4 -e x264 --vb $file_vb_kbps --ab $file_ab_kbps`
done


