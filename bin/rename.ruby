#!/usr/bin/ruby
#Need to add .m4v to end of new filenames
new_filenames = IO.readlines("vol1")
#this seems to add .m4v on a seperate line
old_filenames = Dir.glob("LOONEY TUNES D1-*.m4v")
old_filenames.each_with_index {|x, y| 
	#squeeze gets rid of characters too!!! must find new method
	#to remove whitespace
	#puts  "#{x} => #{new_filenames[y].chomp}"
	File.rename(x, new_filenames[y])
	}
