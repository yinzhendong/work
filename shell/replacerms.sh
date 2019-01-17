#!/bin/bash

work_path=/home/boful
version=7140
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
mv rms rms.${project_name}.${replace_time}
unzip -q ../rms.${project_name}.${version}.war -d rms
cp -rf  rms.${project_name}.${replace_time}/upload ./rms/
cp -f ~/.boful/rms/rms-config.properties rms/WEB-INF/classes/

# start tomcat service
cd ${work_path}
./start.sh
