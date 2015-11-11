#!/bin/bash
# trap example

trap 'myfunc' 2

myfunc()
{
	read -p "are you sure to exit? yes or no: " s

	case $s in
	 	yes )
			exit
	 		;;
	 	no )
			;;
		* )
			myfunc
	 esac 
}

i=0
while true
do
	let i++
	echo $i
	sleep 1
done
