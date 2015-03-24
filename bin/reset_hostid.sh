#!/bin/sh
#
# Script to reset the hostid of a guest domain (in case of a clash)
#  Expects the name of the domain to be amended (which must be bound
#  but not active) and the new hostid to be used for the domain
#
# Deletes the existing domain definition and then uses create_guest
# to recreate the domain.  An XML backup of the original domain config
# is stored in /var/opt/IHSldmcfg before removing the domain.
#
#
#  Modified April 2010  to create modified copy of backup file and
#                       use that to create the new domain.
#                       New update to use set-domain to force a
#                       hostid (new for LDoms 1.3 software)

BASEDIR="/opt/IHSldmcfg"
if [ ! -f $BASEDIR/etc/ldm-environment ]
then
       echo "Unable to locate environment file, aborting"
       exit 1
fi

procedure="reset_hostid"
. $BASEDIR/etc/ldm-environment

[ "$1" = "" ] && ERROR_exit "The name of the domain and its new hostid are required"
[ "$2" = "" ] && ERROR_exit "The new hostid is required"
#
# Check if numeric or hex numeric hostid
#
hex="no"
num="no"
[ "`$BIN/echo $2 | $BIN/grep '^0x' | $BIN/sed -e 's/^0x//' -e 's/[0-9]//g' -e 's/[a-f]//g'`" = "" ] && hex="yes"
[ "$hex" = "no" ] && [ "`$BIN/echo $2 | $BIN/sed -e 's/[0-9]//g'`" = "" ] && num="yes"
[ "$hex" = "no" -a "$num" = "no" ] && ERROR_exit "New hostid must be hex numeric"

domain="$1"
hostid="$2"

# Check if it exists already and grab all the current settings
$LDM ls-domain $domain >> /dev/null 2>&1
[ "$?" != "0" ] && ERROR_exit "Domain $domain does not exist"

#
# Must be bound or active to be able to extract the current hostid
#
state=`$BASEDIR/sbin/CHK_domain $domain state`
[ "$state" != "bound" -a "$state" != "active" ] && ERROR_exit "Domain $domain is not in bound or active state"

curr_hostid=`$BASEDIR/sbin/CHK_domain $domain hostid`
[ "$curr_hostid" = "" ] && ERROR_exit "Unable to extract current $domain hostid"
[ "$curr_hostid" = "$hostid" ] && ERROR_exit "Domain $domain hostid is already $curr_hostid"

if [ "$state" = "active" ]
then
       PRINT_msg "Stopping $domain"
       LOG_msg "$LDM stop-dom $domain"
       $LDM stop-dom $domain
       ERROR_check "Failed to stop $domain"
fi

PRINT_msg "Changing hostid to $hostid for $domain"
LOG_msg "$LDM set-domain hostid=$hostid $domain"
$LDM set-domain hostid=$hostid $domain
ERROR_check "Failed to set hostid $hostid for $domain"

if [ "$state" = "active" ]
then
       PRINT_msg "Starting $domain"
       LOG_msg "$LDM start-dom $domain"
       $LDM start-dom $domain
       ERROR_check "Failed to start $domain"
fi

exit 0
