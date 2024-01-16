#!/usr/bin/env zsh

# ToDo
# - This should be encrypted since it contains secrets
# - I should store it directly on iCloud instead of desktop? 
# - Volume name should be changed from untitled to something more descriptive

## Options
  # -[no]atomic     do [not] copy files to a temporary location and then rename them to their destination.  Atomic copies are the default.  Non-atomic copying may be slightly faster
  # -volname volname
  # The newly-created filesystem will be named volname.  The default depends the filesystem being used; The default volume name in both HFS+ and APFS is `untitled'.

# This creates a sparsebundle containing all of the listed directories.
# This failed when it went over 10GB in size and not using a sparsebundle
# Also zsh did not allow me to use the backslash line break and thus I switched to #!/bin/bash

# This fails in every way to write directly to the iCloud directory/cache
local iCloud Archive
iCloud="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

# Archive=~/Desktop/Totally_Backed_Up.sparsebundle
# Archive="${iCloud}/Archives/Totally_Backed_Up-$(date -I).sparsebundle"
Archive="/Volumes/EvoStick/Totally_Backed_Up-$(date -I).sparsebundle"
echo "Backup will be created in '${Archive}'"

hdiutil create -volname Totally_Backed_Up -format UDSB \
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
