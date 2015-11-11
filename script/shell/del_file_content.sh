#!/bin/bash
# delete file content

count=`cat /mnt/dblog |wc -l`
echo "Totel record is:${count}"
sleep 1

cat /mnt/dblog | while read line
do
	echo $line
	sleep 1
#	rm -rf $line
done




#for (( i = 0; i < 5; i++ )); do
#	echo ${i}
#	cat /mnt/dblog |  read line
#	echo $line
#	sleep 1
#	rm -rf `cat /mnt/dblog |awk '{print $0}'`.tar.gz
#	sed -i '1d' /mnt/dblog
#done
