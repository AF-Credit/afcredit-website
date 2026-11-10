use strict; use warnings;
my ($file,$new)=@ARGV; open my $h,'<:raw',$file or die; my @l=<$h>; close $h; open my $s,'<:raw',$new or die; local $/; my $n=<$s>; close $s;
my ($a,$b); for my $i (0..$#l){ $a=$i if !defined $a && $l[$i]=~/<!-- Illustrated street/; if(defined $a && !defined $b && $i>$a && $l[$i]=~/^<\/section>/){ $b=$i-1; last; } }
die "markers" unless defined $a && defined $b; splice(@l,$a,$b-$a+1,$n); open my $o,'>:raw',$file or die; print $o @l; close $o; print "spliced lines $a..$b\n";
