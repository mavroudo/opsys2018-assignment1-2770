 #!/bin/bash

filename="tempResults.txt"
tempFile="temp.txt"
finalFile="results.txt"
#checking for a file to open
if [ $# -ne 1 ]
then
  echo "$0 needs to a file to read the addresses"
fi

touch $filename #creating tempfile
test -f $finalFile|| touch $finalFile

for i in `cat "$1" | grep "^[^#]"`; do

  wget -q $i -O temp.txt #get and calculate the md5sum of the page
  md5=`md5sum $tempFile | awk '{ print $1 }'`
  previousSum=`cat $finalFile | grep $i | awk '{print $2}'`
  echo $?
  if [ "$md5" == "$previousSum" ]
  then
    echo yes
  fi
  echo $i $md5 >> $filename
done
rm -f $finalFile
rm -f $tempFile
mv $filename $finalFile
rm -f $filename
