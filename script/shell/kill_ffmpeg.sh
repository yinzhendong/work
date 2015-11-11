#!/bin/bash
# kill all ffmpeg thread

for i in `ps -ef|grep ffmpeg|awk '{print$2}'`
do
	kill -9 $i
done
