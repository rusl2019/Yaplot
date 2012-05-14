#!/usr/bin/env perl
#$B;XDj$5$l$?%l%$%d72$r!"$=$N:G=i$N%l%$%d$K=E$M$k!#(B
#$B;D$j$N%l%$%d$O(B-c$B$,;XDj$5$l$F$$$l$P5M$a$k!#(B
#y$B$N0z?t$rJQ99$9$k$N$_!#(Blayer 1$B$N07$$$KCm0U(B

#$BNc$($P!"(Bmergelayer.pl -c 3,5,7
#$B$r;XDj$9$k$H!"(B3$B!"(B5$B!"(B7$BHVL\$N(Blayer$B$O(B3$BHVL\$N%l%$%d$K=E$M$i$l!"$=$l0J30$N(B
#$B%l%$%d$O=g<!A0$K5M$a$k!#(B($BBh(B6$B%l%$%d$OBh(B4$B%l%$%d$K0\F0$9$k!#(B)


sub usage{
    print "usage: $* layers < file.yap\n";
    print "layers: 1,3,5-9,...\n";
    exit 1;
}

sub ParseRanges{
    #min,max$B$O>JN,;~$NHO0O(B
    my ($ranges,$min,$max) = @_;
    my @ranges;
    foreach my $range ( split(/,/,$ranges) ){
	my $lastto=$min-1;
	#$BHO0O;XDj$N>l9g(B
	if($range =~ /-/){
	    my ($a,$b)=split(/-/,$range);
	    if($a !~ /^[0-9]+$/){
		$a=$min;
	    }
	    if($b !~ /^[0-9]+$/){
		$b=$max;
	    }
	    usage if $b<$a;
	    usage if $lastto>$a;
	    $lastto=$b;
	    push(@ranges,$a,$b);
	}else{
	    $lastto=$range;
	    push(@ranges,$range,$range);
	}
    }
    @ranges;
}

my $compress=0;
if ( $ARGV[0] eq '-c' ){
    $compress++;
    shift;
}
usage if ($#ARGV != 0);
my @ranges = ParseRanges( shift(),1,20 );

#make conversion table
my @table;
for(my $i=1;$i<=20;$i++){
    $table[$i] = $i;
}
my $first=0;
while( $_=shift @ranges ){
    my $from=$_;
    if ( $first == 0 ){
	$first = $from;
    }
    my $to  =shift @ranges;
    for(my $i=$from;$i<=$to;$i++){
	$table[$i] = $first;
    }
}
if( $compress ){
    #$B6u$-%l%$%d$r5M$a$k!#(B
    my $i=$first+1;
    for( my $j = $i; $j<=20; $j ++ ){
	next if $table[$j] == $first;
	$table[$j] = $i;
	$i ++;
    }
}

my $layer=1;
while(<STDIN>){
    if(/^\s$/){
	#new page
	$layer=1;
	print $_;
	if ( $table[$layer] != 1 ){
	    #$B$b$7:G=i$N%l%$%d$,<M1F$5$l$F$$$l$P(B
	    #$B$3$s$J$3$H$O$*$-$J$$$O$:$@$,(B
	    print "y ".$table[$layer]."\n";
	}
    }elsif(/^y\s/){
	split(/\s+/);
	$layer = $_[1];
	print "y ".$table[$layer]."\n";
    }else{
	print $_;
    }
}
