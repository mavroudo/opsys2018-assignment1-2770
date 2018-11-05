 #!/bin/bash

filename="tempResults.txt"
tempFile="tempWGET.txt"
finalFile="results.txt"
#checking for a file to open
if [ $# -ne 1 ]
then
  echo "$0 needs to a file to read the addresses"
fi

touch $filename #creating tempfile
test -f $finalFile|| touch $finalFile

for i in `cat "$1" | grep "^[^#]"`; do

  wget -q $i -O $tempFile #get and calculate the md5sum of the page
  md5=`md5sum $tempFile | awk '{ print $1 }'`

  previousSum=`cat $finalFile | grep $i | awk '{print $2}'`

  if [ "$previousSum" == "" ] #didn't find the that page from the previous run
  then
    echo $i INIT
  fi

  if [ "$md5" != "$previousSum" ]#the pages have changed from the previous run of the script
  then
    echo $i
  fi

  echo $i $md5 >> $filename
done

#remove the unnecessary files and rename the final file
rm -f $finalFile
rm -f $tempFile
mv $filename $finalFile
rm -f $filename
