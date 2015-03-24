#!/bin/ksh
#set -x
# Use this script to set up a ldom
# _HOST = host / guest ldom to create
# _FREEDSK = number of disks available to use
# _NEXTDISK = next disk available for use

BASEDIR="/opt/IHSldmcfg"
if [ ! -f $BASEDIR/etc/ldm-environment ]
then
       echo "Unable to locate environment file, aborting"
       exit 1
fi

procedure="create_guest"
. $BASEDIR/etc/ldm-environment
export PATH=$PATH:/opt/SUNWldm/bin/:/net/ccuaweb2/export/scripts

# ---------------- Function ---------------------------
function get_resources {
domain=${_HOST}
max_vcpu=`$BASEDIR/sbin/GET_resource vCPU`
[ "$max_vcpu" = "" ] && ERROR_exit "Unable to extract available vCPU number"
max_mau=`$BASEDIR/sbin/GET_resource MAU`
[ "$max_mau" = "" ] && ERROR_exit "Unable to extract available MAU number"
max_memory=`$BASEDIR/sbin/GET_resource memory`
[ "$max_memory" = "" ] && ERROR_exit "Unable to extract available memory"
net_resource=`$BASEDIR/sbin/GET_resource network | $BIN/sed -e 's/,/ /g'`
[ "$net_resource" = "" ] && ERROR_exit "Unable to identify network resource"
# Disks are not allocated by this point
# took line from uem_get_freedisk and dumped list of emc devices into array disk_resource
echo "Scanning for available free disks.  This could take some time."
disk_resource=($(/opt/vcapcoll/bin/disk_free 2>/dev/null | grep emcpower | awk '{print $1}'))

#Check to see if array is empty
[ "${disk_resource[*]}" = "" ] && ERROR_exit "Unable to identify free vdisk resource"
#
# Grab details from the user

num_cpu=`$BASEDIR/sbin/READ_answer "Please enter number of vCPUs for $domain" numeric 1 $max_vcpu`
domain_cpu=$num_cpu
PRINT_msg "Automatically allocating one MAU for each 8 VCPU requested"
num_mau=$((num_cpu/8))
domain_mau=$num_mau
num_memory=`$BASEDIR/sbin/READ_answer "Please enter amount of memory for $domain" size 1G $max_memory`
domain_memory=$num_memory
network_sw=$net_resource
} # end get_resources


# ---------------- Function ---------------------------

get_freedisk () {
	# this returns the next free disk from the array
	# it then removes the called disk from the array
	# it then resets _FREEDISK count (also used as the index) 

	next_free_disk=disk_resource[$_FREEDSK-1]

	# return value of 
	echo $next_free_disk
	## remove used disc from array
	unset disk_resource[$_FREEDSK-1]
	# update free disk count
	_FREEDSK=${#disk_resource[*]}                                                      
	
	# error checking if _FREEDSK equals zero bail out
	# not necessary since checking is done on the input but good practice in a function

}

# Create disk images
# _DATADISK = number of required disks to create
# Prompt for number of data disks.
# Create script that creates disk images in background
# Create disk image for root disk only
#    print "Adding disk ${_DATADISK} as data disk number ${_DISKNUM}.  Please wait"

function create_image {
  print "Creating disk${_DISKNUM} "
  print "Please wait "
  ldm add-vdsdev /dev/dsk/${_DATADISK} ${_HOST}-vol${_DISKNUM}@primary-vds0
  _RC=$?
  if ((${_RC} > 0 )); then
     print "Error in adding VDSDEV disk${_DISKNUM}: ${_RC}"
     exit
  fi
  ldm add-vdisk disk${_DISKNUM} ${_HOST}-vol${_DISKNUM}@primary-vds0 ${_HOST}
  _RC=$?
  if ((${_RC} > 0 )); then
     print "Error in adding VDISK disk${_DISKNUM}: ${_RC}"
     exit
  fi
  print "Completed disk ${_DISKNUM}"
} # end create_images function

# ---------------- Function ---------------------------

# ------------  Main section -----------------------

# Check the frame to see if ldoms will prevent configuration
if ldm list | awk '{print $3}' | grep d; then
  print "Host in need for reconfig - aborting script"
  print "Please reboot domain showing "d" in ldm list below"
  ldm list
  exit
fi

# Read host to build
print -n "Enter hostname (in lowercase): "
read _HOST

# Check to see if the ldom already exists
# Return code 1 if ldom does not exist
if ldm list ${_HOST} | grep "was not found" >/dev/null; then
  print "Guest ${_HOST} does not exist.  Creating"
else
  print "Guest ${_HOST} already defined"
  ldm list ${_HOST}
  exit
fi

# Gather information about CPU, memory, etc.
get_resources

print Number of CPUS: $domain_cpu
print Number of MAU: $domain_mau
print Amount of memory: $domain_memory
print "Using network switch(es): $network_sw"

# check to see if a pool has been created for this
# Check status: zpool status <zfspool>
zfs list | grep ${_HOST} >/dev/null 2>&1
_RC=$?
if ((${_RC}==0)); then
  print "Pool ${_HOST} already exists"
  exit
fi
## Replaced call to uem_num_freedisk with array count
_FREEDSK=${#disk_resource[*]}
# Look for available disk:
# Request number of SAN or data disk required - add one for total number of disk
print "Available number of disks: ${_FREEDSK} "
if ((${_FREEDSK} <= 0 )); then
  print "No available disk"
  exit
fi
echo "Each data disk is 33Gb - Raw device given to LDOM"
PRINT_msg "Please enter number of data / SAN disks for ${_HOST}"
num_disk=`$BASEDIR/sbin/READ_answer "Enter zero if ${_HOST} will only have a root/OS disk" numeric 0 ${_FREEDSK}`
((_DATADISK=$num_disk+1))

# DATADISK is number of total disks required
# num_disk is number of data or SAN disks
if ((${_DATADISK} > ${_FREEDSK})); then
  print "Not enough free disk available to build domain ${_HOST}"
  print "Required disk: ${_DATADISK}"
  print "Available disk: ${_FREEDSK}"
  exit
fi

# Get next available disk - assign to root disk
# replaced initial call to uem_get_freedisk with get_freedisk function call
#_NEXTDISK=$(uem_get_freedisk)
_ROOTDISK=`get_freedisk`

print "Creating zfs file system - mounted at /export/ldoms/${_HOST}"
print "Adding disk ${_ROOTDISK} as root disk to host ${_HOST}"
# Add disk to root pool - create root disk image in seperate filesystem
####  Check to see if root pool exists, if not, create it with next disk
zpool list root >/dev/null 2>&1
_RC=$?
if ((${_RC} > 0 )); then
  print "Root pool does not exist - creating with initial disk"
  zpool create root ${_ROOTDISK}
  _RC=$?
  if ((${_RC} > 0 )); then
     print "Error in zpool root - can not create: ${_RC}"
     exit
  fi
fi

## replace call to uem_get_freedisk with get_freedisk function
_NEXTDISK=`get_freedisk`
zpool add root ${_NEXTDISK}
_RC=$?
if ((${_RC} > 0 )); then
  print "Error in zpool root - can not add new disk: ${_RC}"
  exit
fi
zfs create -o mountpoint=/export/ldoms/${_HOST} root/${_HOST}
_RC=$?
if ((${_RC} > 0 )); then
  print "Error in ZFS create: ${_RC}"
  exit
fi
# Create disk image or hold off until later ?
# Create disk for OS Image
print "Creating 30Gb disk image at: /export/ldoms/${_HOST}/disk0"
print "Please wait"
mkfile 20g /export/ldoms/${_HOST}/disk0
_RC=$?
if ((${_RC} > 0 )); then
  print "Could not create root disk: RC = ${_RC}"
  exit
fi

print "Adding disk images for Virtual Disk Server for ${_HOST}"
ldm add-vdsdev /export/ldoms/${_HOST}/disk0 ${_HOST}-vol0@primary-vds0
if ((${_RC} > 0 )); then
  print "Could not create virtual disk server: RC = ${_RC}"
  print "To remove and restart - cut and paste the following lines"
  exit
fi

# Create guest with the values provided earlier
# domain=$1
# num_cpu=$2
# num_mau=$3
# num_memory=$4
./uem_create_guest ${_HOST} ${num_cpu} ${num_mau} ${num_memory}

(( _DISKNUM=1 ))
# _FREEDSK is number of disks available
# num_disk is number of data disks requested

# Add raw disk to domain - do not create disk
while (( ${num_disk} >= ${_DISKNUM} )); do
  print "Adding data disk"
  # Find next available disk
  # replaced uem_get_freedisk with get_freedisk function
  _DATADISK=`get_freedisk`
  # Attach disk to LDOM

  # zpool add ${_HOST} ${_DATADISK}
  # _RC=$?
  # if ((${_RC} > 0 )); then
     # print "Could not create data disk ${_DISKNUM}: RC = ${_RC}"
     # exit
  # fi
  print "Adding disk ${_DATADISK} as data disk number ${_DISKNUM}.  Please wait"
  create_image
  _RC=$?
  if ((${_RC} > 0 )); then
     print "Could not create disk image on data disk ${_DISKNUM}: RC = ${_RC}"
     exit
  fi
  # print "/opt/SUNWldm/bin/ldm add-vdsdev /export/ldoms/${_HOST}/disk${_DISKNUM} ${_HOST}-vol${_DISKNUM}@primary-vds0" >>/tmp/${_HOST}.ksh

  # Add data disks to new ldom to be run later
  # print "/opt/SUNWldm/bin/ldm add-vdisk disk${_DISKNUM} ${_HOST}-vol${_DISKNUM}@primary-vds0 ${_HOST}" >>/tmp/${_HOST}.ksh
  print "Disk ${_DATADISK} added as data disk ${_DISKNUM}"
  print " "
  let _DISKNUM=_DISKNUM+1
done


# Set boot parms (device and auto-boot)
print "Setting up boot device and set auto-boot? to false"
ldm set-variable boot-device=/virtual-devices@100/channel-devices@200/disk@0 ${_HOST}
ldm set-variable auto-boot?=false ${_HOST}

# Add data disks to new ldom to be run later
# append mkfile to ksh file to create disk
print "Adding disks and creating disk images - this will take 10 to 20 minutes per disk"
print "and will run in the background as /tmp/${_HOST}.ksh"
print "print Disk build completed.  Please check /export/ldoms/${_HOST}" >>/tmp/${_HOST}.ksh
print "ldm list-bindings ${_HOST}" >>/tmp/${_HOST}.ksh
/tmp/${_HOST}.ksh

# Restart virtual console after creating new domain.  Otherwise the telnet localhost will hang
svcadm restart /ldoms/vntsd:default

#-------------------------------------------------------------------------
ldm list-bindings primary

ldm start ${_HOST}
ldm list-bindings ${_HOST}

# Create new start / stop script and add entries to SCsudo
# cd /opt/PRldmsa/scripts
# Creates a new script to start / stop the host
# sed s/DOMAIN/${_HOST}/g template >${_HOST}
# Add entry to command lines (of which I don't know how to do yet)
# Append entry to /etc/opt/SCsudo/commands.conf to create new command to stop / start domain ${_HOST}
# print "${_HOST}       /opt/PRldmsa/scripts/${_HOST}" >>/etc/opt/SCsudo/commands.conf
# Add new group to scsudo.conf to allow scripts to run
# print "${_HOST}       root    *       ${_HOST}" >>/etc/opt/SCsudo/scsudo.conf
# Add userids to run other commands - listing commands
# print "ldomadmins      ${_SOEID} >>/etc/opt/SCsudo/users.conf
# print "${_HOST}admins      ${_SOEID} >>/etc/opt/SCsudo/users.conf

