#!/usr/bin/perl
#MyPS2PDF.plx
#takes <STDIN> which consists of a list filenames and
#uses ps2pdf to convert to pdf files
#Norman A. Cohen, MD
#29 November 2003
use warnings;
use strict;
use File::Basename;

foreach my $arg (@ARGV) {
  my ($base, $path, $type)=fileparse($arg,qr{\.\w+});
  my $newext="\.pdf";
  my $newname=$path.$base.$newext;
  # make sure file extension is .prn
  # (assumes that this will assure correct filetype)
  if ($type =~ /\.prn/) {
    print "Converting $arg into pdf file $newname.\n";
    my $command = "ps2pdf $arg $newname";
    system $command;
  }
  else
  {
    print "$arg is not a Windows .prn file. Skipping file!\n";
  }
}

