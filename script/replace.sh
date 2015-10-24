#!/bin/bash
#replace rms and bmc

#check the nts path
read -p "Please input nts path:" nts_path
#check the nts path
while [[ ! -f $nts_path/nts.war ]]; do
	read -p "nts path incrrect! Please input again:" nts_path 
done

#check the bmc path
read -p "Please input bmc path:" bmc_path
while [[ ! -f $bmc_path/nts.war ]]; do
	read -p "bmc path incrrect! Please input again:" bmc_path 
done

#check the nts war file exists
read -p "rms replace war name:" rms_war_name
while [[ ! -f $rms_war_name ]]; do
	read -p "rms war file check fail! input rms war file name:" rms_war_name
done


#stop tomcat service
echo "Stop the tomcat service..."
kill -9 `jps |grep Bootstrap |awk '{print $1}'`
echo "Stop ok!"

#start replace rms 

#rms_backup_file_name=`date "+%Y%m%d"`
rms_backup_file_name=$(date "+%Y%m%d")
echo "Start replace RMS..."
#backup nts to nts.yyyymmdd
echo "Backup nts to nts.${rms_backup_file_name}"
cd $nts_path
mv nts /home/boful/nts.${rms_backup_file_name}
mkdir nts
rm -rf nts.war
cp /home/boful/$rms_war_name nts
cd nts
jar xvf $rms_war_name
rm -rf $rms_war_name
echo "RMS replace Done..."

#start tomcat 
cd /home/boful/tomcat/bin
./startup.sh

#check logs
tail -f ../logs/catalina.out

#echo "Start replace BMC..."
#echo "BMC replace Done..."



