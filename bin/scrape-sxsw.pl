opyright © 2012 Jamie Zawinski <jwz@jwz.org>
#
# Permission to use, copy, modify, distribute, and sell this software and its
# documentation for any purpose is hereby granted without fee, provided that
# the above copyright notice appear in all copies and that both that
# copyright notice and this permission notice appear in supporting
# documentation.  No representations are made about the suitability of this
# software for any purpose.  It is provided "as is" without express or 
# implied warranty.
#
# Build an ICS file of bands of interest at SXSW.
#
#  - First, generate a list of bands of interest by getting a list
#    of all artists with at least one song ranked 3 stars or higher
#    in iTunes.
#
#  - Then scrape sxsw.org and build ICS from it.
#
#  - Keep only events with bands of interest.
#
#  - Pull full event descriptions from sxsw.org (instead of only the
#    short excerpts that sched.org provides).
#
#  - Set location of each event to include the street address of the venue.
#
#  - Update each event to note other dates on which this band is playing
#    (so that you can look at an event on Wednesday and know that you
#    will also have an opportunity to see this band on Thursday).
#
# Before importing the generated .ics file into iCal, I strongly suggest:
#
#  - Check "Preferences / Advanced / Turn on time zone support".
#  - Uncheck "Preferences / General / Add a default alert".
#
# Created:  5-Mar-2012.

require 5;
use diagnostics;
use strict;
use bytes;

use POSIX qw(mktime strftime);
use LWP::Simple;
use Date::Parse;

my $progname = $0; $progname =~ s@.*/@@g;
my $version = q{ $Revision: 1.6 $ }; $version =~ s/^[^\d]+([\d.]+).*/$1/;

my $verbose = 1;
my $debug_p = 0;

my $itunes_xml = $ENV{HOME} . "/Music/iTunes/iTunes Music Library.xml";
my $base_url = ('http://schedule.sxsw.com/2012/' .
                '?conference=music&lsort=name&day=ALL&category=Showcase');

my $zone = 'US/Central';


# Strip HTML and blank lines and stuff.
#
sub clean($) {
  my ($s) = @_;

  return '' unless defined($s);

  $s =~ s/<BR>\s*/\n/gsi;
  $s =~ s/<P>\s*/\n\n/gsi;
  $s =~ s/<[^<>]*>//gsi;

  $s =~ s/&nbsp;/ /gs;
  $s =~ s/&lt;/</gs;
  $s =~ s/&gt;/>/gs;
  $s =~ s/&amp;/&/gs;

  # Fucking Unicode. decode_utf8() does not work here and I don't know why.
  #
  $s =~ s/\342\200\220/-/gs;
  $s =~ s/\342\200\223/ -- /gs;
  $s =~ s/\342\200\224/ -- /gs;
  $s =~ s/\342\200\230/\'/gs;
  $s =~ s/\342\200\231/\'/gs;
  $s =~ s/\342\200\234/\"/gs;
  $s =~ s/\342\200\235/\"/gs;
  $s =~ s/\342\200\241/a/gs;
  $s =~ s/\342\200\242/*/gs;
  $s =~ s/\342\200\246/ /gs;
  $s =~ s/\342\200\250/*/gs;
  $s =~ s/\342\200\262/\'/gs;
  $s =~ s/\342\200\263/\"/gs;
  $s =~ s/\342\200\266/o/gs;
  $s =~ s/\303\266\171/o/gs;
  $s =~ s/\303\251/e/gs;
  $s =~ s/\303\274/u/gs;
  $s =~ s/\303\240/ -- /gs;
  $s =~ s/\312\273/\'/gs;
  $s =~ s/\312\274/\'/gs;
  $s =~ s/\037//gs;
  $s =~ s/\302 / /gs;
  $s =~ s/\302\240/ /gs;
  $s =~ s/\302\204/\"/gs;
  $s =~ s/\302\223/\"/gs;
  $s =~ s/\013/\n\n/gs;

  $s =~ s/\r\n/\n/gs;
  $s =~ s/\r/\n/gs;
  $s =~ s/\t/ /gs;
  $s =~ s/ +/ /gs;
  $s =~ s/^ +| +$//gm;
  $s =~ s/\n/\n\n/gs;
  $s =~ s/\n\n\n+/\n\n/gs;
  $s =~ s/^\s+|\s+$//gs;

  return $s;
}


# Basically a soundex hash of the string, so that punctuation and simple
# spelling mistakes don't matter.
#
sub simplify_artist($) {
  my ($str) = @_;

  $str = lc($str);
  my $orig = $str;
  1 while ($str =~ s/\b(a|an|and|in|of|on|for|the|with|dj|los|le|les|la)\b//gi);
  $str =~ s/[^a-z\d]//g;     # lose non-alphanumeric
  $str =~ s/(.)\1+/$1/g;   # collapse consecutive letters ("xx" -> "x")
  $str = $orig if ($str eq '');
  return $str;
}


# Get a list of highly-rated bands from the iTunes XML file.
#
sub load_bands() {
  open (my $in, '<', $itunes_xml) || error ("$itunes_xml: $!");
  print STDERR "$progname: reading $itunes_xml\n" if ($verbose);
  local $/ = undef;  # read entire file
  my $body = <$in>;
  close $in;

  my $stars = 3;

  my @e = split (m@<key>Track ID</key>@, $body);
  shift @e;
  my %artists;
  foreach my $e (@e) {
    my ($r) = ($e =~ m@<key>Rating</key><integer>(\d+)@si);
    next unless (defined($r) &&
                 ($r >= $stars * 20 ||
                  ($e =~ m@<key>Has Video</key><true@si)));
    my ($a) = ($e =~ m@<key>Artist</key><string>([^<>]*)@si);
    next unless defined($a);
    $artists{simplify_artist($a)} = $a;
  }

  my $count = keys(%artists);
  print STDERR "$progname: $count artists of ${stars}+ stars\n" if ($verbose);
  return \%artists;
}


# Quotifies the text to make it safe for iCal/vCalendar
#
sub ical_quote($;$) {
  my ($text, $nowrap) = @_;
  $text =~ s/\s+$//gs;               # lose trailing newline.
  $text =~ s/([\"\\,;])/\\$1/gs;     # quote backslash, comma, semicolon.
  $text =~ s/\r\n/\n/gs;
  $text =~ s/\r/\n/gs;

  $text =~ s/\n/\\n\n /gs;           # quote newlines, and break at newlines.

  # combine multiple blank lines into one.
  $text =~ s/(\n *\n)( *\n)+/$1/gs;

  $text =~ s/\\n/\\n\n /gs
    unless $nowrap;

  return $text;
}


# Create an ICS entry of the given event.
#
my $ics_seq = 0;
sub make_ics($$$$$$$) {
  my ($band, $url, $url2, $loc, $start, $end, $desc) = @_;

  my ($csec, $cmin, $chour, $cdotm, $cmon, $cyear) = gmtime;
  $cmon++; $cyear += 1900;
  my $dtstamp = sprintf ("%04d%02d%02dT%02d%02d%02dZ",
                         $cyear, $cmon, $cdotm, $chour, $cmin, $csec);

  $desc = "$url2\n\n$desc" if $url2;

  my $ics = join ("\n",
                  ('BEGIN:VEVENT',
                   'UID:'		. ical_quote ($url),
                   'DTSTAMP:'		. ical_quote ($dtstamp),
                   'SEQUENCE:'		. $ics_seq++,
                   'LOCATION:'		. ical_quote ($loc, 1),
                   'SUMMARY:'		. ical_quote ($band),
                   'DTSTART;'		. $start,
                   'DTEND;'		. $end,
                   'URL:'		. ical_quote ($url),
                   'DESCRIPTION:'	. ical_quote ($desc),
                   'CLASS:PUBLIC',
                   'CATEGORIES:Performance',
                   'STATUS:CONFIRMED',
                   'BEGIN:VALARM',
                   'END:VALARM',
                   'END:VEVENT'));
  return $ics;
}


# Scrape each page on the SXSW web site and iterate the desired bands.
#
sub scrape_sxsw($) {
  my ($artists) = @_;

  my $base = $base_url;
  $base =~ s@\?.*$@@s;

  my $cyear = (localtime)[5];

  my @events = ();
  my %venues;

  foreach $a ('1', 'a' .. 'z') {
    my $url = "$base_url&a=$a";
    print STDERR "$progname: scraping: $url\n" if ($verbose);

    my $page;
    my $sec = 1;
    while (1) {
      $page = LWP::Simple::get ($url);
      last if (length ($page) > 200);
      print STDERR "$url: no data; retrying in $sec...\n";
      $sec = int(($sec + 2) * 1.3);
      sleep ($sec);
    }

    foreach (split (m/<div\b \s+ class=\"row/six, $page)) {
      my ($url2) = (m@<a\b [^<>]*? \b href=\" (event[^<>\"]+) @six);
      my ($band) = (m@<a\b.*?> \s* ([^<>]+?) \s* </a>@six);
      my ($loc)  = (m@<div [^<>]*? \b class=\"loc[^<>]*> \s* ([^<>]+) @six);
      my ($date) = (m@<div [^<>]*? \b class=\"date[^<>]*> \s* ([^<>]+) @six);

      next unless $url2;

      foreach ($url2, $band, $loc, $date) { $_ = clean($_); }
      $url2 = $base . $url2;

      error ("no title: $_") unless $band;
      #error ("no location: $_") unless $loc;
      if (! $loc) {
        print STDERR "$progname: $band: no location!\n";
        next;
      }

      #error ("no date: $_") unless $date;
      if (! $date) {
        print STDERR "$progname: $band: no date!\n";
        next;
      }

      my $band2 = simplify_artist ($band);
      if (! $artists->{$band2}) {
        print STDERR "$progname:   skipping \"$band\"\n" if ($verbose > 1);
        next unless $debug_p;
      }

      print STDERR "$progname:   scraping \"$band\": $url2\n" if ($verbose);


      $sec = 1;
      while (1) {
        $page = LWP::Simple::get ($url2);
        last if (length ($page) > 200);
        print STDERR "$url: no data; retrying in $sec...\n";
        $sec = int(($sec + 2) * 1.3);
        sleep ($sec);
      }

      my ($url3) = ($page =~ m@> \s* Online .*?
                               <A \s+ HREF=[\'\"]([^\'\"]+)@six);

      $page =~ s@^.*?<div \b \s+ id="main@@six;
      $page =~ s@^.*?<div \b \s+ class="block .*? > @@six;
      $page =~ s@\s* </div> .* $@@six;

      $page = '' if ($page =~ m@<h3@si);

      foreach ($url3, $page) { $_ = clean($_); }

      my ($day, $start, $end) =
       ($date =~ m/^(.*?)\s+(\d+:[^\s]+)[-\s]+(\d+:[^\s]+)\s*$/si);

#      error ("unparsable date: $date\n") unless $end;
      if (! $end) {
        print STDERR "$progname: $band: unparsable date: \"$date\"\n";
        next;
      }

      my (undef, $smm, $shh, $sdotm, $smon, $syear) = strptime ("$day, $start");
      my (undef, $emm, $ehh, $edotm, $emon, $eyear) = strptime ("$day, $end");

      $syear = $cyear unless $syear;
      $eyear = $cyear unless $eyear;
      $syear += 1900 if ($syear < 1900);
      $eyear += 1900 if ($eyear < 1900);
      $edotm++ if ($ehh < $shh);

      my $fmt = "TZID=%s:%04d%02d%02dT%02d%02d00";
      $start = sprintf ($fmt, $zone, $syear, $smon+1, $sdotm, $shh, $smm);
      $end   = sprintf ($fmt, $zone, $eyear, $emon+1, $edotm, $ehh, $emm);

      $venues{simplify_artist ($loc)} = $loc;

      push @events, make_ics ($band, $url2, $url3, $loc, $start, $end, $page);
    }
    last if ($debug_p > 1);
  }

  my @v = sort (values (%venues));
  return ( \@events, \@v);
}


# Update each ICS entry with other dates on which this band is playing,
# and scrape the addresses of the venues and update the events with those.
#
sub cross_reference($$) {
  my ($events, $venues) = @_;

  my %venues;
  foreach my $v (@$venues) {
    my $url = $base_url;
    $url =~ s/\?.*$//si;
    my $v2 = $v;
    $v2 =~ s/^The //si;
    $v2 =~ s/ /+/gs;
    $v2 =~ s/&/%26amp%3B/gs;
    $url .= "?venue=$v2";

    my $page;
    my $sec = 1;
    print STDERR "$progname: scraping venue \"$v\": $url\n" if ($verbose);
    while (1) {
      $page = LWP::Simple::get ($url);
      last if (length ($page) > 200);
      print STDERR "$url: no data; retrying in $sec...\n";
      $sec = int(($sec + 2) * 1.3);
      sleep ($sec);
    }
    
    $page =~ s/^.*?class=\"venue-details//si;
    my ($addr) = ($page =~ m@<h2>([^<>]+)@si);
    $addr = clean ($addr);
    if (! $addr) {
      print STDERR "$progname: no address for \"$v\"\n";
      next;
    }
    $venues{$v} = $addr;
  }

  my %dates;
  foreach my $e (@$events) {
    my ($name)  = ($e =~ m/^SUMMARY.*?:(.*)$/mi);
    my ($start) = ($e =~ m/^DTSTART.*?:(.*)$/mi);
    my $L = $dates{$name};
    my @L = $L ? @$L : ();
    push @L, $start;
    $dates{$name} = \@L;
  }

  foreach my $e (@$events) {
    my ($name) = ($e =~ m/^SUMMARY.*?:(.*)$/mi);
    my ($loc)  = ($e =~ m/^LOCATION.*?:(.*)$/mi);
    my @d;
    foreach my $d (sort @{$dates{$name}}) {
      my ($yyyy, $mon, $dotm, $hh, $mm) = 
        ($d =~ m@^(\d{4})(\d\d)(\d\d)T(\d\d)(\d\d)@si);
      error ("unparsable: $d") unless $yyyy;
      my $d2 = mktime (0, $mm, $hh, $dotm, $mon-1, $yyyy-1900, 0, 0, -1);
      $d2 = strftime ("%a at %I:%M %p", localtime ($d2));
      push @d, $d2;
    }

    # Update desc
    if (@d > 1) {
      my $d2 = ical_quote ("Multiple shows:\n\n" . join("\n", @d));
      $d2 .= "\\n\n \\n\n ";
      $e =~ s/^(DESCRIPTION.*?:)/$1$d2/mi;
    }

    # update loc
    my $addr = $venues{$loc};
    if ($addr) {
      my $loc2 = "$loc ($addr)";
      $e =~ s/^(LOC.*?:)[^\n]*/$1$loc2/mi;
    } else {
      print STDERR "$progname: no addr for venue: $loc\n";
    }
  }
}


# Fire, aim, ready.
#
sub scrape_all($) {
  my ($out) = @_;

  my $artists = load_bands();
  my ($events, $venues) = scrape_sxsw ($artists);
  cross_reference ($events, $venues);

#  if ($debug_p) {
#    print STDERR "$progname: not writing $out\n" if ($verbose);
#    return;
#  }

  print STDERR "$progname: writing $out\n" if ($verbose);
  open (my $of, '>', $out) || error ("$out: $!");
  my $c = join ("\n",
                  'BEGIN:VCALENDAR',
                  'VERSION:2.0',
                  'PRODID:-//Apple Inc.//iCal 5.0.1//EN',
                  'CALSCALE:GREGORIAN',
                  @$events,
                  'END:VCALENDAR') . "\n";
  $c =~ s/\n/\r\n/gs;
  print $of $c;
  close $of;
}


sub error($) {
  my ($err) = @_;
  print STDERR "$progname: $err\n";
  exit 1;
}

sub usage() {
  print STDERR "usage: $progname [--verbose] [--debug] outfile.ics\n";
  exit 1;
}

sub main() {
  my $out;
  while ($#ARGV >= 0) {
    $_ = shift @ARGV;
    if (m/^--?verbose$/s) { $verbose++; }
    elsif (m/^-v+$/s) { $verbose += length($_)-1; }
    elsif (m/^--?debug$/s) { $debug_p++; }
    elsif (m/^-./) { usage; }
    elsif (! $out) { $out = $_; }
    else { usage; }
  }
  usage unless $out;
  scrape_all ($out);
}

main();
exit 0;
