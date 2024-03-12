#!/usr/bin/env zsh

## Options
  # -[no]atomic     do [not] copy files to a temporary location and then rename them to their destination.  Atomic copies are the default.  Non-atomic copying may be slightly faster
  # -volname volname
  # The newly-created filesystem will be named volname.  The default depends the filesystem being used; The default volume name in both HFS+ and APFS is `untitled'.

# This creates a sparsebundle containing all of the listed directories.

local Backups Archive VolumeName

Date=$(date -I)
VolumeName="Totally_Backed_Up-${Date}"
Backups=$HOME/Library/Mobile\ Documents/com\~apple\~CloudDocs/Archives/Backups
Archive="${Backups}/${VolumeName}.sparsebundle"
echo "Backup will be created in '${Archive}'"

hdiutil create -volname ${VolumeName} -format UDSB \
  -encryption \
  "${Archive}" \
  -verbose -noatomic -skipunreadable -spotlight -ov \
  -srcfolder ~/.gnupg \
  -srcfolder ~/.ssh \
  -srcfolder ~/.aws \
  -srcfolder ~/.kube \
  -srcfolder ~/Library/Audio \
  -srcfolder ~/Library/ColorPickers \
  -srcfolder ~/Library/Colors \
  -srcfolder ~/Library/FontCollections \
  -srcfolder ~/Library/Fonts \
  -srcfolder ~/Library/Keychains \
  -srcfolder ~/Library/Preferences \
  -srcfolder ~/Library/QuickLook \
  -srcfolder ~/Library/Screen\ Savers \
  -srcfolder ~/Library/Services \
  -srcfolder ~/Library/Sounds \

  # -srcfolder ~/Downloads \
  # -srcfolder ~/Repositories
  # -srcfolder ~/Library/Application Support  \
