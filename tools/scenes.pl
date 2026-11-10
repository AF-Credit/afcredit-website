use strict; use warnings;
$main::NO_RUN = 1;
my $dir = $ARGV[0];
do "$dir/iso.pl"; die $@ if $@;
sub scene { my ($cls,$body)=@_; @main::pts=(); my $inner=$body->(); my $vb=main::frame($inner); return qq{<svg class="ill $cls" viewBox="$vb" aria-hidden="true">\n$inner</svg>}; }
my %C=%main::C;
my $inv = scene('ill-investor', sub { my $s='';
  $s.=main::tree(-12,'tall',12,$C{coral}); $s.=main::tree(100,'round',11,$C{sky2});
  $s.=main::rect(10,-56,76,56,$C{white}); $s.=main::chimney(62,-68,8,14,$C{blue}); $s.=main::gable(10,76,-56,28,6,$C{blue});
  $s.=main::window(18,-44,16,14); $s.=main::window(62,-44,16,14); $s.=main::door(39,0,18,30,$C{coral}, panes=>1);
  $s.=main::rect(10,-9,29,9,$C{sky},' nostroke'); $s.=main::rect(57,-9,29,9,$C{sky},' nostroke');
  $s.=main::line(' stroke-width="1.6"',main::pt(-24,0),main::pt(112,0));
  $s.=main::person(110,0, top=>$C{coral}, hairstyle=>'bun', hair=>'#5a3a2a', prop=>'keys', delay=>0.2);
  $s; });
my $brk = scene('ill-broker', sub { my $s='';
  $s.=main::rect(10,-84,80,84,$C{blue}); $s.=main::rect(6,-88,88,5,$C{white});
  for my $r (0..2){ my $y=-76+$r*22; for my $c (0..2){ my $x=18+$c*22; next if $r==2 && $c==1; $s.=main::window($x,$y,14,14,fill=>$C{sky}); } }
  $s.=main::door(36,0,28,22,$C{sky}, panes=>0); $s.=main::line(' stroke-width="1.6"',main::pt(50,-22),main::pt(50,0));
  $s.=main::line(' stroke-width="1.6"',main::pt(-8,0),main::pt(124,0));
  $s.=main::person(110,0, top=>$main::INK, hairstyle=>'short', prop=>'case', delay=>0.5);
  $s; });
my $nov = scene('ill-noval', sub { my $s='';
  $s.=main::tree(-10,'round',12,$C{teal2});
  $s.=main::rect(10,-54,90,54,$C{white}); $s.=main::chimney(72,-68,9,16,$C{teal}); $s.=main::gable(10,90,-54,30,6,$C{teal});
  $s.=main::window(20,-42,20,16); $s.=main::window(70,-42,20,16); $s.=main::door(46,0,18,30,$C{coral}, panes=>1);
  $s.=main::rect(10,-10,36,10,$C{sky},' nostroke'); $s.=main::rect(64,-10,36,10,$C{sky},' nostroke');
  $s.=main::badge(108,-62,22,'NO SITE','VISIT');
  $s.=main::line(' stroke-width="1.6"',main::pt(-24,0),main::pt(150,0));
  $s.=main::person(134,0, top=>$C{sky2}, hairstyle=>'short', hair=>'#b9865a', prop=>'phone', delay=>0.3);
  $s; });
for my $pair (['inv.svg',$inv],['brk.svg',$brk],['nov.svg',$nov]) { open my $o,'>:raw',"$dir/$pair->[0]" or die; print $o $pair->[1]; close $o; }
print "scenes written\n";
