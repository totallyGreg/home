#\C!/bin/bash
set -e
set -x

if [[ $(whoami) != 'root' ]]; then
  echo "Must have root privileges to run"
  exit 1
fi


## tmutil destinationinfo will provide the URL
# Name          : totally_reversed
# Kind          : Network
# URL           : afp://totally@FreeNASty._afpovertcp._tcp.local./totally_reversed
# Mount Point   : /Volumes/com.apple.TimeMachine.totally_reversed-F5ED3A5E-EB28-4B1A-9C07-B294FEBCBA2A
# ID            : 0F1682E6-3015-4A9D-9741-32A42F1796F6

URL=`tmutil destinationinfo | grep URL | cut -f 3 -d " "`

if [ ${#URL} -eq 0 ]
then
  read -p 'Enter Time Machine Hostname: ' HOSTNAME # freenasty.home.falcone.us
  read -p 'Enter Share: ' SHARE  # totally_reversed
  read -p 'Enter Username: ' USERNAME # username that created the share
  # read -s -p 'Enter Password: ' PASSWORD
  # using mount_afp -i will prompt for password.
fi

TM_NAME=$(hostname -s | sed -e 's/-/ /g')
MOUNT=/Volumes/TimeMachine
SPARSEBUNDLE=$MOUNT/$TM_NAME.sparsebundle
PLIST=$SPARSEBUNDLE/com.apple.TimeMachine.MachineID.plist

echo "Disabling Time Machine"
tmutil disable

echo "Mounting volume"
mkdir $MOUNT
#mount_afp afp://$USERNAME:$PASSWORD@$HOSTNAME/$SHARE $MOUNT
mount_afp -i afp://$USERNAME@$HOSTNAME/$SHARE $MOUNT

echo "Changing file and folder flags"
chflags -R nouchg "$SPARSEBUNDLE"

echo "Attaching sparse bundle"
DISK=`hdiutil attach -nomount -readwrite -noverify -noautofsck "$SPARSEBUNDLE" | grep Apple_HFS | cut -f 1`

echo "Repairing volume"
#diskutil repairVolume $DISK
/sbin/fsck_hfs -drfy $DISK

# Check to make sure it was repaired sucessfully
tail /var/log/fsck_hfs.log
result=‘The Volume was repaired successfully’
read -p "Continue if repair sucessful?(Y/y) " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Fixing Properties"
    cp "$PLIST" "$PLIST.backup"
    sed -e '/RecoveryBackupDeclinedDate/{N;d;}'   \
    -e '/VerificationState/{n;s/2/0/;}'       \
    "$PLIST.backup" \
    > "$PLIST"
fi

echo "Unmounting volumes"
hdiutil detach $DISK
umount $MOUNT

echo "Enabling Time Machine"
tmutil enable

echo "Starting backup"
# tmutil startbackup --destination $DESTID
tmutil startbackup

exit 0
