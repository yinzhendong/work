#!/bin/bash
# kill all ffmpeg thread

for i in `ps -ef | grep ffmpeg | grep -v "grep" |awk '{print$2}'`
do
	kill -9 $i
done
