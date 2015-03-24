use strict;

my $stable;

open F,"./AMSTracker -s -u0.01 |";
while(<F>) {
    my @a = /(-?\d+)/g;
    print, next if @a != 3;

    # we get a signed short written as two unsigned bytes
    $a[0] += 256 if $a[0] < 0;
##    my $x = $a[1]*256 + $a[0];
    my $x = $a[0];

    if(abs($x) < 20) { 
	$stable++; 
    } 

    if(abs($x) > 30 && $stable > 30) {
	$stable = 0;
	my $foo = $x < 0 ? 'Prev' : 'Next';
	system "./notify SwitchTo${foo}Workspace\n";
    }
}
