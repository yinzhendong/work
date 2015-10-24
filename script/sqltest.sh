#!/bin/bash
# select the convert queue dead task, and set these convert task transcode_state=3

HOSTNAME="127.0.0.1"
PORT="3306"
USER="root"
PASSWD="password"
DBNAME="conv"

#sql="select file_path from serial where file_hash='${line}'"

#mysql -h${HOSTNAME} -P${PORT} -u${USER} -p${PASSWD} ${DBNAME} -e

cat /mnt/a.txt | while read line
do
	sql_query="select transcode_state from boful_file where file_hash='${line}'"
	mysql -h${HOSTNAME} -P${PORT} -u${USER} -p${PASSWD} ${DBNAME} -e "${sql_query}"
	#echo ${line} >> a.out
	#echo ${sql_query}
	sql_update="update boful_file set transcode_state=3 where file_hash='${line}'"
	#echo ${sql_update}
	mysql -h${HOSTNAME} -P${PORT} -u${USER} -p${PASSWD} ${DBNAME} -e "${sql_update}"
done
