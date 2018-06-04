#!/usr/local/bin/python3

import datetime as dt
from collections import Counter

label = "Chapter: "
initial_chapter = 0

def str_to_time(str): 
    chapter_time = dt.timedelta(seconds=float(str))
    return chapter_time

def format_time(t):
    '''Remove 3 digits from microseconds'''
    s = str(t)
    return s[:-3]

def interval(last_chapter_time, chapter_time):
    '''Compare two times and return false unless further than 10 minutes apart'''
    interval = dt.timedelta(minutes=10)
    last_chapter_time 
    difference = chapter_time - last_chapter_time
    if difference > interval: 
        return True
    else:
        return False

name = input("Enter filename:")
if len(name) < 1 : name = "Label Track.txt"

with open(name, "r") as infile, open ("Chapters.txt", "w") as outfile:
    last_chapter = []
    l_chapter_time = dt.timedelta(seconds=0)
    counter = Counter()

    for chapter_line in infile:
        chapter_line = chapter_line.rstrip()
        chapter = chapter_line.split(None,2)
        time_string,chapter_name  = chapter[1],chapter[2]
        chapter_time = str_to_time(time_string)
        is_chapter = interval(l_chapter_time,chapter_time)
        
        # If chapter_time is not within interval (10 minutes) of last one write it out
        if is_chapter:
            counter[chapter_line] += 1
            chapter_number = str(initial_chapter + sum(counter.values()))
            if chapter_name == "S":
                chapter_name = label + chapter_number
            outfile.write('{} {}\n'.format(format_time(chapter_time),chapter_name))
            last_chapter = chapter
            l_time_string, l_chapter_name = last_chapter[1],last_chapter[2]
            l_chapter_time = str_to_time(l_time_string)

    #print(sum(counter.values()))

