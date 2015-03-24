#!/usr/bin/perl -wap

use Getopt::Std;

BEGIN {
	getopt("a");
	$master = $opt_a;
	die "Usage:  $0 -a <master's addr> <conf file>\n" unless $master && (@ARGV == 1);
}

if (/type\s+master/) {
	$whitespace = substr($_, 0, index($_, "type"));
	s/master/slave/;
	print;
	print $whitespace, "masters { ", $master, "; };\n"; 
	next LINE;
}

s/db/bak/ if /^\s*file/;
