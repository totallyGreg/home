#!/bin/bash
## My attempt at a watch script to convert mkv's placed into a watch directory into re-wrapped m4vs
## if it has ac3 pass thru and also convert to aac.  

for f in *.mkv;
	do ffmpeg -i "$f" -map 0:v -c:v copy  -map 0:a -c:a copy  -map 0:a -strict -2 -c:a aac -b:a 256k  "${f%mkv}m4v";

done
