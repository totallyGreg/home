if [[ $(whoami) != 'root' ]]; then
    echo "Must be root to run"
    exit 1
fi

read -p 'Enter Time Machine Hostname: ' HOSTNAME
read -s -p 'Enter Password: ' PASSWORD

TM_NAME=$(hostname -s | sed -e 's/-/ /g')
MOUNT=/Volumes/TimeMachine
SPARSEBUNDLE=$MOUNT/$TM_NAME.sparsebundle
PLIST=$SPARSEBUNDLE/com.apple.TimeMachine.MachineID.plist

echo "Disabling Time Machine"
tmutil disable

echo "Mounting volume"
mkdir $MOUNT
#mount_afp afp://ReadyNAS:$PASSWORD@$HOSTNAME/ReadyNAS $MOUNT
mount_afp afp://totally:$PASSWORD@$HOSTNAME/TimeMachine $MOUNT

echo "Changing file and folder flags"
chflags -R nouchg "$SPARSEBUNDLE"

echo "Attaching sparse bundle"
DISK=`hdiutil attach -nomount -readwrite -noverify -noautofsck "$SPARSEBUNDLE" | grep Apple_HFS | cut -f 1`

echo "Repairing volume"
#diskutil repairVolume $DISK
/sbin/fsck_hfs -fry $DISK

echo "Fixing Properties"
cp "$PLIST" "$PLIST.backup"
sed -e '/RecoveryBackupDeclinedDate/{N;d;}'   \
    -e '/VerificationState/{n;s/2/0/;}'       \
    "$PLIST.backup" \
    > "$PLIST"

echo "Unmounting volumes"
hdiutil detach /dev/$DISK
umount $MOUNT

echo "Enabling Time Machine"
tmutil enable

echo "Starting backup"
tmutil startbackup

exit 0
