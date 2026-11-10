use strict; use warnings;
$main::NO_RUN = 1;
my $dir = $ARGV[0];
do "$dir/iso.pl"; die $@ if $@;
sub scene { my ($cls,$body)=@_; @main::pts=(); my $inner=$body->(); my ($x0,$y0,$x1,$y1)=(1e9,1e9,-1e9,-1e9); for (@main::pts){ $x0=$_->[0] if $_->[0]<$x0; $x1=$_->[0] if $_->[0]>$x1; $y0=$_->[1] if $_->[1]<$y0; $y1=$_->[1] if $_->[1]>$y1; } my $pad=6; my $vb=sprintf("%.0f %.0f %.0f %.0f",$x0-$pad,$y0-$pad,($x1-$x0)+2*$pad,($y1-$y0)+2*$pad); return qq{<svg class="ill $cls" viewBox="$vb" aria-hidden="true">\n$inner</svg>}; }

# investor door: family house with trees
my $inv = scene('ill-investor', sub { my $s='';
  $s.=main::plinth(-12,82,-12,62,8);
  $s.=main::box(0,70,0,50,0,8,'brick'); $s.=main::box(0,70,0,50,8,42,'yellow');
  $s.=main::winR(70,8,22,16,34); $s.=main::winR(70,30,44,16,34);
  $s.=main::winL(50,6,20,18,36); $s.=main::doorL(50,30,42,28,'#ff6a6b'); $s.=main::winL(50,52,64,18,36);
  $s.=main::roof(0,70,0,50,42,26,5,'red','yellow'); $s.=main::chimney(48,56,8,16,42,60);
  $s.=main::tree(-3,56,7); $s.=main::tree(76,58,7);
  $s; });

# broker door: office with a coral briefcase on the plot
my $brk = scene('ill-broker', sub { my $s='';
  $s.=main::plinth(-12,92,-12,66,8);
  $s.=main::box(0,66,0,54,0,70,'glass');
  for my $row (0..2){ my $h0=8+$row*21; for my $c (0..2){ my $v0=5+$c*16; $s.=main::winR(66,$v0,$v0+11,$h0,$h0+14); } }
  for my $row (0..2){ my $h0=8+$row*21; for my $c (0..3){ my $u0=4+$c*16; next if $row==0 && ($c==1||$c==2); $s.=main::winL(54,$u0,$u0+11,$h0,$h0+14); } }
  $s.=main::doorL(54,20,46,22,'#1b2b3b');
  $s.=main::flatroof(0,66,0,54,70,'white'); $s.=main::box(6,18,6,16,74,80,'grey');
  # briefcase: coral iso box with handle, sitting on the plot in front
  $s.=main::box(70,92,40,66,0,16,'coral') ;
  $s.=main::poly('#1b2b3b','',main::P(78,66.6,16),main::P(84,66.6,16),main::P(84,66.6,21),main::P(78,66.6,21));
  $s.=main::poly('#fff',' opacity=".5"',main::P(70,66.6,8),main::P(92,66.6,8),main::P(92,66.6,9.5),main::P(70,66.6,9.5));
  $s; });

# no-valuation band: house with floating NO SITE VISIT badge and a tablet showing the value
my $nov = scene('ill-noval', sub { my $s='';
  $s.=main::plinth(-14,96,-14,70,9);
  $s.=main::box(0,76,0,56,0,46,'cream');
  $s.=main::winR(76,8,24,16,36); $s.=main::winR(76,34,50,16,36);
  $s.=main::winL(56,6,22,18,38); $s.=main::doorL(56,32,46,30,'#ff6a6b'); $s.=main::winL(56,56,70,18,38);
  $s.=main::roof(0,76,0,56,46,28,6,'tealr','cream'); $s.=main::chimney(52,62,8,18,48,68);
  $s.=main::tree(-4,64,8);
  # tablet on the plot: thin iso slab with a screen showing a tick and value bar
  $s.=main::box(80,104,20,56,0,3,'navy');
  $s.=main::poly('#eaf7ff','',main::P(82,22,3.2),main::P(102,22,3.2),main::P(102,54,3.2),main::P(82,54,3.2));
  $s.=main::poly('#3f9583','',main::P(86,26,3.4),main::P(98,26,3.4),main::P(98,32,3.4),main::P(86,32,3.4));
  $s.=main::poly('#c9dff0','',main::P(86,36,3.4),main::P(98,36,3.4),main::P(98,40,3.4),main::P(86,40,3.4));
  $s.=main::poly('#c9dff0','',main::P(86,44,3.4),main::P(94,44,3.4),main::P(94,48,3.4),main::P(86,48,3.4));
  my ($bx,$by)=((76-6)*0.866+18,(76+6)*0.5-78);
  $s.=qq{<g transform="translate($bx $by)"><circle r="22" fill="#fff"/><circle cy="-7" r="8" fill="#3f9583"/><path d="M-4 -7l3 3 5-5" stroke="#fff" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/><text y="8" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="6.5" fill="#1b2b3b">NO SITE</text><text y="16" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="6.5" fill="#1b2b3b">VISIT</text></g>\n};
  push @main::pts,[$bx-22,$by-22],[$bx+22,$by+22];
  $s; });

for my $pair (['inv.svg',$inv],['brk.svg',$brk],['nov.svg',$nov]) { open my $o,'>:raw',"$dir/$pair->[0]" or die; print $o $pair->[1]; close $o; }
print "scenes written\n";
