#!/usr/bin/perl 
use warnings;
#use strict;

#$ip="64.46.156.67" ;

open (FILE, "primary.conf") or die "Can't open primary: $!\n";
while ($line = <FILE>) {
	if ($line =~ /zone/) {
	(,$zone,) = split('"',$line) #($line =~ /["]*["]/) ;
		print $zone;
	}
#	$zone = $line(zone);
#	print "zone \"$zone\" {\n" ;
#	print "\ttype slave;\n";
#	print "\tfile \"Secondaries/$zone\";\n";
#	print "\tmasters {$ip;};\n";
	
	else {
		next;
	}
}
