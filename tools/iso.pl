use strict; use warnings;
# Street-projection generator for af.credit (v3). Fronts face the road/viewer; depth recedes up-right.
# P(u,v,h): u along the street (screen x), v depth (away from the road), h up.
our ($DX,$DY) = (0.52, 0.30);   # depth vector per unit of v
our @pts;
sub P { my ($u,$v,$h)=@_; my $x=$u+$v*$DX; my $y=-$h-$v*$DY; push @pts,[$x,$y]; return sprintf("%.1f,%.1f",$x,$y); }
sub XY { my ($u,$v,$h)=@_; return ($u+$v*$DX, -$h-$v*$DY); }
sub poly { my ($fill,$extra,@p)=@_; $extra//=''; return qq{<polygon points="}.join(' ',@p).qq{" fill="$fill"$extra/>\n}; }
sub mix { my ($h,$f,$to)=@_; $to//='#ffffff'; my @a=map{hex}($h=~/#(..)(..)(..)/); my @b=map{hex}($to=~/#(..)(..)(..)/); return sprintf('#%02x%02x%02x', map { int($a[$_]+($b[$_]-$a[$_])*$f+0.5) } 0..2); }

# materials: [top, front(lit), side(shade)]
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
  for my $m (sort keys %M){ my ($t,$f,$s)=@{$M{$m}};
    $d.=qq{<linearGradient id="g-$m-f" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="}.mix($f,.20).qq{"/><stop offset="1" stop-color="}.mix($f,.08,'#000000').qq{"/></linearGradient>\n};
    $d.=qq{<linearGradient id="g-$m-s" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="}.mix($s,.08).qq{"/><stop offset="1" stop-color="}.mix($s,.18,'#000000').qq{"/></linearGradient>\n};
    $d.=qq{<linearGradient id="g-$m-t" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="}.mix($t,.18).qq{"/><stop offset="1" stop-color="$t"/></linearGradient>\n}; }
  for my $r (sort keys %ROOF){ my ($f,$b)=@{$ROOF{$r}};
    $d.=qq{<linearGradient id="g-roof-$r-f" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="}.mix($f,.28).qq{"/><stop offset=".55" stop-color="$f"/><stop offset="1" stop-color="}.mix($f,.12,'#000000').qq{"/></linearGradient>\n};
    $d.=qq{<linearGradient id="g-roof-$r-b" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="}.mix($b,.12).qq{"/><stop offset="1" stop-color="$b"/></linearGradient>\n}; }
  $d.=qq{<linearGradient id="g-ao" x1="0" y1="1" x2="0" y2="0"><stop offset="0" stop-color="#1b2b3b" stop-opacity=".26"/><stop offset="1" stop-color="#1b2b3b" stop-opacity="0"/></linearGradient>\n};
  $d.=qq{<linearGradient id="g-glass" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#f2fbff"/><stop offset=".5" stop-color="#a9dcfb"/><stop offset="1" stop-color="#5fa9e3"/></linearGradient>\n};
  $d.=qq{<linearGradient id="g-tree" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#a7ea74"/><stop offset=".6" stop-color="#5fbf43"/><stop offset="1" stop-color="#36912d"/></linearGradient>\n};
  $d.=qq{<radialGradient id="g-shadow"><stop offset="0" stop-color="#1b2b3b" stop-opacity=".28"/><stop offset=".6" stop-color="#1b2b3b" stop-opacity=".10"/><stop offset="1" stop-color="#1b2b3b" stop-opacity="0"/></radialGradient>\n};
  return $d; }

# box: top, right side (u=u1), front (v=v0)
sub box { my ($u0,$u1,$v0,$v1,$h0,$h1,$m,$ao)=@_; my $s='';
  $s.=poly("url(#g-$m-t)",'',P($u0,$v0,$h1),P($u1,$v0,$h1),P($u1,$v1,$h1),P($u0,$v1,$h1));
  $s.=poly("url(#g-$m-s)",'',P($u1,$v0,$h0),P($u1,$v1,$h0),P($u1,$v1,$h1),P($u1,$v0,$h1));
  $s.=poly("url(#g-$m-f)",'',P($u0,$v0,$h0),P($u1,$v0,$h0),P($u1,$v0,$h1),P($u0,$v0,$h1));
  if ($ao) { my $a=($h1-$h0)>24?9:5; $s.=poly('url(#g-ao)','',P($u0,$v0,$h0),P($u1,$v0,$h0),P($u1,$v0,$h0+$a),P($u0,$v0,$h0+$a)); $s.=poly('url(#g-ao)','',P($u1,$v0,$h0),P($u1,$v1,$h0),P($u1,$v1,$h0+$a),P($u1,$v0,$h0+$a)); }
  $s.=qq{<path d="M}.P($u0,$v0,$h1).' L'.P($u1,$v0,$h1).' L'.P($u1,$v0,$h0).' M'.P($u1,$v0,$h1).' L'.P($u1,$v1,$h1).qq{" fill="none" stroke="#fff" stroke-opacity=".45" stroke-width=".9" stroke-linejoin="round"/>\n};
  return $s; }
sub wall { my @a=@_; return box(@a[0..6],1); }
sub shadow { my ($u0,$u1,$v0,$v1)=@_; my ($cx,$cy)=XY(($u0+$u1)/2,($v0+$v1)/2,0); my $rx=($u1-$u0)*0.55; push @pts,[$cx-$rx,$cy-8],[$cx+$rx,$cy+10]; return qq{<ellipse cx="}.sprintf('%.1f',$cx).qq{" cy="}.sprintf('%.1f',$cy+2).qq{" rx="$rx" ry="9" fill="url(#g-shadow)"/>\n}; }
sub plinth { my ($u0,$u1,$v0,$v1,$th)=@_; my $s=''; my ($cx,$cy)=XY(($u0+$u1)/2,($v0+$v1)/2,-$th); $s.=qq{<ellipse cx="}.sprintf('%.1f',$cx).qq{" cy="}.sprintf('%.1f',$cy+4).qq{" rx="}.(($u1-$u0)*0.6).qq{" ry="11" fill="url(#g-shadow)"/>\n}; $s.=box($u0,$u1,$v0,$v1,-$th,0,'green'); return $s; }

# gable roof with the ridge along the street (front slope faces the road); gable visible on the right end
sub roof { my ($u0,$u1,$v0,$v1,$h,$R,$o,$col,$m)=@_; my $vm=($v0+$v1)/2; my $s='';
  $s.=poly("url(#g-roof-$col-b)",'',P($u0-$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R),P($u1+$o,$v1+$o,$h),P($u0-$o,$v1+$o,$h));
  $s.=poly("url(#g-$m-s)",'',P($u1,$v0,$h-1),P($u1,$v1,$h-1),P($u1,$vm,$h+$R-1));
  $s.=poly("url(#g-roof-$col-f)",'',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  for my $i (1..5){ my $t=$i/6; my $v=$v0-$o+($vm-$v0+$o)*$t; my $hh=$h+$R*$t; $s.=qq{<path d="M}.P($u0-$o,$v,$hh).' L'.P($u1+$o,$v,$hh).qq{" stroke="#1b2b3b" stroke-opacity=".10" stroke-width=".9"/>\n}; }
  $s.=poly('#fff',' opacity=".16"',P($u0-$o,$vm-($vm-$v0+$o)*0.5,$h+$R*0.5),P($u1+$o,$vm-($vm-$v0+$o)*0.5,$h+$R*0.5),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  $s.=poly('#ffffff','',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h-3.2),P($u0-$o,$v0-$o,$h-3.2));
  $s.=poly('#e7edf3','',P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3.2),P($u1+$o,$v0-$o,$h-3.2));
  $s.=poly('#dfe6ee','',P($u1+$o,$v1+$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3.2),P($u1+$o,$v1+$o,$h-3.2));
  $s.=qq{<path d="M}.P($u0-$o,$vm,$h+$R).' L'.P($u1+$o,$vm,$h+$R).qq{" stroke="#fff" stroke-width="2.2" stroke-linecap="round"/>\n};
  return $s; }
# gable roof with the ridge running back from the street: gable triangle faces the road, right slope visible
sub roofX { my ($u0,$u1,$v0,$v1,$h,$R,$o,$col,$m)=@_; my $um=($u0+$u1)/2; my $s='';
  $s.=poly("url(#g-$m-f)",'',P($u0,$v0-1,$h-1),P($u1,$v0-1,$h-1),P($um,$v0-1,$h+$R-1));
  $s.=poly("url(#g-roof-$col-b)",'',P($um,$v0-$o,$h+$R),P($um,$v1+$o,$h+$R),P($u0-$o,$v1+$o,$h),P($u0-$o,$v0-$o,$h));
  $s.=poly("url(#g-roof-$col-f)",'',P($um,$v0-$o,$h+$R),P($u1+$o,$v0-$o,$h),P($u1+$o,$v1+$o,$h),P($um,$v1+$o,$h+$R));
  for my $i (1..4){ my $t=$i/5; my $u=$um+($u1+$o-$um)*$t; my $hh=$h+$R*(1-$t); $s.=qq{<path d="M}.P($u,$v0-$o,$hh).' L'.P($u,$v1+$o,$hh).qq{" stroke="#1b2b3b" stroke-opacity=".10" stroke-width=".9"/>\n}; }
  $s.=poly('#ffffff','',P($u0-$o,$v0-$o,$h),P($um,$v0-$o,$h+$R),P($um,$v0-$o,$h+$R-3.2),P($u0-$o,$v0-$o,$h-3.2));
  $s.=poly('#ffffff','',P($um,$v0-$o,$h+$R),P($u1+$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h-3.2),P($um,$v0-$o,$h+$R-3.2));
  $s.=qq{<path d="M}.P($um,$v0-$o,$h+$R).' L'.P($um,$v1+$o,$h+$R).qq{" stroke="#fff" stroke-width="2.2" stroke-linecap="round"/>\n};
  return $s; }
sub flatroof { my ($u0,$u1,$v0,$v1,$h,$m)=@_; return box($u0-3,$u1+3,$v0-3,$v1+3,$h,$h+4,$m); }

# front windows (plane v=0 of a wall at $v): rectangles. side windows (plane u=$u): parallelograms
sub winF { my ($v,$u0,$u1,$h0,$h1)=@_; my $s='';
  $s.=box($u0-1.2,$u1+1.2,$v-1.6,$v,$h0-1.2,$h1+1.2,'white');
  my $i=1.4; $s.=poly('url(#g-glass)','',P($u0+$i,$v-1.7,$h0+$i),P($u1-$i,$v-1.7,$h0+$i),P($u1-$i,$v-1.7,$h1-$i),P($u0+$i,$v-1.7,$h1-$i));
  $s.=poly('#fff',' opacity=".3"',P($u0+$i,$v-1.8,$h1-$i),P($u0+$i+($u1-$u0)*.45,$v-1.8,$h1-$i),P($u0+$i,$v-1.8,$h0+$i+($h1-$h0)*.55));
  my $um=($u0+$u1)/2; my $hm=($h0+$h1)/2; $s.=qq{<path d="M}.P($um,$v-1.9,$h0+$i).' L'.P($um,$v-1.9,$h1-$i).' M'.P($u0+$i,$v-1.9,$hm).' L'.P($u1-$i,$v-1.9,$hm).qq{" stroke="#fff" stroke-width="1.5"/>\n};
  $s.=box($u0-2,$u1+2,$v-2.6,$v,$h0-2.6,$h0-1.2,'white');
  return $s; }
sub winS { my ($u,$v0,$v1,$h0,$h1)=@_; my $s='';
  $s.=box($u,$u+1.6,$v0-1.2,$v1+1.2,$h0-1.2,$h1+1.2,'white');
  my $i=1.4; $s.=poly('url(#g-glass)','',P($u+1.7,$v0+$i,$h0+$i),P($u+1.7,$v1-$i,$h0+$i),P($u+1.7,$v1-$i,$h1-$i),P($u+1.7,$v0+$i,$h1-$i));
  my $vm=($v0+$v1)/2; my $hm=($h0+$h1)/2; $s.=qq{<path d="M}.P($u+1.9,$vm,$h0+$i).' L'.P($u+1.9,$vm,$h1-$i).' M'.P($u+1.9,$v0+$i,$hm).' L'.P($u+1.9,$v1-$i,$hm).qq{" stroke="#fff" stroke-width="1.5"/>\n};
  return $s; }
sub doorF { my ($v,$u0,$u1,$h1,$fill,$canopy)=@_; $fill//='#ff6a6b'; $canopy//='orange'; my $s='';
  $s.=box($u0-1.5,$u1+1.5,$v-1.4,$v,0,$h1+1.5,'white');
  $s.=poly($fill,'',P($u0,$v-1.5,0),P($u1,$v-1.5,0),P($u1,$v-1.5,$h1),P($u0,$v-1.5,$h1));
  $s.=poly('#fff',' opacity=".18"',P($u0+2,$v-1.6,$h1-3),P($u1-2,$v-1.6,$h1-3),P($u1-2,$v-1.6,$h1*.55),P($u0+2,$v-1.6,$h1*.55));
  my ($kx,$ky)=XY($u1-2.2,$v-1.6,$h1*.45); $s.=qq{<circle cx="}.sprintf('%.1f',$kx).qq{" cy="}.sprintf('%.1f',$ky).qq{" r="1.2" fill="#fff"/>\n};
  $s.=box($u0-3,$u1+3,$v-8,$v,$h1+2,$h1+4.5,$canopy) if $canopy ne 'none';
  $s.=box($u0-2,$u1+2,$v-5,$v-1,0,2.2,'white');
  return $s; }
sub tree { my ($u,$v,$sz)=@_; my ($x,$y)=XY($u,$v,0); push @pts,[$x-$sz*0.6,$y-$sz*2.6],[$x+$sz*0.6,$y+5]; my $s='';
  $s.=qq{<ellipse cx="$x" cy="}.($y+1).qq{" rx="}.($sz*0.7).qq{" ry="}.($sz*0.28).qq{" fill="#1b2b3b" opacity=".14"/>\n};
  $s.=qq{<rect x="}.($x-$sz*0.22).qq{" y="}.($y-$sz*0.5).qq{" width="}.($sz*0.44).qq{" height="}.($sz*0.5).qq{" rx="1.5" fill="#c9693a"/>\n};
  for my $t ([2.6,0.62,0.55],[1.9,0.52,1.25],[1.25,0.42,1.85]) { my ($top,$w,$base)=@$t; $s.=qq{<path d="M$x }.($y-$sz*$top).qq{ L}.($x+$sz*$w).qq{ }.($y-$sz*$base).qq{ Q$x }.($y-$sz*($base-0.18)).qq{ }.($x-$sz*$w).qq{ }.($y-$sz*$base).qq{Z" fill="url(#g-tree)"/>\n}; }
  return $s; }
sub hedge { my ($u0,$u1,$v0,$v1,$h)=@_; return box($u0,$u1,$v0,$v1,0,$h,'hedge'); }
sub lamp { my ($u,$v)=@_; my $s=box($u-1.2,$u+1.2,$v-1.2,$v+1.2,0,34,'grey'); $s.=box($u-2.2,$u+2.2,$v-2.2,$v+2.2,0,1.6,'grey'); my ($x,$y)=XY($u,$v,36); $s.=qq{<circle cx="}.sprintf('%.1f',$x).qq{" cy="}.sprintf('%.1f',$y).qq{" r="3.6" fill="#fff6c4"/><circle cx="}.sprintf('%.1f',$x).qq{" cy="}.sprintf('%.1f',$y-3.6).qq{" r="2.4" fill="#1b2b3b"/>\n}; push @pts,[$x,$y-8]; return $s; }
sub car { my ($u,$v,$m)=@_; $m//='coral'; my $s=''; $s.=shadow($u-2,$u+28,$v,$v+12);
  $s.=box($u,$u+26,$v,$v+12,2,8,$m); $s.=box($u+6,$u+19,$v+1,$v+11,8,14,'glass');
  my ($x1,$y1)=XY($u+6,$v-0.5,2.5); my ($x2,$y2)=XY($u+20,$v-0.5,2.5); $s.=qq{<ellipse cx="$x1" cy="$y1" rx="3.6" ry="3.6" fill="#1b2b3b"/><ellipse cx="$x2" cy="$y2" rx="3.6" ry="3.6" fill="#1b2b3b"/><circle cx="$x1" cy="$y1" r="1.4" fill="#b7c0cb"/><circle cx="$x2" cy="$y2" r="1.4" fill="#b7c0cb"/>\n};
  $s.=poly('#fff',' opacity=".5"',P($u+1,$v-0.1,4.5),P($u+25,$v-0.1,4.5),P($u+25,$v-0.1,5.6),P($u+1,$v-0.1,5.6));
  $s.=poly('#fff6c4','',P($u+26.1,$v+1.5,4.5),P($u+26.1,$v+4.5,4.5),P($u+26.1,$v+4.5,6.5),P($u+26.1,$v+1.5,6.5));
  return $s; }
sub chimney { my ($u0,$u1,$v0,$v1,$h0,$h1)=@_; return box($u0,$u1,$v0,$v1,$h0,$h1,'white').box($u0-1,$u1+1,$v0-1,$v1+1,$h1,$h1+2.5,'grey'); }
sub textF { my ($u,$v,$h,$txt,$size,$fill,$anchor)=@_; $anchor//='start'; my ($x,$y)=XY($u,$v,$h); return qq{<text x="}.sprintf('%.1f',$x).qq{" y="}.sprintf('%.1f',$y).qq{" text-anchor="$anchor" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="$size" fill="$fill" letter-spacing=".06em">$txt</text>\n}; }
# standing signboard facing the road
sub signF { my ($u0,$u1,$v,$h0,$h1,$fill,$txt,$size)=@_; my $s=box($u0+2,$u0+4.4,$v,$v+2.4,0,$h0+2,'grey'); $s.=box($u0,$u1,$v,$v+1.6,$h0,$h1,'white'); $s.=poly($fill,'',P($u0+1.5,$v-0.3,$h0+1.5),P($u1-1.5,$v-0.3,$h0+1.5),P($u1-1.5,$v-0.3,$h1-1.5),P($u0+1.5,$v-0.3,$h1-1.5)); $s.=textF(($u0+$u1)/2,$v-0.6,$h0+($h1-$h0)/2-3,$txt,$size,'#fff','middle'); return $s; }
sub brickband { my ($u0,$u1,$v0,$v1,$h)=@_; my $s=wall($u0,$u1,$v0,$v1,0,$h,'brick'); for my $i (1..2){ my $hh=$h*$i/3; $s.=qq{<path d="M}.P($u0,$v0-0.2,$hh).' L'.P($u1,$v0-0.2,$hh).' L'.P($u1+0.2,$v1,$hh).qq{" fill="none" stroke="#fff" stroke-opacity=".35" stroke-width=".8"/>\n}; } return $s; }

sub building { my ($id,$href,$label,$body)=@_; @pts=(); my $inner=$body->(); my ($x0,$y0,$x1,$y1)=(1e9,1e9,-1e9,-1e9); for (@pts){ $x0=$_->[0] if $_->[0]<$x0; $x1=$_->[0] if $_->[0]>$x1; $y0=$_->[1] if $_->[1]<$y0; $y1=$_->[1] if $_->[1]>$y1; }
  my $pad=4; my $vb=sprintf("%.0f %.0f %.0f %.0f",$x0-$pad,$y0-$pad,($x1-$x0)+2*$pad,($y1-$y0)+2*$pad);
  return qq{      <a class="plot" role="listitem" href="$href" data-p="$id" aria-label="$label bridging loans">\n        <svg class="plot-ill" viewBox="$vb" aria-hidden="true">\n$inner        </svg>\n        <span class="plot-btn">$label <span class="arr">&rarr;</span></span>\n      </a>\n\n}; }

unless ($main::NO_RUN) {
my $out = '';
$out .= qq{  <!-- Illustrated street: one building per product facing the road, every building is a link -->
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

# 1 Residential: two-tone family house, front gable porch, red roof, trees, hedge
$out .= building('res','/products/residential-bridging-loans','Residential', sub { my $s='';
  $s.=shadow(-12,100,0,56);
  $s.=brickband(0,92,0,56,9);
  $s.=wall(0,92,0,56,9,50,'yellow'); $s.=wall(50,92,0,56,9,50,'blue');
  $s.=roof(0,92,0,56,50,28,6,'red','blue');
  $s.=chimney(70,80,30,40,50,74);
  # porch block projecting to the road with its own gable
  $s.=wall(10,44,-14,0,0,34,'yellow'); $s.=roofX(10,44,-14,0,34,16,4,'orange','yellow');
  $s.=doorF(-14,20,34,26,'#ff6a6b','none');
  $s.=winF(0,56,72,24,42); $s.=winF(0,78,90,24,42); $s.=winF(-14,30,40,10,20) if 0;
  $s.=winS(92,10,26,22,40); $s.=winS(92,36,50,22,40);
  $s.=hedge(52,90,-10,-4,6); $s.=tree(-4,-6,9); $s.=tree(100,-4,8);
  $s; });

# 2 Auction: wide bungalow, orange roof, AUCTION board on the lawn, parked car
$out .= building('auc','/products/auction-bridging-loans','Auction', sub { my $s='';
  $s.=shadow(-12,110,0,54);
  $s.=brickband(0,104,0,54,7);
  $s.=wall(0,104,0,54,7,34,'cream');
  $s.=roof(0,104,0,54,34,24,6,'orange','cream');
  $s.=chimney(22,32,28,38,34,56);
  $s.=winF(0,10,32,12,28); $s.=winF(0,72,94,12,28);
  $s.=doorF(0,44,60,28,'#1b2b3b','orange');
  $s.=winS(104,10,26,12,28); $s.=winS(104,32,48,12,28);
  $s.=signF(72,110,-16,30,50,'#ff6a6b','AUCTION',8.6);
  $s.=tree(-4,-6,8); $s.=hedge(2,40,-10,-4,5);
  $s; });

# 3 No valuation: tall Georgian townhouse, parapet, columned door, NO SITE VISIT badge, lamp post
$out .= building('nov','/products/no-valuation-bridging-loans','No valuation', sub { my $s='';
  $s.=shadow(-12,88,0,50);
  $s.=brickband(0,78,0,50,8);
  $s.=wall(0,78,0,50,8,92,'slate');
  for my $row (1..2){ my $h0=14+$row*26; $s.=winF(0,8,24,$h0,$h0+18); $s.=winF(0,31,47,$h0,$h0+18); $s.=winF(0,54,70,$h0,$h0+18); }
  $s.=winF(0,8,24,14,32); $s.=winF(0,54,70,14,32);
  $s.=doorF(0,31,47,32,'#ff6a6b','none');
  $s.=box(26,29,-5,0,0,34,'white'); $s.=box(49,52,-5,0,0,34,'white'); $s.=box(24,54,-6,0,34,38,'white');
  for my $row (0..2){ my $h0=14+$row*26; $s.=winS(78,8,22,$h0,$h0+18); $s.=winS(78,30,44,$h0,$h0+18); }
  $s.=flatroof(0,78,0,50,92,'slate');
  $s.=chimney(10,20,30,40,96,110);
  $s.=lamp(88,-8); $s.=tree(-4,-6,8);
  my ($bx,$by)=XY(84,0,104);
  $s.=qq{<g transform="translate($bx $by)"><circle r="17" fill="#fff"/><circle r="17" fill="none" stroke="#dde5ee"/><circle cy="-5" r="6" fill="#3f9583"/><path d="M-3 -5l2 2 4-4" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round" stroke-linejoin="round"/><text y="7" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="#1b2b3b">NO SITE</text><text y="13" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="#1b2b3b">VISIT</text></g>\n};
  push @pts,[$bx-17,$by-17],[$bx+17,$by+17];
  $s; });

# 4 Refurbishment: sage house in scaffolding, skip at the kerb
$out .= building('ref','/products/refurbishment-bridging-loans','Refurbishment', sub { my $s='';
  $s.=shadow(-12,118,0,54);
  $s.=brickband(0,90,0,54,7);
  $s.=wall(0,90,0,54,7,44,'sage');
  $s.=roof(0,90,0,54,44,26,6,'brown','sage');
  $s.=winF(0,10,30,16,36); $s.=winF(0,62,82,16,36);
  $s.=doorF(0,38,54,30,'#fffaf0','none');
  $s.=winS(90,12,28,16,36);
  for my $u (-2,28,58,88){ $s.=box($u,$u+2.4,-9,-6.6,0,60,'yellowk'); }
  $s.=box(-4,92,-9,-4,22,25,'grey'); $s.=box(-4,92,-9,-4,42,45,'grey'); $s.=box(-3,91,-8,-6,59,61,'yellowk');
  $s.=box(96,116,-12,2,0,16,'yellowk');
  my ($sx,$sy)=XY(106,-5,17); $s.=qq{<ellipse cx="}.sprintf('%.1f',$sx).qq{" cy="}.sprintf('%.1f',$sy).qq{" rx="9" ry="4" fill="#9aa9b8"/>\n};
  $s; });

# 5 Semi-commercial: corner shop with flat above, striped awning, fascia sign
$out .= building('semi','/products/semi-commercial-bridging-loans','Semi-commercial', sub { my $s='';
  $s.=shadow(-12,108,0,54);
  $s.=wall(0,100,0,54,0,66,'cream');
  $s.=winF(0,10,30,42,58); $s.=winF(0,40,60,42,58); $s.=winF(0,70,90,42,58);
  $s.=box(0,100,-2,0,28,36,'navy');
  $s.=textF(50,-2.3,29.6,'CORNER SHOP',6.8,'#fff','middle');
  $s.=poly('#ffffff','',P(4,-0.5,2),P(62,-0.5,2),P(62,-0.5,26),P(4,-0.5,26));
  $s.=poly('url(#g-glass)','',P(6,-1,4),P(60,-1,4),P(60,-1,24),P(6,-1,24));
  $s.=poly('#fff',' opacity=".3"',P(6,-1.2,24),P(28,-1.2,24),P(6,-1.2,10));
  $s.=doorF(0,70,88,26,'#1b2b3b','none');
  for my $i (0..7){ my $u0=2+$i*12; my $f=$i%2?'#ffffff':'#ff6a6b'; $s.=poly($f,'',P($u0,0,27),P($u0+12,0,27),P($u0+12,-9,22),P($u0,-9,22)); }
  $s.=poly('#ffffff','',P(2,-9,22),P(98,-9,22),P(98,-9,19.5),P(2,-9,19.5));
  $s.=winS(100,10,28,42,58);
  $s.=flatroof(0,100,0,54,66,'cream');
  $s.=chimney(74,84,30,40,70,82);
  $s.=hedge(-10,-4,-8,30,6);
  $s; });

# 6 Commercial: glass office block, flag, trees, car
$out .= building('com','/products/commercial-bridging-loans','Commercial', sub { my $s='';
  $s.=shadow(-12,122,0,60);
  $s.=wall(0,90,0,60,0,104,'glass');
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..3){ my $u0=5+$c*21; next if $row==0 && ($c==1||$c==2); $s.=winF(0,$u0,$u0+15,$h0,$h0+16); } }
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..2){ my $v0=6+$c*18; $s.=winS(90,$v0,$v0+12,$h0,$h0+16); } }
  $s.=doorF(0,28,62,24,'#1b2b3b','none');
  $s.=box(22,68,-7,0,24,27,'white');
  $s.=flatroof(0,90,0,60,104,'white');
  $s.=box(8,22,36,48,108,116,'grey');
  my ($fx,$fy)=XY(70,10,108); $s.=qq{<line x1="$fx" y1="$fy" x2="$fx" y2="}.($fy-22).qq{" stroke="#8e9aa8" stroke-width="2"/><circle cx="$fx" cy="}.($fy-23).qq{" r="2.6" fill="#ff6a6b"/>\n};
  push @pts,[$fx,$fy-26];
  $s.=tree(-4,-6,8); $s.=car(94,-12,'blue');
  $s; });

# 7 Adverse credit: brick cottage, teal roof, APPROVED board
$out .= building('adv','/products/bad-credit-bridging-loans','Adverse credit', sub { my $s='';
  $s.=shadow(-12,112,0,54);
  $s.=wall(0,88,0,54,0,40,'brick');
  $s.=roof(0,88,0,54,40,30,6,'tealr','brick');
  $s.=chimney(60,70,30,40,42,64);
  $s.=winF(0,10,30,14,32); $s.=winF(0,58,78,14,32);
  $s.=doorF(0,36,52,30,'#3f9583','orange');
  $s.=winS(88,12,28,14,32);
  $s.=signF(58,100,-16,32,52,'#3f9583','APPROVED',8);
  $s.=hedge(2,34,-10,-4,6); $s.=tree(-4,-6,8);
  $s; });

$out .= qq{    </div>
  </div>
};
open my $o,'>:raw',$ARGV[0] or die; print $o $out; close $o; print "written ", length($out), " bytes\n";
}
1;
