#!/bin/sh

# variable
bcms_git=/root/bcms-master
bcms_root=/home/boful/web
tomcat_root=/home/boful/tomcat
update_time=`date +%Y%m%d%H%M`
source_ip=42.62.52.40
target_ip=192.168.1.70

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
#unzip -q master.zip
unzip  master.zip

# modify config
cd $bcms_git/src/main/java/brms/action
sed -i "s/$source_ip/$target_ip/g" Proxy.java

# make war
cd $bcms_git
mvn compile
mvn war:war

# stop bcms
kill -9 `jps |grep Bootstrap |awk '{print $1}'`

# replace bcms
cd $bcms_root
mv bcms bcmc.$update_time
mkdir bcms
cd bcms
cp $bcms_git/target/bcms-1.0.war ./
jar xvf bcms-1.0.war

# start bcms
cd $tomcat_root/bin
./startup.sh
