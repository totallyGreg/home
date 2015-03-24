#!/bin/bash
#
# TP Probe v.0.1
#
# Gets stats from hardware sensors, such as temperatures, voltages,
# and fanspeeds. For Mac OS X. Sensors vary depending on machine,
# Powermacs have lots, down to mac mini's, which don't seem to have 
# any. Formatting may be rough, because there is wide variation 
# between machines, and I wanted to capture all possible sensors on 
# as many macs as possible and I only own one.
#
# If you run this and it works, or doesn't work, or looks awful, or 
# anything, please send me an email, preferably including the output 
# of tp -l so I can make this better :)
#
# -----------------------------------------------------------------
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details. 
# http://www.gnu.org/licenses/gpl.html
#
# Copyright (C) 2005 Rupa Deadwyler djbidi@gmail.com

# test operating sytem

if [ `uname` == "Darwin" ]
 then

# help message

 if [ "$1" == "-h" ]
  then 
  basename=`echo $0 | sed 's/.*\///'`
  echo "usage: $basename [option]"
  echo "     -l also show Machine Name and CPU Type"
  echo "     -h display this help message"
  echo "     -e <regex> diplay only lines that match regex"
  exit
 fi

# if -l display Machine Name and CPU Type

 if [ "$1" == "-l" ]
  then
  system_profiler SPHardwareDataType | awk '/Machine Name/ || /Machine Model/ || /CPU Type/' | sed 's/[^:]*: //' | awk '{ printf $0 "  " }'
  echo
 fi
 
# sensor data
sensors=`ioreg -n IOHWSensor | awk '/location/ || /current-value/ || /"type"/' | sed -e 's/[^"]*"//' -e 's/" =//' -e 's/location//' -e 's/type//' -e 's/"//g' | awk '{ d=($2/65536); if ($1=="current-value") print substr(d,1,7) "\t" ; if ($1!="current-value") print $0 }' | sed -e 's/temperature/Celsius/' -e 's/voltage/volts/' -e 's/fanspeed/fan RPM/' -e 's/current/Amps/' -e 's/^temp$//' -e 's/ //' | awk '{ if ((NR % 3) == 0) print $0; else printf $0 " " }'`

# 

if [ "$1" == "-e" ]
 then
 if [ "$2" == "" ]
  then
  echo no regex selected
 else
  echo "$sensors" | awk "/$2/"
 fi
else
 echo "$sensors"
fi

# error message if unsupported machine 
 
else
 echo -e "\nThis appears not to be an OS X machine\n"
fi

