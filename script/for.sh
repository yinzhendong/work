#!/bin/bash
for (( i = 0; i < 10; i++ )); do
	echo "The $i backup:"
	/mnt/mysql_auto_backup.sh
done
