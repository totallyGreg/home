#!/usr/bin/perl -w

use strict;
use POSIX "isatty";

# The hash of zones. Contains the zones from /var/named/etc/namedb/include/sago and those
# inputted by the user.
my %zones;
# The list of zones to add. We do this to preserve the ordering given
# by the user.
my @new_zones;

# Scans /var/named/etc/namedb/include/sago and loads %zones with the existing zones.
sub scan
{
	local *CONF;

	open(CONF, "</var/named/etc/namedb/include/sago") or die "$!";

	# Search for lines matching: ^zone "foo.com"
	while (<CONF>)
	{
		if (/^zone "([^"]+)" /)
		{
			$zones{$1} = -1;
		}
	}
	close(CONF);
}

# Reads input from the user, and loads @new_zones with the new zones.
sub readinput
{
	while (<>)
	{
		chomp;

		# Update %zones.
		$zones{$_} = 0 if not defined $zones{$_};
		$zones{$_}++ if $zones{$_} >= 0;

		# Update @new_zones.
		push @new_zones, $_;
	}
}

# Checks for duplicates.
sub checkdups
{
	my $errors = 0;

	# Check for duplicate entries.
	foreach (@new_zones)
	{
		# Entry from /var/named/etc/namedb/include/sago
		if ($zones{$_} == -1)
		{
			print STDERR "Error: Zone \"$_\" is a duplicate of ",
				"an entry from /var/named/etc/namedb/include/sago.\n";
			++$errors;
		}
		# Duplicate entry from the user.
		elsif ($zones{$_} > 1)
		{
			print STDERR "Error: Zone \"$_\" is a duplicate of ",
				"an entry specified by the user.\n";

			# Mark this entry so we don't output duplicate
			# messages.
			$zones{$_} = -2;
			++$errors;
		}
	}

	# Abort on errors
	exit 1 if $errors;
}

# Commits the new zones.
sub commit
{
	local *CONF;
	local *FH;

	open CONF, ">>/var/named/etc/namedb/include/sago" or die "$!";
	open CONF2, ">>/var/named/etc/namedb/slave/sago" or die "$!";

	foreach (@new_zones)
	{
		my $domain;
		my $tld;
		my $time = time();

		if (/^([^.]+)[.](.*)$/)
		{
			$domain = $1;
			$tld = $2;
		}

		open FH, ">/var/named/etc/namedb/master/sago/named.$_" or die "$!";
		print CONF <<"EOF";
zone "$_" {
	type master;
	file "master/sago/named.$_";
};

EOF
                print CONF2 <<"EOF";
zone "$_" {
	type slave;
	file "slave/sago/named.$_";
	masters { 172.16.31.20; };
};
EOF

		print FH <<"EOF";
\$TTL 3600
\$ORIGIN $tld.
$domain		IN SOA ns0.sagonet.com. dns.sagonet.com. (
		$time	; Serial
		3600		; Refresh
		1800		; Retry
		604800		; Expiry
		3600 )		; TTL

		NS	ns1.sagonet.com.
		NS	ns2.sagonet.com.
		A	66.118.130.2
		MX	10	mail.$_.

\$ORIGIN $_.

www		CNAME	$_.
mail		A	66.118.130.2

EOF
	close FH;
	}
	close CONF;
	
}

scan;
readinput;
checkdups;
commit;

