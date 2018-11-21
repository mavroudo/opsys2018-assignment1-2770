 #!/bin/bash
#initialize the names of the files
filename="tempResults.txt"
tempFile="tempWGET.txt"
finalFile="results.txt"
#checking for a file to open
if [ $# -ne 1 ]
then
  echo "$0 needs to a file to read the addresses"
fi

#creating files
touch $filename
test -f $finalFile|| touch $finalFile

calculateAFile()
{
  wget -q $1 -O $2 #get and calculate the md5sum of the page
  if [ $? -ne 0 ]; then #if the wget couldn't for some reason download the page
    echo $i FAILED >&2
    echo $i FAILED >> $filename
  else #if everything went ok
    md5=($(md5sum $2))
    previousSum=($(cat $finalFile | grep $1))
    if [ "${previousSum[1]}" == "" ]; then #didn't find the that page from the previous run
      echo $i INIT
    elif [ "$md5" != "${previousSum[1]}" ]; then #the pages have changed from the previous run of the script
      echo $1
    fi
    echo $1 $md5 >> $filename
  fi
  rm -f $2
}

COUNTER=0

for i in `cat "$1" | grep "^[^#]"`; do
   calculateAFile $i $COUNTER &
   ((COUNTER++))
  
done
wait

#remove the unnecessary files and rename the final file
rm -f $finalFile
rm -f $tempFile
mv $filename $finalFile
rm -f $filename
