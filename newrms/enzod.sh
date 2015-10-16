#!/bin/bash

enzo_home=/root/enzo
tomcat_home=/home/boful/tomcat

# start tomcat
cd $tomcat_home/bin
./startup.sh

# start redis
nohup redis-server &

# start enzo
cd $enzo_home
make venv
source venv/bin/activate
make deps
nohup python manage.py runserver 0.0.0.0:8000 &
