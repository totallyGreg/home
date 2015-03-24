#!/bin/sh

#Growl my Router alive!
#2010 by zionthelion73 [at] gmail . com
#use it for free
#redistribute or modify but keep these comments
#not for commercial purposes

iconpath="/path/to/router/icon/file/internet.png"
# path must be absolute or in "./path" form but relative to growlnotify position
# document icon is used, not document content

# Put the IP address of your router here
localip=10.0.1.1

clear
echo 'Router avaiability notification with Growl'

#variable
avaiable=false

com="################"
#comment prefix for logging porpouse

while true;
do
if $avaiable
then
  echo "$com 1) $localip avaiable $com"
  echo "1"
  while ping -c 1 -t 2 $localip
    do
      sleep 5
    done
  growlnotify  -s -I $iconpath -m "$localip is offline"
  avaiable=false
else
  echo "$com 2) $localip not avaiable $com"
  #try to ping the router untill it come back and notify it
  while !(ping -c 1 -t 2 $localip)
  do
   echo "$com trying.... $com"
   sleep 5
  done
  
  echo "$com found $localip $com"
  growlnotify -s -I $iconpath -m "$localip is online"
  avaiable=true
fi

sleep 5

done
