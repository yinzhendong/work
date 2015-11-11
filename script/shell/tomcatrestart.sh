#!/bin/bash

# tomcat path
path=/home/boful/tomcat
date=`date +%Y-%m-%d-%H:%M:%S`

# stop tomcat
kill -9 `jps |grep Bootstrap |awk '{print $1}'`

# start tomcat
$path/bin/startup.sh > /dev/null 2>&1

# Print tomcat log
#tail -f $path/logs/catalina.out

# write log to log file
echo "${date}-->exec done!" >> /home/boful/service.log
