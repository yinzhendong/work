#!/bin/bash

enzo_home=/root/enzo
tomcat_home=/home/boful/tomcat

# stop bcms
kill -9 `jps |grep Bootstrap |awk '{print $1}'`

# start tomcat
cd $tomcat_home/bin
./startup.sh

# start redis
nohup redis-server &

# start enzo
cd $enzo_home
make venv
source venv/bin/activate
pip install django-annoying==0.8.2 django-debug-toolbar==1.3.2 django-mptt==0.7.1 \
django-extensions==1.5.5 ipython==2.1.0 MySQL-python==1.2.5 pip==1.5.6
make deps
nohup python manage.py runserver 0.0.0.0:8000 &
