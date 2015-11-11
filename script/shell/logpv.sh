#!/bin/bash

`cat /var/log/httpd/access_log |awk '{print $1}' |sort |uniq -c > out`

for i in `cat out |wc -l`
do
	count=`cat out |awk '{print $1}'`
	echo $count
	ip=`cat out |awk '{print $2}'`
	echo $ip
	sleep 1
done