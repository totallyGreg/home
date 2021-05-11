#!/bin/zsh

# ToDo
# - This should be encrypted since it contains secrets
# - I wish i could figure out why hdiutil does not respect \ line separators
# - I should store it directly on iCloud instead of desktop? 
# - Volume name should be changed from untitled to something more descriptive

## Options
   # -[no]atomic     do [not] copy files to a temporary location and then rename them to their destination.  Atomic copies are the default.  Non-atomic copying may be slightly faster.out

  # -volname volname
  #           The newly-created filesystem will be named volname.  The default depends the filesystem being used; The default volume name in both HFS+ and APFS is `untitled'.
  #           -volname is invalid and ignored when using -srcdevice.

hdiutil create -volname Totally_Backed_Up -format UDSB -noatomic -skipunreadable -ov ~/Desktop/Totally_Backed_Up.sparsebundle -srcfolder ~/.gnupg -srcfolder ~/.ssh -srcfolder ~/Library/Colors -srcfolder ~/Library/ColorPickers -srcfolder ~/Library/Keychains -srcfolder ~/Library/Fonts -srcfolder ~/Library/FontCollections -srcfolder ~/Library/Sounds -srcfolder ~/Library/Preferences -srcfolder ~/Library/Screen\ Savers -srcfolder ~/Library/Application\ Support  -srcfolder ~/Downloads 

# -srcfolder ~/Repositories
