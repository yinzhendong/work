#!/bin/bash

work_path=/home/boful
version=289
project_name=heuet
replace_time=`date +"%Y%m%d-%H%M%S"`

# stop tomcat service
cd ${work_path}
./kill.sh

# clean tomcat cache
cd ${work_path}
./cleancache.sh

# replace war
cd ${work_path}/web
mv bcms bcms.${project_name}.${replace_time}
unzip -q ../bcms.${project_name}.${version}.war -d bcms 
cp -f conn.properties bcms/WEB-INF/classes/
cp -f log4j.properties bcms/WEB-INF/classes/
cp -rf  bcms.${project_name}.${replace_time}/resources/virtual ./bcms/resource/

# start tomcat service
cd ${work_path}
./start.sh
