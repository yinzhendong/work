#!/bin/bash
# create tmp file

tmpfile=$$.tmp
echo $tmpfile

# Get all httpd pid then save it to the tmp file
ps -ef |grep httpd |awk '{print $2}' >> $tmpfile 

# Use for loop kill all httpd pid
for pid in `cat $tmpfile`; do
	echo "Apache ${pid} is killed."
	kill -9 $pid
done

# finished kill all httpd pid
echo "apache is shutdonw."

# delete tmp file
#rm -rf $tmpfile
