#!/bin/bash
# mysql auto backup with crontab

dbuser=root
dbpasswd=root
dbname=enzo
backup_path=/backup1
#backup_file_name=`date "+%Y%m%d_%H%M%S"`
backup_file_name=`date "+%Y%m%d"`.${dbname}

#echo "Backup......"
mysqldump -u${dbuser} -p${dbpasswd} ${dbname} > ${backup_path}/${backup_file_name}.sql
#echo "Backup Done!"


#echo "Zipping File......"
tar -zcf ${backup_path}/${backup_file_name}.tar.gz ${backup_path}/${backup_file_name}.sql

#rm -rf ${bakcup_path}${backup_file_name}.sql

#echo "Saving logs......"

echo ${backup_file_name}.tar.gz >> ${backup_path}/log

#echo "Done!"

