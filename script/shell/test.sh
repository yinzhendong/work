#!/bin/bash

file1=`date "+%y%m%d_%H%M%S"`

echo $file1


sleep 1

file2=`date "+%y%m%d_%H%M%S"`


echo $file2


year1=${file1%_*}
year2=${file2%_*}


echo $year1
echo $year2


echo  $((year2-year1))


time1=${file1#*_}
time2=${file2#*_}


echo $time1
echo $time2

echo  $((time2-time1))


for i in `ls -lh /mnt |grep gz|awk '{print $9}'`
do
	echo $i
done
