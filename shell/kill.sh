#!/bin/sh

#kill -9 `jps |grep Bootstrap |awk '{print $1}'`

ps -ef | grep tomcat | awk '{print $2}' | xargs kill -9