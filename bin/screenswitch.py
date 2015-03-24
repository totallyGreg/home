#!/usr/bin/python

# Download amstracker from http://www.kernelthread.com/software/ams/
# Put amstracker and screenswitch.py in the same directory. Go to this directory
# in the Terminal and type:
# ./amstracker -u 0.1 -s | python screenswitch.py
# Hit ctrl-c to exit.

THRESHOLD = 2 # lower numbers makes this more sensitive
COMPONENT = 0 # three dimensions: sideways: 0, forward/back: 1, up/down: 2

# two types of behaviour:
BEHAVIOR = "bump" 

import sys, os

def run_command(command):
	script = os.popen("osascript", "w")
	script.write('tell application "System Events"\r\n')
	script.write('keystroke (keystroke "f" using command down & shift down & control down & option down)\r\n')
	script.write('end tell\r\n')
	script.close()

since = 0
while 1:
	try:
		line = sys.stdin.readline()
		since += 1
		x = int(line.split()[COMPONENT])
		if abs(x) > THRESHOLD and since > 3: # ignore commands for 0.5 seconds
			if "bump" == BEHAVIOR:
				run_command("")
			since = 0
	except KeyboardInterrupt:
		sys.exit(0)
	except:
		pass
