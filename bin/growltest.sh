#! /bin/bash

# open a new sticky growl notification with the designator 'note'
/usr/local/bin/growlnotify -d note -s 'Begin the Beguine'
sleep 10

# update notification 'note'
/usr/local/bin/growlnotify -d note -s 'Still doing that "Beguine" thing...'
sleep 10
 
# update notification 'note' again
/usr/local/bin/growlnotify -d note -s -m "beguiners can't be choosers." 'Beguine, Beguine, Beguine... '
sleep 10

# update notification 'note', again, and remove stickiness so it disappears
/usr/local/bin/growlnotify -d note "Eh. I'm over it.'"
