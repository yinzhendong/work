#!/bin/bash

# Count all git webhook request
num=`cat /var/log/httpd/access_log | grep "GitHub-Hookshot" | wc -l`
date=`date +%Y-%m-%d-%H:%M:%S`

# repeat times
times=`cat /root/gitwebhook/times`

#echo "before exec num is: "$num
#echo "before exec times is: "$times

if [ $num -gt $times ];then
`/root/replace.sh > /dev/null 2>&1`
echo "${date}-->exec done!" >> /root/gitwebhook/githook.log
echo $num > /root/times
fi

#echo "after exec times is:"`cat /root/gitwebhook/times`
