#!/bin/bash
# Read a string with spaces using for loop

#rclone copy anime:uploaded/request.csv ./
INPUT=request.csv
OLDIFS=$IFS
IFS=','

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
	echo "Filename: $filename"
	echo "URL: $url"
	listcounter[c]=$c
	listurl[c]=$url
	listfilename[c]=$filename
done < $INPUT

echo ${listurl[0]}

for value in ${listcounter[@]}
do
	if [ -f ${listfilename[$value]} ]
	then
		echo "${listfilename[$value]}: Has been downloaded!"
		echo ""
	else
		echo ${listurl[$value]}
		echo ${listfilename[$value]}
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