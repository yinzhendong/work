#!/bin/bash

#nohup test

for (( i = 0; i < 100; i++ )); do
	echo $i > /home/yinzd/a.out
	sleep 1
done

