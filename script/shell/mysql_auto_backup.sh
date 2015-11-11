#!/bin/bash
# mysql auto backup with crontab

#date "+%y%m%d_%H%M%S"

backup_file_name=`date "+%y%m%d_%H%M%S"`

#echo $backup_file_name
#echo ./${backup_file_name}.sql

#echo /mnt/${backup_file_name}.sql

echo "Backup......"
mysqldump -u root -ppassword convtust > /mnt/${backup_file_name}.sql
echo "Backup Done!"


echo "Zipping File......"
tar zcvf /mnt/${backup_file_name}.tar.gz ${backup_file_name}.sql

rm -rf /mnt/${backup_file_name}.sql

echo "saving logs......"

echo ${backup_file_name}.tar.gz >> /mnt/dblog

echo "done!"

echo "Total backup files is:`cat /mnt/dblog | wc -l`"

#------------delete older backup files---------------------
#
#echo "delete older 10 files......"
#for ((i=0; i<10; i++))
#do
#	rm -rf /mnt/`cat /mnt/dblog | awk '{print $0}'`
#done
#echo "Delete done!"

