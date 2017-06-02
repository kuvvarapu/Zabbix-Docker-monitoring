#!/bin/sh
#This scrip tis used to monitor docker containers and gives you the Exited docker name
#Author: Kiran
#Date: 30/May/2017
dinfo="/tmp/dinfo"
dps="/tmp/dps"

#Gathering total containers
docker info >$dinfo 2>/dev/null
Containers=`grep Containers $dinfo |awk '{print $NF}'`
Running=`grep Running $dinfo |awk '{print $NF}'`

#Looking for Exited Containers
deadContainers(){
docker ps -a|grep -v STATUS>$dps 2>/dev/null
#for((i=0;i<$Containers;i++))
i=0
while [ "$i" -le "$Containers" ]; do
  row=$((i+1))p
  dName=$(sed -n $row $dps|awk -F ' ' '{print $NF}')
  rStatus=$(sed -n $row $dps|grep -o Up|wc -l)
  #total=$total+$dName
  if [ "$rStatus" -eq 0 ]
  then
    echo "$dName" 
#Container is Down"
fi
i=$(( i + 1 ))
done
}
#Mail
if [ "$Containers" -ne "$Running" ]
then
#  echo "0"
  rm /tmp/dinfo
  deadContainers
  rm /tmp/dps
else
  echo "Total Container running=$Running"
 rm /tmp/dinfo
fi
