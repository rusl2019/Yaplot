#!/usr/bin/env perl
#$B;XDj$5$l$?(Blayer$B$@$1$rCj=P(B
#$B$?$@$7(Bglobal setting$B$JL?Na$ODL$9!#(B
#
#$BJ?@.(B15$BG/(B1$B7n(B27$BF|(B($B7n(B)global$BL?Na$N$&$A!"ITMW$J$b$N$O$G$-$k$@$1$J$/$9!#$=(B
#$B$N>l@_Dj%Q%l%C%H$b!";H$C$?$b$N$@$1$rDj5A$9$k!#(B
#

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
my $first=0;
while( $_=shift @ranges ){
    my $from=$_;
    my $to  =shift @ranges;
    for(my $i=$from;$i<=$to;$i++){
	$table[$i] = $i;
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
my $newlayer=$table[$layer];

my $currentRadius = 1.0;
my $currentPalette = 0;
my $radiusChanged = 1;
my $paletteChanged = 1;
my @palette;
while(<STDIN>){
    if(/^\s$/){
	#new page
	$layer=1;
	$newlayer=$table[$layer];
	print $_;
    }elsif(/^y\s/){
	@_ = split(/\s+/);
	$layer = $_[1];
	$newlayer=$table[$layer];
	if($newlayer){
	    print "y $newlayer\n";
	}
    }elsif(/^[\#r\@]/){
	#global in page
	#comment$B$^$?$O(Bset palette$B$J$i$=$N$^$^I=<((B
	my $asis=0;
	if(/^\#/){
	    $asis++;
	}
	if ( $asis ){
	    print $_;
	}else{
	    #
	    #$B$=$l0J30$O!"5-21$7$F$*$/!#(B
	    #
	    @_ = split( /\s+/, $_ );
	    if ( $_[0] eq '@' ){
		if ( $#_>1 ){
		    #
		    #palette$B$r(Bset$B$7$?>l9g$O$=$N$^$^5-21$9$k!#(B
		    #
		    $palette[$_[1]] = join(" ",$_[2],$_[3],$_[4]);
		}elsif ( $_[1] != $currentPalette ){
		    #
		    #palette$B$r@Z$j$+$($k>l9g$b$=$NHV9f$r5-21$9$k!#(B
		    #
		    $currentPalette = $_[1];
		    $paletteChanged = 1;
		}
	    }elsif ( $_[0] eq 'r' ){
		if ( $_[1] != $currentRadius ){
		    $currentRadius = $_[1];
		    $radiusChanged = 1;
		}
	    }
	} 
    }else{
	if( $newlayer ){
	    if( $radiusChanged ){
		print "r $currentRadius\n";
		$radiusChanged = 0;
	    }
	    if ( $palette[$currentPalette] ){
		print join(" ","@",$currentPalette,
			   $palette[$currentPalette])."\n";
		$palette[$currentPalette] = "";
	    }
	    if( $paletteChanged ){
		print "\@ $currentPalette\n";
		$paletteChanged = 0;
	    }
	    print $_;
	}
    }
}







my $current=0;
while(<STDIN>){
    my @el=split(/\s/,$_);
    if(/^\s*$/){
	#empty line
	$current=0;
	print $_;
	next;
    }elsif($el[0] eq "y"){
	$current=$el[1];
    }
    if($current==5 || $el[0] =~ /^[\#r@]$/){
	print $_;
    }
}
