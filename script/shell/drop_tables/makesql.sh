#!/bin/bash

while read table; do
	echo "drop table ${table};" >> drop_tables.sql
done < /data/mysql_log/out
