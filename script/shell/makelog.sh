#!/bin/bash
# create log

today=`date +%Y-%m-%d`

filelog="${today}.log"

if [ ! -e $filelog ]; then
	touch $filelog
fi

echo "`date '+%Y-%m-%d %H:%M:%S'` log input start" >> $filelog
sleep 5
echo "`date '+%Y-%m-%d %H:%M:%S'` log input end" >> $filelog
echo "log write done!"