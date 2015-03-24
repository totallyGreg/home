#!/bin/sh

# Given a specific domain name, this script will try to find all the 
# cached icons for that domain. With the '-r' flag included, it'll actually 
# remove those icons.
#
# This script is (C) 2004 by Dave Taylor. Permission is granted to 
#   disseminate this so long as this comment is retained intact. Learn 
#   more about Dave's scripts by visiting http://www.intuitive.com/wicked/ 
#   or ask Dave a question at http://www.AskDaveTaylor.com/

icondir="$HOME/Library/Safari/icons"
temp="/tmp/$0.$$"
removeme=0

trap "/bin/rm -f $temp" 0               # remove temp file on exit

# specified -r ?

if [ "$1" = "-r" ] ; then
  removeme=1
  shift
fi

# used properly?

if [ $# -eq 0 ] ; then
  echo "Usage: $0 {-r} domainname      ('-r' removes matching cached icons)"
  exit 0
fi

# is Safari running?  If so, that's a no-no

if [ $removeme -eq 1 -a \
      "$(ps aux | grep -i safari | grep -v grep)" != "" ] ; then
  echo "Error: deleting icons from the cache while Safari is running" >&2
  echo "is not a good idea. Quit Safari then run this script again." >&2
  exit 0
fi

find $icondir -print | \
  xargs grep "$1" 2>&1 | grep -v "not permitted" > $temp

if [ $removeme -eq 1 ] ; then
  for filename in $(cut -f3 -d\  $temp)
  do
    echo "removing file $filename"
    rm $filename
  done
  echo "Done. Now restart Safari and revisit that site."
else
  cat $temp
fi

exit 0
