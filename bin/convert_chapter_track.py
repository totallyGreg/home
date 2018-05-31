#!/usr/local/bin/python3

#import math

name = input("Enter filename:")
if len(name) < 1 : name = "Label Track.txt"
try:
    with open(name, "r") as infile, open ("Chapters.txt", "w") as outfile:
        for chapter in infile:
            chapter = chapter.rstrip()
            words = chapter.split(None,2)
            time = words[1]
            time = float(time)
            chapter_name = words[2]
            seconds, millisecs = int(time), time-int(time)
            #divmod(time, 1) # math.modf(time) # (0.5678000000000338, 1234.0)
            seconds = int(seconds)
            minutes, seconds = divmod(seconds, 60)
            hours, minutes = divmod(minutes, 60)
            
            chapters = [('hours', hours), ('minutes', minutes), ('seconds', seconds),
                        ('millisecs', millisecs), ('chapter_name', chapter_name)]
            #time_string = ':'.join('{} {} {}'.format(hours, minutes, seconds)
            #print hours,":",minutes,":",seconds":",chapter_name
            seconds = seconds + millisecs
            outfile.write('{}:{}:{:.3f} {}\n'.format(hours,minutes,round(seconds,4),chapter_name))
except:
    print ('File cannont be opened:', name)
    exit()



