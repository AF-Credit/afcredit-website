use strict; use warnings;
$main::NO_RUN = 1;
my $dir = $ARGV[0];
do "$dir/iso.pl"; die $@ if $@;
sub scene { my ($cls,$body)=@_; @main::pts=(); my $inner=$body->(); my ($x0,$y0,$x1,$y1)=(1e9,1e9,-1e9,-1e9); for (@main::pts){ $x0=$_->[0] if $_->[0]<$x0; $x1=$_->[0] if $_->[0]>$x1; $y0=$_->[1] if $_->[1]<$y0; $y1=$_->[1] if $_->[1]>$y1; } my $pad=6; my $vb=sprintf("%.0f %.0f %.0f %.0f",$x0-$pad,$y0-$pad,($x1-$x0)+2*$pad,($y1-$y0)+2*$pad); return qq{<svg class="ill $cls" viewBox="$vb" aria-hidden="true">\n$inner</svg>}; }

my $inv = scene('ill-investor', sub { my $s='';
  $s.=main::plinth(-14,96,-18,60,8);
  $s.=main::brickband(0,80,0,50,8); $s.=main::wall(0,80,0,50,8,40,'yellow');
  $s.=main::roof(0,80,0,50,40,26,5,'red','yellow'); $s.=main::chimney(58,66,28,36,40,58); $s.=main::smoke(62,32,60);
  $s.=main::winF(0,8,26,16,34, curtain=>'#c9bdf0', flowers=>1); $s.=main::winF(0,54,72,16,34, curtain=>'#c9bdf0'); $s.=main::doorF(0,34,48,28,'#ff6a6b','orange', mat=>1);
  $s.=main::winS(80,10,24,16,34);
  $s.=main::tree(-6,-8,7);
  $s.=main::person(90,-14, top=>'#6f8df4', legs=>'#2b3147', hairstyle=>'bun', hair=>'#5a3a2a', prop=>'keys', delay=>0.2);
  $s; });

my $brk = scene('ill-broker', sub { my $s='';
  $s.=main::plinth(-14,104,-18,60,8);
  $s.=main::wall(0,74,0,50,0,70,'peri');
  for my $row (0..2){ my $h0=8+$row*21; for my $c (0..3){ my $u0=4+$c*18; next if $row==0 && ($c==1||$c==2); $s.=main::winF(0,$u0,$u0+12,$h0,$h0+14, lamp=>(($row+$c)%2==0)); } }
  for my $row (0..2){ my $h0=8+$row*21; for my $c (0..2){ my $v0=5+$c*15; $s.=main::winS(74,$v0,$v0+10,$h0,$h0+14); } }
  $s.=main::doorF(0,24,50,22,'#2b3147','orange', glass=>1);
  $s.=main::flatroof(0,74,0,50,70,'white'); $s.=main::box(6,18,30,40,74,80,'grey');
  $s.=main::person(92,-14, top=>'#2b3147', legs=>'#2b3147', hairstyle=>'short', prop=>'case', delay=>0.5);
  $s; });

my $nov = scene('ill-noval', sub { my $s='';
  $s.=main::plinth(-16,118,-20,60,9);
  $s.=main::brickband(0,84,0,52,7); $s.=main::wall(0,84,0,52,7,44,'cream');
  $s.=main::roof(0,84,0,52,44,28,6,'tealr','cream'); $s.=main::chimney(60,70,28,38,46,66); $s.=main::smoke(65,33,68);
  $s.=main::winF(0,8,28,16,36, curtain=>'#f7c84a', flowers=>1); $s.=main::winF(0,58,78,16,36, curtain=>'#f7c84a', lamp=>1); $s.=main::doorF(0,36,50,30,'#ff6a6b','orange', mat=>1, number=>'9');
  $s.=main::winS(84,10,26,16,36);
  $s.=main::tree(-6,-8,8);
  $s.=main::person(100,-16, top=>'#c9bdf0', legs=>'#2b3147', hairstyle=>'curly', hair=>'#b9865a', prop=>'phone', delay=>0.3);
  my ($bx,$by)=main::XY(92,0,80);
  $s.=qq{<g transform="translate($bx $by)"><circle r="22" fill="#fff" stroke="$main::INK" stroke-width="1.3"/><circle cy="-7" r="8" fill="#5fbcae" stroke="$main::INK" stroke-width="1"/><path d="M-4 -7l3 3 5-5" stroke="#fff" stroke-width="2.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/><text y="8" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="6.5" fill="$main::INK">NO SITE</text><text y="16" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="6.5" fill="$main::INK">VISIT</text></g>\n};
  push @main::pts,[$bx-22,$by-22],[$bx+22,$by+22];
  $s; });

for my $pair (['inv.svg',$inv],['brk.svg',$brk],['nov.svg',$nov]) { open my $o,'>:raw',"$dir/$pair->[0]" or die; print $o $pair->[1]; close $o; }
print "scenes written\n";
