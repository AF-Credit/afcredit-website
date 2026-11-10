use strict; use warnings;
# Isometric "3D model" street generator for af.credit homepage.
# iso(u,v,h): u runs right-down, v runs left-down, h up.
my ($C,$S) = (0.866, 0.5);
our @pts; # for bbox
sub P { my ($u,$v,$h)=@_; my $x=($u-$v)*$C; my $y=($u+$v)*$S-$h; push @pts,[$x,$y]; return sprintf("%.1f,%.1f",$x,$y); }
sub poly { my ($fill,$extra,@p)=@_; $extra//=''; return qq{<polygon points="}.join(' ',@p).qq{" fill="$fill"$extra/>\n}; }
# materials: [top, right(lit), left(shade)]
my %M = (
  yellow=>['#ffe68a','#fbd04f','#e2ad2b'], blue=>['#9ad6ff','#47a9f1','#2a7cc2'], cream=>['#fffaf0','#f7eedb','#dccaa9'],
  sage=>['#dcf0cf','#aed79f','#7fb272'], slate=>['#e6edf6','#c9d7e7','#97adc7'], brick=>['#f6bfa3','#e6967a','#bf6c54'],
  teal=>['#b2e6da','#67c1ae','#3f9583'], glass=>['#d7efff','#86c6f3','#4f96c9'], navy=>['#4a5f78','#2f4458','#1b2b3b'],
  white=>['#ffffff','#f4f6f9','#d9e0e8'], green=>['#8fe06a','#67c84a','#4aa636'], yellowk=>['#ffd96a','#f4bf3a','#cf9a1f'],
  grey=>['#d9dee5','#b9c2cd','#8e9aa8'], coral=>['#ff9a94','#ff6a6b','#d64c4e'],
);
my %ROOF = ( red=>['#ef5b70','#c1324a'], orange=>['#f6953f','#cf6f22'], tealr=>['#58b7a8','#397f73'], slater=>['#7a8ea8','#55667c'], brown=>['#b2774e','#7e5032'], plum=>['#c0567a','#8e3a58'] );

sub box { my ($u0,$u1,$v0,$v1,$h0,$h1,$m)=@_; my ($t,$r,$l)=@{$M{$m}}; my $s='';
  $s.=poly($t,'',P($u0,$v0,$h1),P($u1,$v0,$h1),P($u1,$v1,$h1),P($u0,$v1,$h1));
  $s.=poly($r,'',P($u1,$v0,$h0),P($u1,$v1,$h0),P($u1,$v1,$h1),P($u1,$v0,$h1));
  $s.=poly($l,'',P($u0,$v1,$h0),P($u1,$v1,$h0),P($u1,$v1,$h1),P($u0,$v1,$h1));
  return $s; }
sub plinth { my ($u0,$u1,$v0,$v1,$th)=@_; my $s=''; my $cx=(($u0+$u1)/2-($v0+$v1)/2)*$C; my $cy=(($u0+$u1)/2+($v0+$v1)/2)*$S+$th+4; $s.=qq{<ellipse cx="$cx" cy="$cy" rx="}.(($u1-$u0+$v1-$v0)*0.5).qq{" ry="12" fill="url(#g-shadow)"/>\n}; $s.=box($u0,$u1,$v0,$v1,-$th,0,'green'); return $s; }
# gable roof, ridge along u; eave at h, rise R, overhang o, wall material m for gable
sub roof { my ($u0,$u1,$v0,$v1,$h,$R,$o,$col,$m)=@_; my ($f,$b)=@{$ROOF{$col}}; my $vm=($v0+$v1)/2; my $s='';
  # back slope (mostly hidden) then gable end (wall colour) then front slope, fascia, gloss
  $s.=poly($b,'',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  $s.=poly($M{$m}[1],'',P($u1,$v0,$h-1),P($u1,$v1,$h-1),P($u1,$vm,$h+$R-1));
  $s.=poly($f,'',P($u0-$o,$v1+$o,$h),P($u1+$o,$v1+$o,$h),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  $s.=poly('#fff',' opacity=".28"',P($u0-$o,$vm+($v1+$o-$vm)*0.45,$h+$R*0.55),P($u1+$o,$vm+($v1+$o-$vm)*0.45,$h+$R*0.55),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  $s.=poly('#ffffff','',P($u0-$o,$v1+$o,$h),P($u1+$o,$v1+$o,$h),P($u1+$o,$v1+$o,$h-3),P($u0-$o,$v1+$o,$h-3));
  $s.=poly('#e9eef3','',P($u1+$o,$v1+$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3),P($u1+$o,$v1+$o,$h-3));
  return $s; }
sub flatroof { my ($u0,$u1,$v0,$v1,$h,$m)=@_; return box($u0-3,$u1+3,$v0-3,$v1+3,$h,$h+4,$m); }
# window on right face (u=const), spans v0..v1, h0..h1
sub winR { my ($u,$v0,$v1,$h0,$h1)=@_; my $s=''; $s.=poly('#ffffff','',P($u+0.5,$v0,$h0),P($u+0.5,$v1,$h0),P($u+0.5,$v1,$h1),P($u+0.5,$v0,$h1)); my $i=2; $s.=poly('url(#g-glassR)','',P($u+1,$v0+$i,$h0+$i),P($u+1,$v1-$i,$h0+$i),P($u+1,$v1-$i,$h1-$i),P($u+1,$v0+$i,$h1-$i)); my $vm=($v0+$v1)/2; my $hm=($h0+$h1)/2; $s.=qq{<path d="M}.P($u+1.2,$vm,$h0+$i).' L'.P($u+1.2,$vm,$h1-$i).' M'.P($u+1.2,$v0+$i,$hm).' L'.P($u+1.2,$v1-$i,$hm).qq{" stroke="#fff" stroke-width="1.4"/>\n}; return $s; }
sub winL { my ($v,$u0,$u1,$h0,$h1)=@_; my $s=''; $s.=poly('#ffffff','',P($u0,$v+0.5,$h0),P($u1,$v+0.5,$h0),P($u1,$v+0.5,$h1),P($u0,$v+0.5,$h1)); my $i=2; $s.=poly('url(#g-glassL)','',P($u0+$i,$v+1,$h0+$i),P($u1-$i,$v+1,$h0+$i),P($u1-$i,$v+1,$h1-$i),P($u0+$i,$v+1,$h1-$i)); my $um=($u0+$u1)/2; my $hm=($h0+$h1)/2; $s.=qq{<path d="M}.P($um,$v+1.2,$h0+$i).' L'.P($um,$v+1.2,$h1-$i).' M'.P($u0+$i,$v+1.2,$hm).' L'.P($u1-$i,$v+1.2,$hm).qq{" stroke="#fff" stroke-width="1.4"/>\n}; return $s; }
sub doorL { my ($v,$u0,$u1,$h1,$fill)=@_; $fill//='#ff6a6b'; my $s=poly('#ffffff','',P($u0-1.5,$v+0.5,0),P($u1+1.5,$v+0.5,0),P($u1+1.5,$v+0.5,$h1+1.5),P($u0-1.5,$v+0.5,$h1+1.5)); $s.=poly($fill,'',P($u0,$v+1,0),P($u1,$v+1,0),P($u1,$v+1,$h1),P($u0,$v+1,$h1)); $s.=qq{<circle cx="}.(($u1-1-$v-1)*$C).qq{" cy="}.(($u1-1+$v+1)*$S-$h1*0.5).qq{" r="1.3" fill="#fff"/>\n}; return $s; }
sub doorR { my ($u,$v0,$v1,$h1,$fill)=@_; $fill//='#ff6a6b'; my $s=poly('#ffffff','',P($u+0.5,$v0-1.5,0),P($u+0.5,$v1+1.5,0),P($u+0.5,$v1+1.5,$h1+1.5),P($u+0.5,$v0-1.5,$h1+1.5)); $s.=poly($fill,'',P($u+1,$v0,0),P($u+1,$v1,0),P($u+1,$v1,$h1),P($u+1,$v0,$h1)); return $s; }
sub tree { my ($u,$v,$sz)=@_; my $x=($u-$v)*$C; my $y=($u+$v)*$S; push @pts,[$x-$sz*0.5,$y-$sz*2.2],[$x+$sz*0.5,$y+4]; my $s=qq{<ellipse cx="$x" cy="$y" rx="}.($sz*0.55).qq{" ry="}.($sz*0.22).qq{" fill="#1b2b3b" opacity=".12"/>\n}; $s.=qq{<path d="M$x }.($y-$sz*2.2).qq{ L}.($x+$sz*0.5).qq{ }.($y-$sz*0.3).qq{ Q$x }.($y-$sz*0.1).qq{ }.($x-$sz*0.5).qq{ }.($y-$sz*0.3).qq{Z" fill="url(#g-tree)"/>\n}; $s.=qq{<path d="M$x }.($y-$sz*2.2).qq{ L}.($x+$sz*0.5).qq{ }.($y-$sz*0.3).qq{ Q$x }.($y-$sz*0.1).qq{ }.($x-$sz*0.5).qq{ }.($y-$sz*0.3).qq{Z" fill="url(#g-tree)"/>\n}; $s.=qq{<rect x="}.($x-$sz*0.18).qq{" y="}.($y-$sz*0.25).qq{" width="}.($sz*0.36).qq{" height="}.($sz*0.3).qq{" rx="1.5" fill="#d86a3a"/>\n}; return $s; }
sub chimney { my ($u0,$u1,$v0,$v1,$h0,$h1)=@_; return box($u0,$u1,$v0,$v1,$h0,$h1,'white').box($u0-1,$u1+1,$v0-1,$v1+1,$h1,$h1+2.5,'grey'); }
# text on left face (plane v=const): reads along +u
sub textL { my ($u,$v,$h,$txt,$size,$fill)=@_; my ($x,$y)=(($u-$v)*$C,($u+$v)*$S-$h); return qq{<text transform="matrix(0.866,0.5,0,1,$x,$y)" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="$size" fill="$fill" letter-spacing=".06em">$txt</text>\n}; }
sub textR { my ($u,$v,$h,$txt,$size,$fill)=@_; my ($x,$y)=(($u-$v)*$C,($u+$v)*$S-$h); return qq{<text transform="matrix(0.866,-0.5,0,1,$x,$y)" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="$size" fill="$fill" letter-spacing=".06em">$txt</text>\n}; }
# signboard standing on the plinth, facing left-front (plane v=const)
sub signL { my ($u0,$u1,$v,$h0,$h1,$fill,$txt,$size)=@_; my $s=box($u0-2,$u0,$v-2,$v,0,$h0+2,'grey'); $s.=box($u0,$u1,$v-1.5,$v,$h0,$h1,'white'); $s.=poly($fill,'',P($u0+1.5,$v+0.3,$h0+1.5),P($u1-1.5,$v+0.3,$h0+1.5),P($u1-1.5,$v+0.3,$h1-1.5),P($u0+1.5,$v+0.3,$h1-1.5)); $s.=textL($u0+4,$v+0.6,$h0+($h1-$h0)/2-3.2,$txt,$size,'#fff'); return $s; }

sub building { my ($id,$href,$label,$body)=@_; @pts=(); my $inner=$body->(); my ($x0,$y0,$x1,$y1)=(1e9,1e9,-1e9,-1e9); for (@pts){ $x0=$_->[0] if $_->[0]<$x0; $x1=$_->[0] if $_->[0]>$x1; $y0=$_->[1] if $_->[1]<$y0; $y1=$_->[1] if $_->[1]>$y1; }
  my $pad=6; my $vb=sprintf("%.0f %.0f %.0f %.0f",$x0-$pad,$y0-$pad,($x1-$x0)+2*$pad,($y1-$y0)+2*$pad);
  return qq{      <a class="plot" role="listitem" href="$href" data-p="$id" aria-label="$label bridging loans">\n        <svg class="plot-ill" viewBox="$vb" aria-hidden="true">\n$inner        </svg>\n        <span class="plot-btn">$label <span class="arr">&rarr;</span></span>\n      </a>\n\n}; }

unless ($main::NO_RUN) {
my $out = '';
$out .= qq{  <!-- Illustrated street: one isometric building per product, every building is a link -->
  <div class="hm-street">
    <svg width="0" height="0" style="position:absolute" aria-hidden="true" focusable="false"><defs>
      <linearGradient id="g-glassR" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#eaf7ff"/><stop offset="1" stop-color="#8fc9f0"/></linearGradient>
      <linearGradient id="g-glassL" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#cfe6f7"/><stop offset="1" stop-color="#6aaedd"/></linearGradient>
      <linearGradient id="g-tree" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#9be36e"/><stop offset="1" stop-color="#3f9a34"/></linearGradient>
      <radialGradient id="g-shadow"><stop offset="0" stop-color="#1b2b3b" stop-opacity=".22"/><stop offset="1" stop-color="#1b2b3b" stop-opacity="0"/></radialGradient>
    </defs></svg>

    <div class="street-sky" aria-hidden="true">
      <svg class="cloud cloud-1" viewBox="0 0 120 50"><path d="M18 40c-10-22 22-36 36-20 10-18 44-14 46 8 20-4 30 20 10 26H30c-16 0-20-8-12-14z" fill="#fff"/></svg>
      <svg class="cloud cloud-2" viewBox="0 0 120 50"><path d="M18 40c-10-22 22-36 36-20 10-18 44-14 46 8 20-4 30 20 10 26H30c-16 0-20-8-12-14z" fill="#fff"/></svg>
      <svg class="cloud cloud-3" viewBox="0 0 120 50"><path d="M18 40c-10-22 22-36 36-20 10-18 44-14 46 8 20-4 30 20 10 26H30c-16 0-20-8-12-14z" fill="#fff"/></svg>
    </div>

    <div class="plots" role="list" aria-label="What we lend on">

};

# 1 Residential: two-tone family house, red roof, trees
$out .= building('res','/products/residential-bridging-loans','Residential', sub { my $s='';
  $s.=plinth(-14,94,-14,76,9);
  $s.=box(0,80,0,62,0,10,'brick');            # brick base band
  $s.=box(0,80,0,62,10,52,'yellow');
  $s.=box(40,80,0,62,10,52,'blue');           # right half blue
  $s.=winR(80,10,26,22,42); $s.=winR(80,38,54,22,42);
  $s.=winL(62,8,24,24,44); $s.=winL(62,52,68,24,44);
  $s.=doorL(62,30,44,30,'#ff6a6b');
  $s.=box(28,46,62,70,0,4,'white');           # step
  $s.=roof(0,80,0,62,52,30,6,'red','yellow');
  $s.=chimney(56,66,8,18,52,74);
  $s.=tree(-4,70,9); $s.=tree(88,70,8);
  $s; });

# 2 Auction: wide bungalow, orange roof, AUCTION board
$out .= building('auc','/products/auction-bridging-loans','Auction', sub { my $s='';
  $s.=plinth(-14,104,-14,74,9);
  $s.=box(0,90,0,60,0,36,'cream');
  $s.=winR(90,10,28,12,30); $s.=winR(90,36,54,12,30);
  $s.=winL(60,6,24,12,30); $s.=winL(60,64,84,12,30);
  $s.=doorL(60,36,52,30,'#1b2b3b');
  $s.=roof(0,90,0,60,36,24,6,'orange','cream');
  $s.=chimney(20,30,10,20,36,56);
  $s.=signL(54,104,70,22,46,'#ff6a6b','AUCTION',8.2);
  $s.=tree(-4,68,8);
  $s; });

# 3 No valuation: tall Georgian townhouse, flat parapet, NO SITE VISIT badge
$out .= building('nov','/products/no-valuation-bridging-loans','No valuation', sub { my $s='';
  $s.=plinth(-14,84,-14,74,9);
  $s.=box(0,70,0,60,0,92,'slate');
  for my $row (0..2){ my $h0=14+$row*26; $s.=winR(70,8,22,$h0,$h0+18); $s.=winR(70,30,44,$h0,$h0+18); $s.=winR(70,50,58,$h0,$h0+18) if $row<3; }
  for my $row (1..2){ my $h0=14+$row*26; $s.=winL(60,8,22,$h0,$h0+18); $s.=winL(60,48,62,$h0,$h0+18); }
  $s.=winL(60,48,62,14,32);
  $s.=doorL(60,24,42,32,'#ff6a6b');
  $s.=box(22,24,60,64,0,34,'white'); $s.=box(42,44,60,64,0,34,'white'); $s.=box(20,46,60,66,34,38,'white');
  $s.=flatroof(0,70,0,60,92,'slate');
  $s.=chimney(10,20,8,18,96,110);
  $s.=tree(-4,70,8);
  # badge
  $s.=qq{<g transform="translate(}.((70-10)*$C+14).qq{ }.((70+10)*$S-100).qq{)"><circle r="17" fill="#fff"/><circle r="17" fill="none" stroke="#dde5ee"/><circle cy="-5" r="6" fill="#3f9583"/><path d="M-3 -5l2 2 4-4" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round" stroke-linejoin="round"/><text y="7" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="#1b2b3b">NO SITE</text><text y="13" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="#1b2b3b">VISIT</text></g>\n};
  push @pts,[(70-10)*$C+14-17,(70+10)*$S-100-17],[(70-10)*$C+14+17,(70+10)*$S-100+17];
  $s; });

# 4 Refurbishment: sage house in scaffolding, skip on the plot
$out .= building('ref','/products/refurbishment-bridging-loans','Refurbishment', sub { my $s='';
  $s.=plinth(-14,104,-14,76,9);
  $s.=box(0,78,0,60,0,46,'sage');
  $s.=winR(78,10,26,18,38); $s.=winR(78,36,52,18,38);
  $s.=winL(60,8,24,18,38); $s.=doorL(60,34,48,32,'#fffaf0');
  $s.=roof(0,78,0,60,46,26,6,'brown','sage');
  # scaffold on the left face: poles and boards
  for my $u (2,26,50,74){ $s.=box($u,$u+2.4,66,68.4,0,62,'yellowk'); }
  $s.=box(0,78,64,69,24,27,'brown' eq 'brown' ? 'grey' : 'grey');
  $s.=box(0,78,64,69,44,47,'grey');
  $s.=box(0,78,66,68,61,63,'yellowk');
  # skip
  $s.=box(84,100,30,56,0,16,'yellowk');
  $s.=qq{<ellipse cx="}.((92-43)*$C).qq{" cy="}.((92+43)*$S-17).qq{" rx="9" ry="4" fill="#9aa9b8"/>\n};
  $s; });

# 5 Semi-commercial: corner shop with flat above, striped awning
$out .= building('semi','/products/semi-commercial-bridging-loans','Semi-commercial', sub { my $s='';
  $s.=plinth(-14,100,-14,74,9);
  $s.=box(0,86,0,60,0,68,'cream');
  $s.=winR(86,8,24,40,58); $s.=winR(86,34,50,40,58);
  $s.=winL(60,8,24,42,60); $s.=winL(60,34,50,42,60); $s.=winL(60,62,78,42,60);
  # fascia sign band on left face
  $s.=box(0,86,60,62,28,36,'navy');
  $s.=textL(8,62.5,29.5,'CORNER SHOP',6.2,'#fff');
  # shopfront glass + door on left face
  $s.=poly('#ffffff','',P(4,60.5,2),P(54,60.5,2),P(54,60.5,26),P(4,60.5,26));
  $s.=poly('url(#g-glassL)','',P(6,61,4),P(52,61,4),P(52,61,24),P(6,61,24));
  $s.=doorL(60,62,78,26,'#1b2b3b');
  # awning: stripes
  for my $i (0..6){ my $u0=2+$i*12; my $f=$i%2?'#ffffff':'#ff6a6b'; $s.=poly($f,'',P($u0,60,27),P($u0+12,60,27),P($u0+12,70,21),P($u0,70,21)); }
  $s.=poly('#ffffff','',P(2,70,21),P(86,70,21),P(86,70,18.5),P(2,70,18.5));
  $s.=flatroof(0,86,0,60,68,'cream');
  $s.=chimney(64,74,8,18,72,84);
  $s; });

# 6 Commercial: glass office block
$out .= building('com','/products/commercial-bridging-loans','Commercial', sub { my $s='';
  $s.=plinth(-14,92,-14,80,9);
  $s.=box(0,78,0,66,0,104,'glass');
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..2){ my $v0=6+$c*20; $s.=winR(78,$v0,$v0+14,$h0,$h0+16); } }
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..3){ my $u0=4+$c*19; next if $row==0 && ($c==1||$c==2); $s.=winL(66,$u0,$u0+13,$h0,$h0+16); } }
  $s.=doorL(66,24,54,24,'#1b2b3b');
  $s.=poly('#ffffff',' opacity=".5"',P(24,66.6,24),P(54,66.6,24),P(54,66.6,27),P(24,66.6,27));
  $s.=flatroof(0,78,0,66,104,'white');
  $s.=box(8,22,8,20,108,116,'grey');
  $s.=qq{<line x1="}.((60-14)*$C).qq{" y1="}.((60+14)*$S-108).qq{" x2="}.((60-14)*$C).qq{" y2="}.((60+14)*$S-130).qq{" stroke="#8e9aa8" stroke-width="2"/><circle cx="}.((60-14)*$C).qq{" cy="}.((60+14)*$S-131).qq{" r="2.6" fill="#ff6a6b"/>\n};
  push @pts,[(60-14)*$C,(60+14)*$S-134];
  $s.=tree(-4,74,8); $s.=tree(86,76,8);
  $s; });

# 7 Adverse credit: brick cottage, teal roof, APPROVED board
$out .= building('adv','/products/bad-credit-bridging-loans','Adverse credit', sub { my $s='';
  $s.=plinth(-14,100,-14,74,9);
  $s.=box(0,76,0,60,0,42,'brick');
  $s.=winR(76,10,26,14,34); $s.=winR(76,36,52,14,34);
  $s.=winL(60,8,24,16,36); $s.=winL(60,54,68,16,36);
  $s.=doorL(60,32,46,32,'#3f9583');
  $s.=roof(0,76,0,60,42,30,6,'tealr','brick');
  $s.=chimney(50,60,8,18,46,66);
  $s.=signL(60,106,66,22,46,'#3f9583','APPROVED',7.6);
  $s.=tree(-4,68,8);
  $s; });

$out .= qq{    </div>
  </div>
};
open my $o,'>:raw',$ARGV[0] or die; print $o $out; close $o; print "written ", length($out), " bytes\n";
}
1;
