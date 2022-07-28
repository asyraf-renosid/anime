#!/bin/bash
# Read a string with spaces using for loop

listcounter=()
listurl=()
listfilename=()
c=-1
ri=1

timestr() {
  date +"%Y%m%d%H%M%S" # current time
}

foldername="dltemp-$(timestr)"
folderpath="./${foldername}"

cd ${filename}
while [ $ri -eq 1 ]
do
	echo "[$((c+2))] URL:"
	read url
	echo ""
	echo "[$((c+2))] Filename:"
	read filename
	echo ""
	((c++))
	listcounter[c]=$c
	listurl[c]=$url
	listfilename[c]=$filename
	echo "Download another file? [y/N]"
	read anotherfile
	echo ""
	if [ -z $anotherfile ]
	then
		ri=0 
	elif [ $anotherfile = 'y' ]
	then
		ri=1
	else
		ri=0
	fi
done 

for value in ${listcounter[@]}
do
	if [ -z ${listfilename[$value]} ]
	then
		listfilename[$value]=${listurl[$value]}
	fi
	if [ -f ${listfilename[$value]} ]
	then
		echo "${listfilename[$value]}: Has been downloaded!"
		echo ""
	else
    	aria2c -x8 ${listurl[$value]} -o ${listfilename[$value]}
		echo ""
	fi
done

mkdir ${foldername}
for value in ${listcounter[@]}
do
    #cp ${listfilename[$value]} ${folderpath}
    mv ${listfilename[$value]} ${folderpath}
done

rclone copy ${folderpath} anime:uploaded -P   
echo ""    

rm -fr ${folderpath}