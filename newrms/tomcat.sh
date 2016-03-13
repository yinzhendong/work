# tomcat service controll
# Trent
# 2016-03-10

#!/bin/bash

start()
{
	./tomcat/bin/startup.sh
}

stop()
{
	kill -9 `jps |grep Bootstrap |awk '{print $1}'`
}

printlog()
{
	cd tomcat/logs
	tail -f catalina.out
}
case $1 in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	printlog)
		printlog
		;;
	*)
		echo "Usage : start|stop|restart|printlog"
esac
