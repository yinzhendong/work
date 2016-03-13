#!/bin/sh
# transcode service script
# created: 2016-03-04

conv_home=/usr/local/workspace/app
tomcat_home=/usr/local/workspace/app
zookeeper_home=/usr/local/workspace/app


start() {
	echo "Starting transcode..."
	nohup soffice -headless -accept="socket,host=127.0.0.1,port=8100;urp;" -nofirststartwizard &
	cd $tomcat_home/tomcat/bin
	./startup.sh
	cd $zookeeper_home/zookeeper/bin
	./zkServer.sh start
	cd $conv_home/output/001
	nohup java -jar FileTransEncode.jar &
	cd $conv_home/output/002
	nohup java -jar FileTransCache.jar > /dev/null 2>&1 &
	echo "Done"
}

stop() {
	echo "Stop transcode..."
	cd $tomcat_home/tomcat/bin
	./shutdown.sh
	cd $zookeeper_home/zookeeper/bin
	./zkServer.sh stop
	jps | grep jar | awk '{print $1}' | xargs kill
	echo "Done"
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
	*)
		echo "Usage : start|stop|restart"
esac
