#!/usr/bin/env perl
#$B$=$N>l@_Dj(Bpalette$B$O!"=P$F$-$?=g$K?7HV9f$rM?$($l$P$h$$!#(B32$BHV0J9_$r;HMQ$9$k$3$H$K$9$k!#(B
#$B%Q%l%C%HHV9f$N$=$N>l;XDj$O(Bglobal$B$G$"$k!#$D$^$j!":G=i$K0lEY@_Dj$9$l$P!"JQ99$5$l$J$$8B$j;}B3$9$k!#$3$N$?$a!"3F%U%!%$%k$K$*$1$k%Q%l%C%H0\$7BX$(I=$rJL8D$K=`Hw$7$J$1$l$P$J$i$J$$!#(B
use strict;
use FileHandle;

sub usage{
    print STDERR "usage: yapmerge 1.yap nlayer1 2.yap\n";
    print STDERR "nlayer1: Specify number of layers in 1.yap in decimal number\n";
    exit(1);
}

my $nf=0;
my @files;
my @offsets;
while(1){
    $files[$nf]=new FileHandle;
    open $files[$nf],$ARGV[0];
    shift;
    #open($files[$nf],shift)||usage;
    $nf ++;
    last if $#ARGV<0;
    $offsets[$nf]=shift()+$offsets[$nf-1];
}

my $palette=32;
my $last=0;
my @userpalette;
for(my $i=0;$i<$nf;$i++){
    $userpalette[$i][0];
}
my $frames=0;
while(1){
    $last=0;
    for(my $i=0;$i<$nf;$i++){
	$last += getput($files[$i],$offsets[$i],$userpalette[$i]);
    }
    print STDERR "[$frames]";
    $frames++;
    last if $last;
    print "\n";
}

sub getput{
    my ($files,$offsets,$table)=@_;
    my $init = 1;
    while(<$files>){
	return 0 if( /^\s*$/ );
	if ( $init ){
	      #$B$b$7%f!<%6$,FH<+?'$r3d$j$"$F$?$i!"JLHV9f$K3d$j$U$k!#(B
	  print "y ", $offsets+1, "\n";
	  $init = 0;
	}
	chomp;
	split;
	if($_[0] =~ /^y/){
	    print "y ";
	    print $_[1]+$offsets,"\n";
	}elsif($_[0] =~ /^\@/ ){
	    my @cmd = split(/\s+/);
	    my $pal = $cmd[1];
	    if ( $#cmd == 4 ){
		$cmd[1] = $table->[$pal] = $palette++;
	    }elsif( $table->[$pal] ){
		$cmd[1] = $table->[$pal];
	    }
	    print join(" ",@cmd,"\n" );
	}else{
	    print $_,"\n";
	}
    }
    #end of file is detected
    return 1;
}

0;
