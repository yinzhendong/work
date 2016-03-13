#!/bin/bash

while read filePath fileHash; do
	#echo $filePath '+' $fileHash;
	fileLegth=`pdfinfo $filePath | grep Pages | awk '{print $2}'`

	#echo $filePath '+' $fileHash '+' $fileLegth;

	echo "update boful_file set file_length='${fileLegth}' where file_path='$filePath';" >> update.sql
done < /home/out
