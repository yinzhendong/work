#!/bin/bash

# file name fro batch delete
file_path=/data/yinzd/conv_batch/video_file_path.out

for i in `cat $file_path`; do
	echo "rm -rf $i"
	rm -rf $i
done
