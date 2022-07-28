#!/bin/bash
# Read a string with spaces using for loop

#rclone copy anime:uploaded/request.csv ./

INPUT=request.csv
OLDIFS=$IFS
IFS=","
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
listcounter=()
listurl=()
listfilename=()
c=-1
timestr() {
  date +"%Y%m%d%H%M%S" # current time
}
foldername="dltemp-$(timestr)"
folderpath="./${foldername}"

while read filename url
do	
	((c++))
	listcounter[c]=$c
	listurl[c]=$url
	listfilename[c]=$filename
done < $INPUT
IFS=$OLDIFS

for value in ${listcounter[@]}
do
	if [ -f ${listfilename[$value]} ]
	then
		echo "${listfilename[$value]}: Has been downloaded!"
		echo ""
	else
    	aria2c -x 16 ${listurl[$value]} -o ${listfilename[$value]}
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

for value in ${listcounter[@]}
do
	echo "${listfilename[$value]},${listurl[$value]},$(timestr)" >> history.csv
done
rm request.csv
touch request.csv
echo "" >> request.csv