use strict; use warnings;
# Isometric rendered-look street generator for af.credit (v2: gradients, AO, trims, street furniture).
# iso(u,v,h): u runs right-down, v runs left-down, h up. Visible faces: right (u=max, lit), left (v=max, shade), top.
our ($C,$S) = (0.866, 0.5);
our @pts;
sub P { my ($u,$v,$h)=@_; my $x=($u-$v)*$C; my $y=($u+$v)*$S-$h; push @pts,[$x,$y]; return sprintf("%.1f,%.1f",$x,$y); }
sub XY { my ($u,$v,$h)=@_; return (($u-$v)*$C, ($u+$v)*$S-$h); }
sub poly { my ($fill,$extra,@p)=@_; $extra//=''; return qq{<polygon points="}.join(' ',@p).qq{" fill="$fill"$extra/>\n}; }
sub mix { my ($h,$f,$to)=@_; $to//='#ffffff'; my @a=map{hex}($h=~/#(..)(..)(..)/); my @b=map{hex}($to=~/#(..)(..)(..)/); return sprintf('#%02x%02x%02x', map { int($a[$_]+($b[$_]-$a[$_])*$f+0.5) } 0..2); }

# materials: [top, right(lit), left(shade)] — saturated, render-like
our %M = (
  yellow=>['#ffe070','#f9c62f','#d9a114'], blue=>['#86cdff','#3fa3f3','#2277c6'], cream=>['#fffaf0','#f6ecd6','#d9c6a2'],
  sage=>['#d8efc9','#a6d393','#78ad6a'], slate=>['#e3ebf4','#c5d3e4','#90a6c2'], brick=>['#f4b393','#e38a68','#b9634a'],
  teal=>['#aee3d6','#5cbba6','#378d7b'], glass=>['#d3eeff','#7ec2f3','#4a92c8'], navy=>['#4a5f78','#2f4458','#1b2b3b'],
  white=>['#ffffff','#f7f9fb','#d5dde6'], green=>['#8fe06a','#67c84a','#4aa636'], yellowk=>['#ffd650','#f3b823','#c98f10'],
  grey=>['#dde2e8','#b7c0cb','#8a96a5'], coral=>['#ffa29c','#ff6a6b','#d44b4d'], orange=>['#ffb463','#f58a2b','#c9661a'],
  hedge=>['#7fd457','#55b53a','#3b8c2b'], asphalt=>['#6b7584','#525c6b','#3d4653'],
);
our %ROOF = ( red=>['#f04d72','#bf2f50'], orange=>['#f78d33','#c9661c'], tealr=>['#5bb9a9','#38807a'], slater=>['#7b8fa9','#55677d'], brown=>['#b3794f','#7c4f31'], plum=>['#c45a7e','#8c3a5a'] );

sub defs { my $d='';
  for my $m (sort keys %M){ my ($t,$r,$l)=@{$M{$m}};
    $d.=qq{<linearGradient id="g-$m-r" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="}.mix($r,.22).qq{"/><stop offset="1" stop-color="}.mix($r,.10,'#000000').qq{"/></linearGradient>\n};
    $d.=qq{<linearGradient id="g-$m-l" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="}.mix($l,.10).qq{"/><stop offset="1" stop-color="}.mix($l,.16,'#000000').qq{"/></linearGradient>\n};
    $d.=qq{<linearGradient id="g-$m-t" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="}.mix($t,.18).qq{"/><stop offset="1" stop-color="$t"/></linearGradient>\n}; }
  for my $r (sort keys %ROOF){ my ($f,$b)=@{$ROOF{$r}};
    $d.=qq{<linearGradient id="g-roof-$r-f" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="}.mix($f,.26).qq{"/><stop offset=".55" stop-color="$f"/><stop offset="1" stop-color="}.mix($f,.12,'#000000').qq{"/></linearGradient>\n};
    $d.=qq{<linearGradient id="g-roof-$r-b" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="}.mix($b,.1).qq{"/><stop offset="1" stop-color="$b"/></linearGradient>\n}; }
  $d.=qq{<linearGradient id="g-ao" x1="0" y1="1" x2="0" y2="0"><stop offset="0" stop-color="#1b2b3b" stop-opacity=".26"/><stop offset="1" stop-color="#1b2b3b" stop-opacity="0"/></linearGradient>\n};
  $d.=qq{<linearGradient id="g-glass" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#f2fbff"/><stop offset=".5" stop-color="#a9dcfb"/><stop offset="1" stop-color="#5fa9e3"/></linearGradient>\n};
  $d.=qq{<linearGradient id="g-tree" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#a7ea74"/><stop offset=".6" stop-color="#5fbf43"/><stop offset="1" stop-color="#36912d"/></linearGradient>\n};
  $d.=qq{<radialGradient id="g-shadow"><stop offset="0" stop-color="#1b2b3b" stop-opacity=".28"/><stop offset=".6" stop-color="#1b2b3b" stop-opacity=".10"/><stop offset="1" stop-color="#1b2b3b" stop-opacity="0"/></radialGradient>\n};
  return $d; }

sub box { my ($u0,$u1,$v0,$v1,$h0,$h1,$m,$ao)=@_; my $s='';
  $s.=poly("url(#g-$m-t)",'',P($u0,$v0,$h1),P($u1,$v0,$h1),P($u1,$v1,$h1),P($u0,$v1,$h1));
  $s.=poly("url(#g-$m-r)",'',P($u1,$v0,$h0),P($u1,$v1,$h0),P($u1,$v1,$h1),P($u1,$v0,$h1));
  $s.=poly("url(#g-$m-l)",'',P($u0,$v1,$h0),P($u1,$v1,$h0),P($u1,$v1,$h1),P($u0,$v1,$h1));
  if ($ao) { my $a=($h1-$h0)>24?9:5; $s.=poly('url(#g-ao)','',P($u1,$v0,$h0),P($u1,$v1,$h0),P($u1,$v1,$h0+$a),P($u1,$v0,$h0+$a)); $s.=poly('url(#g-ao)','',P($u0,$v1,$h0),P($u1,$v1,$h0),P($u1,$v1,$h0+$a),P($u0,$v1,$h0+$a)); }
  # crisp edges: front vertical corner + top rim
  $s.=qq{<path d="M}.P($u1,$v1,$h0).' L'.P($u1,$v1,$h1).' L'.P($u1,$v0,$h1).' M'.P($u1,$v1,$h1).' L'.P($u0,$v1,$h1).qq{" fill="none" stroke="#fff" stroke-opacity=".45" stroke-width=".9" stroke-linejoin="round"/>\n};
  return $s; }
sub wall { my @a=@_; return box(@a[0..6],1); }
sub shadow { my ($u0,$u1,$v0,$v1)=@_; my ($cx,$cy)=XY(($u0+$u1)/2,($v0+$v1)/2,0); my $rx=(($u1-$u0)+($v1-$v0))*0.5; push @pts,[$cx-$rx,$cy-8],[$cx+$rx,$cy+10]; return qq{<ellipse cx="}.sprintf('%.1f',$cx).qq{" cy="}.sprintf('%.1f',$cy+2).qq{" rx="$rx" ry="10" fill="url(#g-shadow)"/>\n}; }
sub plinth { my ($u0,$u1,$v0,$v1,$th)=@_; my $s=''; my ($cx,$cy)=XY(($u0+$u1)/2,($v0+$v1)/2,-$th); $s.=qq{<ellipse cx="}.sprintf('%.1f',$cx).qq{" cy="}.sprintf('%.1f',$cy+4).qq{" rx="}.(($u1-$u0+$v1-$v0)*0.5).qq{" ry="12" fill="url(#g-shadow)"/>\n}; $s.=box($u0,$u1,$v0,$v1,-$th,0,'green'); return $s; }

# gable roof, ridge along u. eave at h, rise R, overhang o, wall material m for the gable
sub roof { my ($u0,$u1,$v0,$v1,$h,$R,$o,$col,$m)=@_; my $vm=($v0+$v1)/2; my $s='';
  $s.=poly("url(#g-roof-$col-b)",'',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  $s.=poly("url(#g-$m-r)",'',P($u1,$v0,$h-1),P($u1,$v1,$h-1),P($u1,$vm,$h+$R-1));
  $s.=poly("url(#g-roof-$col-f)",'',P($u0-$o,$v1+$o,$h),P($u1+$o,$v1+$o,$h),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  # tile courses
  for my $i (1..5){ my $t=$i/6; my $v=$v1+$o+($vm-$v1-$o)*$t; my $hh=$h+$R*$t; $s.=qq{<path d="M}.P($u0-$o,$v,$hh).' L'.P($u1+$o,$v,$hh).qq{" stroke="#1b2b3b" stroke-opacity=".10" stroke-width=".9"/>\n}; }
  # gloss
  $s.=poly('#fff',' opacity=".18"',P($u0-$o,$vm+($v1+$o-$vm)*0.5,$h+$R*0.5),P($u1+$o,$vm+($v1+$o-$vm)*0.5,$h+$R*0.5),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  # fascia (front eave), bargeboard (gable edges), ridge cap
  $s.=poly('#ffffff','',P($u0-$o,$v1+$o,$h),P($u1+$o,$v1+$o,$h),P($u1+$o,$v1+$o,$h-3.2),P($u0-$o,$v1+$o,$h-3.2));
  $s.=poly('#e7edf3','',P($u1+$o,$v1+$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3.2),P($u1+$o,$v1+$o,$h-3.2));
  $s.=poly('#f3f6f9','',P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3.2),P($u1+$o,$v0-$o,$h-3.2));
  $s.=qq{<path d="M}.P($u0-$o,$vm,$h+$R).' L'.P($u1+$o,$vm,$h+$R).qq{" stroke="#fff" stroke-width="2.2" stroke-linecap="round"/>\n};
  return $s; }
sub flatroof { my ($u0,$u1,$v0,$v1,$h,$m)=@_; return box($u0-3,$u1+3,$v0-3,$v1+3,$h,$h+4,$m); }

# windows: proud white frame box, gradient glass, reflection, sill
sub winR { my ($u,$v0,$v1,$h0,$h1)=@_; my $s='';
  $s.=box($u,$u+1.6,$v0-1.2,$v1+1.2,$h0-1.2,$h1+1.2,'white');
  my $i=1.4; $s.=poly('url(#g-glass)','',P($u+1.7,$v0+$i,$h0+$i),P($u+1.7,$v1-$i,$h0+$i),P($u+1.7,$v1-$i,$h1-$i),P($u+1.7,$v0+$i,$h1-$i));
  $s.=poly('#fff',' opacity=".35"',P($u+1.8,$v0+$i,$h1-$i),P($u+1.8,$v0+$i+($v1-$v0)*.45,$h1-$i),P($u+1.8,$v0+$i,$h0+$i+($h1-$h0)*.55));
  my $vm=($v0+$v1)/2; my $hm=($h0+$h1)/2; $s.=qq{<path d="M}.P($u+1.9,$vm,$h0+$i).' L'.P($u+1.9,$vm,$h1-$i).' M'.P($u+1.9,$v0+$i,$hm).' L'.P($u+1.9,$v1-$i,$hm).qq{" stroke="#fff" stroke-width="1.5"/>\n};
  $s.=box($u,$u+2.6,$v0-2,$v1+2,$h0-2.6,$h0-1.2,'white');
  return $s; }
sub winL { my ($v,$u0,$u1,$h0,$h1)=@_; my $s='';
  $s.=box($u0-1.2,$u1+1.2,$v,$v+1.6,$h0-1.2,$h1+1.2,'white');
  my $i=1.4; $s.=poly('url(#g-glass)','',P($u0+$i,$v+1.7,$h0+$i),P($u1-$i,$v+1.7,$h0+$i),P($u1-$i,$v+1.7,$h1-$i),P($u0+$i,$v+1.7,$h1-$i));
  $s.=poly('#fff',' opacity=".28"',P($u0+$i,$v+1.8,$h1-$i),P($u0+$i+($u1-$u0)*.45,$v+1.8,$h1-$i),P($u0+$i,$v+1.8,$h0+$i+($h1-$h0)*.55));
  my $um=($u0+$u1)/2; my $hm=($h0+$h1)/2; $s.=qq{<path d="M}.P($um,$v+1.9,$h0+$i).' L'.P($um,$v+1.9,$h1-$i).' M'.P($u0+$i,$v+1.9,$hm).' L'.P($u1-$i,$v+1.9,$hm).qq{" stroke="#fff" stroke-width="1.5"/>\n};
  $s.=box($u0-2,$u1+2,$v,$v+2.6,$h0-2.6,$h0-1.2,'white');
  return $s; }
# doors: white frame, panel, canopy, step
sub doorL { my ($v,$u0,$u1,$h1,$fill,$canopy)=@_; $fill//='#ff6a6b'; $canopy//='orange'; my $s='';
  $s.=box($u0-1.5,$u1+1.5,$v,$v+1.4,0,$h1+1.5,'white');
  $s.=poly($fill,'',P($u0,$v+1.5,0),P($u1,$v+1.5,0),P($u1,$v+1.5,$h1),P($u0,$v+1.5,$h1));
  $s.=poly('#fff',' opacity=".18"',P($u0+2,$v+1.6,$h1-3),P($u1-2,$v+1.6,$h1-3),P($u1-2,$v+1.6,$h1*.55),P($u0+2,$v+1.6,$h1*.55));
  my ($kx,$ky)=XY($u1-2.2,$v+1.6,$h1*.45); $s.=qq{<circle cx="}.sprintf('%.1f',$kx).qq{" cy="}.sprintf('%.1f',$ky).qq{" r="1.2" fill="#fff"/>\n};
  $s.=box($u0-3,$u1+3,$v,$v+7,$h1+2,$h1+4.5,$canopy) if $canopy ne 'none';
  $s.=box($u0-2,$u1+2,$v+1,$v+5,0,2.2,'white');
  return $s; }
sub doorR { my ($u,$v0,$v1,$h1,$fill)=@_; $fill//='#ff6a6b'; my $s=box($u,$u+1.4,$v0-1.5,$v1+1.5,0,$h1+1.5,'white'); $s.=poly($fill,'',P($u+1.5,$v0,0),P($u+1.5,$v1,0),P($u+1.5,$v1,$h1),P($u+1.5,$v0,$h1)); return $s; }
sub tree { my ($u,$v,$sz)=@_; my ($x,$y)=XY($u,$v,0); push @pts,[$x-$sz*0.6,$y-$sz*2.6],[$x+$sz*0.6,$y+5]; my $s='';
  $s.=qq{<ellipse cx="$x" cy="}.($y+1).qq{" rx="}.($sz*0.7).qq{" ry="}.($sz*0.28).qq{" fill="#1b2b3b" opacity=".14"/>\n};
  $s.=qq{<rect x="}.($x-$sz*0.22).qq{" y="}.($y-$sz*0.5).qq{" width="}.($sz*0.44).qq{" height="}.($sz*0.5).qq{" rx="1.5" fill="#c9693a"/>\n};
  for my $t ([2.6,0.62,0.55],[1.9,0.52,1.25],[1.25,0.42,1.85]) { my ($top,$w,$base)=@$t; $s.=qq{<path d="M$x }.($y-$sz*$top).qq{ L}.($x+$sz*$w).qq{ }.($y-$sz*$base).qq{ Q$x }.($y-$sz*($base-0.18)).qq{ }.($x-$sz*$w).qq{ }.($y-$sz*$base).qq{Z" fill="url(#g-tree)"/>\n}; }
  return $s; }
sub hedge { my ($u0,$u1,$v0,$v1,$h)=@_; my $s=box($u0,$u1,$v0,$v1,0,$h,'hedge'); return $s; }
sub lamp { my ($u,$v)=@_; my $s=box($u-1.2,$u+1.2,$v-1.2,$v+1.2,0,34,'grey'); $s.=box($u-2.2,$u+2.2,$v-2.2,$v+2.2,0,1.6,'grey'); my ($x,$y)=XY($u,$v,36); $s.=qq{<circle cx="}.sprintf('%.1f',$x).qq{" cy="}.sprintf('%.1f',$y).qq{" r="3.6" fill="#fff6c4"/><circle cx="}.sprintf('%.1f',$x).qq{" cy="}.sprintf('%.1f',$y-3.6).qq{" r="2.4" fill="#1b2b3b"/>\n}; push @pts,[$x,$y-8]; return $s; }
sub car { my ($u,$v,$m)=@_; $m//='coral'; my $s=''; $s.=shadow($u,$u+26,$v,$v+12);
  my ($x1,$y1)=XY($u+5,$v+12,2); my ($x2,$y2)=XY($u+21,$v+12,2); $s.=qq{<ellipse cx="$x1" cy="$y1" rx="3.4" ry="3.6" fill="#1b2b3b"/><ellipse cx="$x2" cy="$y2" rx="3.4" ry="3.6" fill="#1b2b3b"/>\n};
  $s.=box($u,$u+26,$v,$v+12,2,8,$m); $s.=box($u+7,$u+19,$v+1,$v+11,8,14,'glass');
  $s.=poly('#fff',' opacity=".5"',P($u+26.1,$v+1,4),P($u+26.1,$v+11,4),P($u+26.1,$v+11,5.2),P($u+26.1,$v+1,5.2));
  $s.=poly('#fff6c4','',P($u+26.1,$v+1.5,5.5),P($u+26.1,$v+4,5.5),P($u+26.1,$v+4,7.2),P($u+26.1,$v+1.5,7.2)); $s.=poly('#fff6c4','',P($u+26.1,$v+8,5.5),P($u+26.1,$v+10.5,5.5),P($u+26.1,$v+10.5,7.2),P($u+26.1,$v+8,7.2));
  return $s; }
sub chimney { my ($u0,$u1,$v0,$v1,$h0,$h1)=@_; return box($u0,$u1,$v0,$v1,$h0,$h1,'white').box($u0-1,$u1+1,$v0-1,$v1+1,$h1,$h1+2.5,'grey'); }
sub textL { my ($u,$v,$h,$txt,$size,$fill)=@_; my ($x,$y)=XY($u,$v,$h); return qq{<text transform="matrix(0.866,0.5,0,1,$x,$y)" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="$size" fill="$fill" letter-spacing=".06em">$txt</text>\n}; }
sub textR { my ($u,$v,$h,$txt,$size,$fill)=@_; my ($x,$y)=XY($u,$v,$h); return qq{<text transform="matrix(0.866,-0.5,0,1,$x,$y)" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="$size" fill="$fill" letter-spacing=".06em">$txt</text>\n}; }
sub signL { my ($u0,$u1,$v,$h0,$h1,$fill,$txt,$size)=@_; my $s=box($u0-2,$u0,$v-2,$v,0,$h0+2,'grey'); $s.=box($u0,$u1,$v-1.5,$v,$h0,$h1,'white'); $s.=poly($fill,'',P($u0+1.5,$v+0.3,$h0+1.5),P($u1-1.5,$v+0.3,$h0+1.5),P($u1-1.5,$v+0.3,$h1-1.5),P($u0+1.5,$v+0.3,$h1-1.5)); $s.=textL($u0+4,$v+0.6,$h0+($h1-$h0)/2-3.2,$txt,$size,'#fff'); return $s; }
sub brickband { my ($u0,$u1,$v0,$v1,$h)=@_; my $s=wall($u0,$u1,$v0,$v1,0,$h,'brick'); for my $i (1..2){ my $hh=$h*$i/3; $s.=qq{<path d="M}.P($u1+0.2,$v0,$hh).' L'.P($u1+0.2,$v1,$hh).' L'.P($u0,$v1+0.2,$hh).qq{" fill="none" stroke="#fff" stroke-opacity=".35" stroke-width=".8"/>\n}; } return $s; }

sub building { my ($id,$href,$label,$body)=@_; @pts=(); my $inner=$body->(); my ($x0,$y0,$x1,$y1)=(1e9,1e9,-1e9,-1e9); for (@pts){ $x0=$_->[0] if $_->[0]<$x0; $x1=$_->[0] if $_->[0]>$x1; $y0=$_->[1] if $_->[1]<$y0; $y1=$_->[1] if $_->[1]>$y1; }
  my $pad=4; my $vb=sprintf("%.0f %.0f %.0f %.0f",$x0-$pad,$y0-$pad,($x1-$x0)+2*$pad,($y1-$y0)+2*$pad);
  return qq{      <a class="plot" role="listitem" href="$href" data-p="$id" aria-label="$label bridging loans">\n        <svg class="plot-ill" viewBox="$vb" aria-hidden="true">\n$inner        </svg>\n        <span class="plot-btn">$label <span class="arr">&rarr;</span></span>\n      </a>\n\n}; }

unless ($main::NO_RUN) {
my $out = '';
$out .= qq{  <!-- Illustrated street: one isometric building per product, every building is a link -->
  <div class="hm-street">
    <svg width="0" height="0" style="position:absolute" aria-hidden="true" focusable="false"><defs>
}.defs().qq{    </defs></svg>

    <div class="street-sky" aria-hidden="true">
      <svg class="cloud cloud-1" viewBox="0 0 120 50"><path d="M18 40c-10-22 22-36 36-20 10-18 44-14 46 8 20-4 30 20 10 26H30c-16 0-20-8-12-14z" fill="#fff"/></svg>
      <svg class="cloud cloud-2" viewBox="0 0 120 50"><path d="M18 40c-10-22 22-36 36-20 10-18 44-14 46 8 20-4 30 20 10 26H30c-16 0-20-8-12-14z" fill="#fff"/></svg>
      <svg class="cloud cloud-3" viewBox="0 0 120 50"><path d="M18 40c-10-22 22-36 36-20 10-18 44-14 46 8 20-4 30 20 10 26H30c-16 0-20-8-12-14z" fill="#fff"/></svg>
    </div>

    <div class="plots" role="list" aria-label="What we lend on">

};

# 1 Residential: two-tone family house, red roof, canopy, trees, hedge
$out .= building('res','/products/residential-bridging-loans','Residential', sub { my $s='';
  $s.=shadow(-10,90,-10,72);
  $s.=brickband(0,80,0,62,9);
  $s.=wall(0,80,0,62,9,52,'yellow'); $s.=wall(40,80,0,62,9,52,'blue');
  $s.=winR(80,10,26,22,42); $s.=winR(80,38,54,22,42);
  $s.=winL(62,8,24,24,44); $s.=winL(62,52,68,24,44);
  $s.=doorL(62,30,44,30,'#ff6a6b','orange');
  $s.=roof(0,80,0,62,52,30,6,'red','yellow');
  $s.=chimney(56,66,8,18,52,74);
  $s.=hedge(-12,-4,30,62,7); $s.=tree(-6,72,9); $s.=tree(88,72,8);
  $s; });

# 2 Auction: wide bungalow, orange roof, AUCTION board, parked car
$out .= building('auc','/products/auction-bridging-loans','Auction', sub { my $s='';
  $s.=shadow(-10,100,-10,70);
  $s.=brickband(0,90,0,60,7);
  $s.=wall(0,90,0,60,7,36,'cream');
  $s.=winR(90,10,28,12,30); $s.=winR(90,36,54,12,30);
  $s.=winL(60,6,24,12,30); $s.=winL(60,64,84,12,30);
  $s.=doorL(60,36,52,30,'#1b2b3b','orange');
  $s.=roof(0,90,0,60,36,24,6,'orange','cream');
  $s.=chimney(20,30,10,20,36,56);
  $s.=signL(54,104,70,22,46,'#ff6a6b','AUCTION',8.2);
  $s.=car(-30,40,'coral'); $s.=tree(-4,70,8);
  $s; });

# 3 No valuation: tall Georgian townhouse, flat parapet, NO SITE VISIT badge, lamp post
$out .= building('nov','/products/no-valuation-bridging-loans','No valuation', sub { my $s='';
  $s.=shadow(-10,80,-10,70);
  $s.=brickband(0,70,0,60,8);
  $s.=wall(0,70,0,60,8,92,'slate');
  for my $row (0..2){ my $h0=14+$row*26; $s.=winR(70,8,22,$h0,$h0+18); $s.=winR(70,30,44,$h0,$h0+18); $s.=winR(70,50,58,$h0,$h0+18); }
  for my $row (1..2){ my $h0=14+$row*26; $s.=winL(60,8,22,$h0,$h0+18); $s.=winL(60,48,62,$h0,$h0+18); }
  $s.=winL(60,48,62,14,32);
  $s.=doorL(60,24,42,32,'#ff6a6b','none');
  $s.=box(22,24,60,64,0,34,'white'); $s.=box(42,44,60,64,0,34,'white'); $s.=box(20,46,60,66,34,38,'white');
  $s.=flatroof(0,70,0,60,92,'slate');
  $s.=chimney(10,20,8,18,96,110);
  $s.=lamp(80,56); $s.=tree(-4,70,8);
  my ($bx,$by)=XY(70,10,100); $bx+=14;
  $s.=qq{<g transform="translate($bx $by)"><circle r="17" fill="#fff"/><circle r="17" fill="none" stroke="#dde5ee"/><circle cy="-5" r="6" fill="#3f9583"/><path d="M-3 -5l2 2 4-4" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round" stroke-linejoin="round"/><text y="7" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="#1b2b3b">NO SITE</text><text y="13" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="#1b2b3b">VISIT</text></g>\n};
  push @pts,[$bx-17,$by-17],[$bx+17,$by+17];
  $s; });

# 4 Refurbishment: sage house in scaffolding, skip on the plot
$out .= building('ref','/products/refurbishment-bridging-loans','Refurbishment', sub { my $s='';
  $s.=shadow(-10,104,-10,74);
  $s.=brickband(0,78,0,60,7);
  $s.=wall(0,78,0,60,7,46,'sage');
  $s.=winR(78,10,26,18,38); $s.=winR(78,36,52,18,38);
  $s.=winL(60,8,24,18,38); $s.=doorL(60,34,48,32,'#fffaf0','none');
  $s.=roof(0,78,0,60,46,26,6,'brown','sage');
  for my $u (2,26,50,74){ $s.=box($u,$u+2.4,66,68.4,0,62,'yellowk'); }
  $s.=box(0,78,64,69,24,27,'grey'); $s.=box(0,78,64,69,44,47,'grey'); $s.=box(0,78,66,68,61,63,'yellowk');
  $s.=box(84,100,30,56,0,16,'yellowk');
  my ($sx,$sy)=XY(92,43,17); $s.=qq{<ellipse cx="}.sprintf('%.1f',$sx).qq{" cy="}.sprintf('%.1f',$sy).qq{" rx="9" ry="4" fill="#9aa9b8"/>\n};
  $s.=tree(-4,70,8);
  $s; });

# 5 Semi-commercial: corner shop with flat above, striped awning
$out .= building('semi','/products/semi-commercial-bridging-loans','Semi-commercial', sub { my $s='';
  $s.=shadow(-10,96,-10,70);
  $s.=wall(0,86,0,60,0,68,'cream');
  $s.=winR(86,8,24,40,58); $s.=winR(86,34,50,40,58);
  $s.=winL(60,8,24,42,60); $s.=winL(60,34,50,42,60); $s.=winL(60,62,78,42,60);
  $s.=box(0,86,60,62,28,36,'navy');
  $s.=textL(8,62.5,29.5,'CORNER SHOP',6.2,'#fff');
  $s.=poly('#ffffff','',P(4,60.5,2),P(54,60.5,2),P(54,60.5,26),P(4,60.5,26));
  $s.=poly('url(#g-glass)','',P(6,61,4),P(52,61,4),P(52,61,24),P(6,61,24));
  $s.=poly('#fff',' opacity=".3"',P(6,61.2,24),P(26,61.2,24),P(6,61.2,10));
  $s.=doorL(60,62,78,26,'#1b2b3b','none');
  for my $i (0..6){ my $u0=2+$i*12; my $f=$i%2?'#ffffff':'#ff6a6b'; $s.=poly($f,'',P($u0,60,27),P($u0+12,60,27),P($u0+12,70,21),P($u0,70,21)); }
  $s.=poly('#ffffff','',P(2,70,21),P(86,70,21),P(86,70,18.5),P(2,70,18.5));
  $s.=flatroof(0,86,0,60,68,'cream');
  $s.=chimney(64,74,8,18,72,84);
  $s.=hedge(90,98,20,60,6);
  $s; });

# 6 Commercial: glass office block, flag, trees, car
$out .= building('com','/products/commercial-bridging-loans','Commercial', sub { my $s='';
  $s.=shadow(-10,92,-10,80);
  $s.=wall(0,78,0,66,0,104,'glass');
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..2){ my $v0=6+$c*20; $s.=winR(78,$v0,$v0+14,$h0,$h0+16); } }
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..3){ my $u0=4+$c*19; next if $row==0 && ($c==1||$c==2); $s.=winL(66,$u0,$u0+13,$h0,$h0+16); } }
  $s.=doorL(66,24,54,24,'#1b2b3b','none');
  $s.=box(20,58,66,72,24,27,'white');
  $s.=flatroof(0,78,0,66,104,'white');
  $s.=box(8,22,8,20,108,116,'grey');
  my ($fx,$fy)=XY(60,14,108); $s.=qq{<line x1="$fx" y1="$fy" x2="$fx" y2="}.($fy-22).qq{" stroke="#8e9aa8" stroke-width="2"/><circle cx="$fx" cy="}.($fy-23).qq{" r="2.6" fill="#ff6a6b"/>\n};
  push @pts,[$fx,$fy-26];
  $s.=tree(-4,74,8); $s.=car(80,46,'blue');
  $s; });

# 7 Adverse credit: brick cottage, teal roof, APPROVED board
$out .= building('adv','/products/bad-credit-bridging-loans','Adverse credit', sub { my $s='';
  $s.=shadow(-10,106,-10,72);
  $s.=wall(0,76,0,60,0,42,'brick');
  $s.=winR(76,10,26,14,34); $s.=winR(76,36,52,14,34);
  $s.=winL(60,8,24,16,36); $s.=winL(60,54,68,16,36);
  $s.=doorL(60,32,46,32,'#3f9583','orange');
  $s.=roof(0,76,0,60,42,30,6,'tealr','brick');
  $s.=chimney(50,60,8,18,46,66);
  $s.=signL(60,106,66,22,46,'#3f9583','APPROVED',7.6);
  $s.=hedge(-12,-4,20,56,7); $s.=tree(-4,68,8);
  $s; });

$out .= qq{    </div>
  </div>
};
open my $o,'>:raw',$ARGV[0] or die; print $o $out; close $o; print "written ", length($out), " bytes\n";
}
1;
