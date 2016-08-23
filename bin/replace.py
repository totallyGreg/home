#!/usr/bin/python

#This script will take a file and for each key in a dictionary, replace the key with the corresponding value
# dictionary = [ (entry1, entry1a),  (entry2, entry2b)]
# file = "line entry1
#         line entry2 "

# Specifically it will be used to translate a list of rm-vdsdev; add-vdsdev commands to the new emcpower name

import sys

#infile = open('infile.txt')
#outfile = open('outfile.txt')

# Eventually this will be replaced with a file that will be read in as a dictionary
replacements = {'emcpower1c':'emcpower101c', 'emcpower2c':'emcpower102c'}

#for line in infile:
for line in sys.stdin:
        for src, target in replacements.iteritems():
                line = line.replace(src, target)
        print line

