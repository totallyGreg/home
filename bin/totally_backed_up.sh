#!/bin/zsh

# ToDo
# - This should be encrypted since it contains secrets
# - I wish i could figure out why hdiutil does not respect \ line separators
# - I should store it directly on iCloud instead of desktop? 
# - Volume name should be changed from untitled to something more descriptive

hdiutil create -ov ~/Desktop/Totally_Backed_Up.dmg -srcfolder ~/.gnupg -srcfolder ~/.ssh -srcfolder ~/Library/Colors -srcfolder ~/Library/ColorPickers -srcfolder ~/Library/Keychains -srcfolder ~/Library/Fonts -srcfolder ~/Library/FontCollections -srcfolder ~/Library/Sounds -srcfolder ~/Library/Preferences -srcfolder ~/Library/Screen\ Savers -srcfolder ~/Library/Application\ Support -srcfolder ~/Downloads
