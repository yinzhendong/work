#!/bin/sh

################################################################################
# Name		: tmux for new rms servie start
# Author	: Trent
# License	: GPL
# Created	: 2017 Dec 27
# Modified	: 2017 Dec 28
# Description	: add start_service function and rsync soffice zookeeper and 
#		  tomcat start out of tmux
################################################################################

cmd=$(which tmux) 		# tmux path
session=rms	  		# session name
ip=192.168.1.240  		# ezno servic ip
port=8000	  		# enzo service port
enzo_path=/home/boful/enzo	# enzo project path

# Tmux window name
wn_redis=redis
wn_enzo=enzo
wn_webstats=webstats
wn_elastic=elastic
wn_enzo_logstash=enzolog
wn_cdn_logstash=cdnlog
wn_transcode_encode=encode
wn_transcode_cache=cache

# Tmux that the window to execute
cmd_redis="redis-server"
cmd_enzo="cd ${enzo_path} && source venv/bin/activate && python manage.py runserver ${ip}:${port}"
cmd_webstats="cd ${enzo_path} && source venv/bin/activate && python enzo/scripts/web_stats.py 8120"
cmd_elastic="/home/boful/elasticsearch-1.7.2/bin/elasticsearch"
cmd_enzo_logstash="/home/boful/logstash-1.5.4/bin/logstash -f ${enzo_path}/conf/enzo_logstash"
cmd_cdn_logstash="/home/boful/logstash-1.5.4/bin/logstash -f ${enzo_path}/conf/cdn_logstash"
cmd_transcode_encode="cd /app/output/001 && java -jar FileTransEncode.jar"
cmd_transcode_cache="cd /app/output/002 && java -jar FileTransCache.jar"

# Prompt if tmux not installed
if [ -z $cmd ]; then
  echo "You need to install tmux."
  exit 1
fi

# Start rsync soffic zookeeper and tomcat
/usr/bin/rsync --daemon
cd /home/boful && nohup soffice -headless -accept="socket,host=127.0.0.1,port=8100;urp;" -nofirststartwizard > /dev/null 2>&1 &
/app/zookeeper/bin/zkServer.sh start
/home/boful/tomcat/bin/startup.sh

# Start tmux with name $session
$cmd new -s $session -d

################################################################################
# Function:	start_service
# Description:	start service by creating new tmux window adn start service

function start_service()
{
	$cmd new-window -d -t $session -n "$1"
	$cmd send-keys -t $session:$1 "$2" ENTER
}
################################################################################

start_service ${wn_redis} "${cmd_redis}"
start_service ${wn_enzo} "${cmd_enzo}"
start_service ${wn_webstats} "${cmd_webstats}"
start_service ${wn_elastic} "${cmd_elastic}"
start_service ${wn_enzo_logstash} "${cmd_enzo_logstash}"
start_service ${wn_cdn_logstash} "${cmd_cdn_logstash}"
start_service ${wn_transcode_encode} "${cmd_transcode_encode}"
sleep 60
start_service ${wn_transcode_cache} "${cmd_transcode_cache}"
echo "---------------Done---------------"
