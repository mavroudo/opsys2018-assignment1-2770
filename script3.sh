#!/bin/bash
resources="resources"
assignments="assignments"
#check if there is only one parammeter given
if [ $# -ne 1 ]
then
  echo "$0 needs a tar.gz file"
fi
#unzip the file with the txts
mkdir -p $resources
mkdir -p $assignments
tar xzf $1 -C $resources
cd $resources


for i in `find . -type f -name "*.txt"`; do
  gitUrl=`cat $i | grep "^https" | head -1`
  if [ "$gitUrl" != "" ]; then
    cd ../$assignments
    git clone -q $gitUrl
    if [ $? -eq 0 ]; then
      echo $gitUrl ": Cloning OK"
    else
      echo $gitUrl ": Cloning FAILED"
    cd ../$resources
  fi
done
