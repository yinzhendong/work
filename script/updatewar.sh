#!/bin/sh

# loction
bcms_git=/root/bcms-master
bcms_root=/home/boful/web
tomcat_root=/home/boful/tomcat

# get bcms source 
#cd $bcms_git
#git pull git@github.com:ligson/bcms.git
if [ -d "$bcms_git" ]; then
	rm -rf "$bcms_git"
fi

if [ -f "/root/master.zip" ]; then
	rm -rf /root/master.zip
fi

wget https://github.com/ligson/bcms/archive/master.zip
unzip -q master.zip

# modify config
#cd $bcms_git/src/main/java/brms/action

# make war
cd $bcms_git
mvn compile
mvn war:war

# stop bcms
kill -9 `jps |grep Bootstrap |awk '{print $1}'`

# replace bcms

# start bcms
cd $tomcat_root/bin
./startup.sh
