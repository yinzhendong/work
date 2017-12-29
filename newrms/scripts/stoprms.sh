#!/bin/sh

################################################################################
# Name		: stop all the rms services
# Author	: Trent
# License	: GPL
# Created	: 2017 Dec 28
# Modified	: 2017 Dec 28
# Description	: stop all the rms services
################################################################################

# Tmux session name
session=rms

# Tmux window name
sn_redis=redis
sn_soffice=soffice
sn_rsync=rsync
sn_tomcat=tomcat
sn_logstash=logstash
################################################################################
# Function	: kill_service		
# Description	: start service by creating new tmux window adn start service

function kill_service()
{
	`ps -ef | grep $1 | grep -v "grep" | awk '{print $2}' | xargs kill -9`
}
################################################################################

# Kill tmux session rms
tmux kill-session -t $session

# Kill service by kill_service function
kill_service ${sn_redis}
kill_service ${sn_soffice}
kill_service ${sn_rsync}
kill_service ${sn_tomcat}
kill_service ${sn_logstash}

# Stop zookeeper and tomcat by default
/app/zookeeper/bin/zkServer.sh stop
echo "---------------Done---------------"
