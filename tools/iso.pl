use strict; use warnings;
# Flat outlined street generator for af.credit (v4). Fronts face the road; depth recedes up-right. Flat fills, thin dark outlines.
our ($DX,$DY) = (0.52, 0.30);
our $INK = '#2a2d3e';
our @pts;
sub P { my ($u,$v,$h)=@_; my $x=$u+$v*$DX; my $y=-$h-$v*$DY; push @pts,[$x,$y]; return sprintf("%.1f,%.1f",$x,$y); }
sub XY { my ($u,$v,$h)=@_; return ($u+$v*$DX, -$h-$v*$DY); }
sub poly { my ($fill,$extra,@p)=@_; $extra//=''; my $st = ($extra =~ /nostroke/) ? '' : qq{ stroke="$INK" stroke-width="1.1" stroke-linejoin="round"}; $extra =~ s/ ?nostroke//; return qq{<polygon points="}.join(' ',@p).qq{" fill="$fill"$st$extra/>\n}; }
sub line { my ($extra,@p)=@_; return qq{<path d="M}.join(' L',@p).qq{" fill="none" stroke="$INK" stroke-width="1" stroke-linecap="round"$extra/>\n}; }

our %M = (
  yellow=>['#ffd96b','#f7c84a','#e0ad2b'], blue=>['#8fa6f7','#6f8df4','#4e6fdd'], cream=>['#fff8ea','#faf0dc','#e8d9bd'],
  sage=>['#c9e8b4','#a9d690','#86b96d'], slate=>['#dde3f5','#c5cdf0','#a0a9d9'], brick=>['#f4a97a','#e58b5a','#c76f3f'],
  teal=>['#8fd6c8','#5fbcae','#3f9a8d'], glass=>['#d8f0fb','#bfe5f7','#9cd3ef'], navy=>['#3d4460','#2b3147','#1d2235'],
  white=>['#ffffff','#ffffff','#e9e9f2'], green=>['#9ddc8a','#7fcf6a','#5faf4c'], yellowk=>['#ffd96b','#f7c84a','#e0ad2b'],
  grey=>['#e9ebf2','#d8dbe6','#b5b9c9'], coral=>['#ff8a8a','#ff6a6b','#d94f52'], orange=>['#f9a05c','#f5853a','#d9661f'],
  hedge=>['#9ddc8a','#7fcf6a','#5faf4c'], lilac=>['#ddd4f6','#c9bdf0','#a897e0'], peri=>['#b3baf8','#9aa3f5','#7c86e8'],
);
our %ROOF = ( red=>['#ef5a6f','#c93f55'], orange=>['#f5853a','#d9661f'], tealr=>['#5fbcae','#3f9a8d'], slater=>['#8ea1c9','#6d7fa8'], brown=>['#b9865a','#94643f'], plum=>['#b86aa6','#8f4a7f'], peri=>['#9aa3f5','#7c86e8'] );
sub defs { return ''; }

sub box { my ($u0,$u1,$v0,$v1,$h0,$h1,$m)=@_; my ($t,$f,$sd)=@{$M{$m}}; my $s='';
  $s.=poly($t,'',P($u0,$v0,$h1),P($u1,$v0,$h1),P($u1,$v1,$h1),P($u0,$v1,$h1));
  $s.=poly($sd,'',P($u1,$v0,$h0),P($u1,$v1,$h0),P($u1,$v1,$h1),P($u1,$v0,$h1));
  $s.=poly($f,'',P($u0,$v0,$h0),P($u1,$v0,$h0),P($u1,$v0,$h1),P($u0,$v0,$h1));
  return $s; }
sub wall { my @a=@_; return box(@a[0..6]); }
sub shadow { my ($u0,$u1,$v0,$v1)=@_; my ($cx,$cy)=XY(($u0+$u1)/2,($v0+$v1)/2,0); my $rx=($u1-$u0)*0.55; push @pts,[$cx-$rx,$cy-6],[$cx+$rx,$cy+8]; return qq{<ellipse cx="}.sprintf('%.1f',$cx).qq{" cy="}.sprintf('%.1f',$cy+2).qq{" rx="$rx" ry="7" fill="$INK" opacity=".10"/>\n}; }
sub plinth { my ($u0,$u1,$v0,$v1,$th)=@_; my $s=''; my ($cx,$cy)=XY(($u0+$u1)/2,($v0+$v1)/2,-$th); $s.=qq{<ellipse cx="}.sprintf('%.1f',$cx).qq{" cy="}.sprintf('%.1f',$cy+4).qq{" rx="}.(($u1-$u0)*0.6).qq{" ry="10" fill="$INK" opacity=".10"/>\n}; $s.=box($u0,$u1,$v0,$v1,-$th,0,'green'); return $s; }

sub roof { my ($u0,$u1,$v0,$v1,$h,$R,$o,$col,$m)=@_; my $vm=($v0+$v1)/2; my ($f,$b)=@{$ROOF{$col}}; my $s='';
  $s.=poly($b,'',P($u0-$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R),P($u1+$o,$v1+$o,$h),P($u0-$o,$v1+$o,$h));
  $s.=poly($M{$m}[2],'',P($u1,$v0,$h-1),P($u1,$v1,$h-1),P($u1,$vm,$h+$R-1));
  $s.=poly($f,'',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  my $n=int(($u1-$u0+2*$o)/9); for my $i (1..$n-1){ my $u=$u0-$o+($u1-$u0+2*$o)*$i/$n; $s.=line(' opacity=".55"',P($u,$v0-$o,$h),P($u,$vm,$h+$R)); }
  $s.=poly('#ffffff','',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h-3),P($u0-$o,$v0-$o,$h-3));
  $s.=poly('#ffffff','',P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3),P($u1+$o,$v0-$o,$h-3));
  $s.=poly('#e9e9f2','',P($u1+$o,$v1+$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3),P($u1+$o,$v1+$o,$h-3));
  return $s; }
sub roofX { my ($u0,$u1,$v0,$v1,$h,$R,$o,$col,$m)=@_; my $um=($u0+$u1)/2; my ($f,$b)=@{$ROOF{$col}}; my $s='';
  $s.=poly($M{$m}[1],'',P($u0,$v0-1,$h-1),P($u1,$v0-1,$h-1),P($um,$v0-1,$h+$R-1));
  $s.=poly($b,'',P($um,$v0-$o,$h+$R),P($um,$v1+$o,$h+$R),P($u0-$o,$v1+$o,$h),P($u0-$o,$v0-$o,$h));
  $s.=poly($f,'',P($um,$v0-$o,$h+$R),P($u1+$o,$v0-$o,$h),P($u1+$o,$v1+$o,$h),P($um,$v1+$o,$h+$R));
  for my $i (1..3){ my $t=$i/4; my $u=$um+($u1+$o-$um)*$t; my $hh=$h+$R*(1-$t); $s.=line(' opacity=".55"',P($u,$v0-$o,$hh),P($u,$v1+$o,$hh)); }
  $s.=poly('#ffffff','',P($u0-$o,$v0-$o,$h),P($um,$v0-$o,$h+$R),P($um,$v0-$o,$h+$R-3),P($u0-$o,$v0-$o,$h-3));
  $s.=poly('#ffffff','',P($um,$v0-$o,$h+$R),P($u1+$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h-3),P($um,$v0-$o,$h+$R-3));
  return $s; }
sub flatroof { my ($u0,$u1,$v0,$v1,$h,$m)=@_; return box($u0-3,$u1+3,$v0-3,$v1+3,$h,$h+4,$m); }

sub winF { my ($v,$u0,$u1,$h0,$h1)=@_; my $s='';
  $s.=poly('#ffffff','',P($u0-1.5,$v-0.6,$h0-1.5),P($u1+1.5,$v-0.6,$h0-1.5),P($u1+1.5,$v-0.6,$h1+1.5),P($u0-1.5,$v-0.6,$h1+1.5));
  $s.=poly($M{glass}[1],'',P($u0,$v-0.8,$h0),P($u1,$v-0.8,$h0),P($u1,$v-0.8,$h1),P($u0,$v-0.8,$h1));
  my $um=($u0+$u1)/2; my $hm=($h0+$h1)/2; $s.=line('',P($um,$v-0.9,$h0),P($um,$v-0.9,$h1)); $s.=line('',P($u0,$v-0.9,$hm),P($u1,$v-0.9,$hm));
  $s.=poly('#ffffff','',P($u0-2.5,$v-2.6,$h0-2.4),P($u1+2.5,$v-2.6,$h0-2.4),P($u1+2.5,$v-0.6,$h0-1.5),P($u0-2.5,$v-0.6,$h0-1.5));
  return $s; }
sub winS { my ($u,$v0,$v1,$h0,$h1)=@_; my $s='';
  $s.=poly('#ffffff','',P($u+0.6,$v0-1.5,$h0-1.5),P($u+0.6,$v1+1.5,$h0-1.5),P($u+0.6,$v1+1.5,$h1+1.5),P($u+0.6,$v0-1.5,$h1+1.5));
  $s.=poly($M{glass}[2],'',P($u+0.8,$v0,$h0),P($u+0.8,$v1,$h0),P($u+0.8,$v1,$h1),P($u+0.8,$v0,$h1));
  my $vm=($v0+$v1)/2; my $hm=($h0+$h1)/2; $s.=line('',P($u+0.9,$vm,$h0),P($u+0.9,$vm,$h1)); $s.=line('',P($u+0.9,$v0,$hm),P($u+0.9,$v1,$hm));
  return $s; }
sub doorF { my ($v,$u0,$u1,$h1,$fill,$canopy)=@_; $fill//='#ff6a6b'; $canopy//='orange'; my $s='';
  $s.=poly('#ffffff','',P($u0-1.5,$v-0.6,0),P($u1+1.5,$v-0.6,0),P($u1+1.5,$v-0.6,$h1+1.5),P($u0-1.5,$v-0.6,$h1+1.5));
  $s.=poly($fill,'',P($u0,$v-0.8,0),P($u1,$v-0.8,0),P($u1,$v-0.8,$h1),P($u0,$v-0.8,$h1));
  $s.=line(' opacity=".5"',P($u0+2.5,$v-0.9,$h1-3),P($u1-2.5,$v-0.9,$h1-3),P($u1-2.5,$v-0.9,$h1*.5),P($u0+2.5,$v-0.9,$h1*.5),P($u0+2.5,$v-0.9,$h1-3));
  my ($kx,$ky)=XY($u1-2.2,$v-0.9,$h1*.42); $s.=qq{<circle cx="}.sprintf('%.1f',$kx).qq{" cy="}.sprintf('%.1f',$ky).qq{" r="1.1" fill="$INK"/>\n};
  $s.=box($u0-3,$u1+3,$v-8,$v,$h1+2,$h1+4.5,$canopy) if $canopy ne 'none';
  $s.=box($u0-2,$u1+2,$v-5,$v-1,0,2.2,'white');
  return $s; }
sub tree { my ($u,$v,$sz)=@_; my ($x,$y)=XY($u,$v,0); push @pts,[$x-$sz*0.9,$y-$sz*2.7],[$x+$sz*0.9,$y+4]; my $s='';
  $s.=qq{<ellipse cx="$x" cy="}.($y+1).qq{" rx="}.($sz*0.7).qq{" ry="}.($sz*0.25).qq{" fill="$INK" opacity=".10"/>\n};
  $s.=qq{<rect x="}.($x-$sz*0.14).qq{" y="}.($y-$sz*1.1).qq{" width="}.($sz*0.28).qq{" height="}.($sz*1.1).qq{" fill="#b9865a" stroke="$INK" stroke-width="1"/>\n};
  $s.=qq{<ellipse cx="$x" cy="}.($y-$sz*1.7).qq{" rx="}.($sz*0.8).qq{" ry="}.($sz*0.9).qq{" fill="#7fcf6a" stroke="$INK" stroke-width="1.1"/>\n};
  $s.=qq{<ellipse cx="}.($x-$sz*0.25).qq{" cy="}.($y-$sz*1.95).qq{" rx="}.($sz*0.3).qq{" ry="}.($sz*0.32).qq{" fill="#9ddc8a"/>\n};
  return $s; }
sub hedge { my ($u0,$u1,$v0,$v1,$h)=@_; return box($u0,$u1,$v0,$v1,0,$h,'hedge'); }
sub lamp { my ($u,$v)=@_; my $s=box($u-1.2,$u+1.2,$v-1.2,$v+1.2,0,34,'grey'); my ($x,$y)=XY($u,$v,36); $s.=qq{<circle cx="}.sprintf('%.1f',$x).qq{" cy="}.sprintf('%.1f',$y).qq{" r="3.6" fill="#ffd96b" stroke="$INK" stroke-width="1"/><circle cx="}.sprintf('%.1f',$x).qq{" cy="}.sprintf('%.1f',$y-3.6).qq{" r="2.2" fill="$INK"/>\n}; push @pts,[$x,$y-8]; return $s; }
sub car { my ($u,$v,$m)=@_; $m//='coral'; my $s=''; $s.=shadow($u-2,$u+28,$v,$v+12);
  $s.=box($u,$u+26,$v,$v+12,2,8,$m); $s.=box($u+6,$u+19,$v+1,$v+11,8,14,'glass');
  my ($x1,$y1)=XY($u+6,$v-0.5,2.5); my ($x2,$y2)=XY($u+20,$v-0.5,2.5); $s.=qq{<circle cx="$x1" cy="$y1" r="3.6" fill="$INK"/><circle cx="$x2" cy="$y2" r="3.6" fill="$INK"/><circle cx="$x1" cy="$y1" r="1.5" fill="#d8dbe6"/><circle cx="$x2" cy="$y2" r="1.5" fill="#d8dbe6"/>\n};
  $s.=poly('#ffd96b','',P($u+26,$v+1.5,4.5),P($u+26,$v+4.5,4.5),P($u+26,$v+4.5,6.5),P($u+26,$v+1.5,6.5));
  return $s; }
sub chimney { my ($u0,$u1,$v0,$v1,$h0,$h1)=@_; return box($u0,$u1,$v0,$v1,$h0,$h1,'white').box($u0-1,$u1+1,$v0-1,$v1+1,$h1,$h1+2.5,'grey'); }
sub textF { my ($u,$v,$h,$txt,$size,$fill,$anchor)=@_; $anchor//='start'; my ($x,$y)=XY($u,$v,$h); return qq{<text x="}.sprintf('%.1f',$x).qq{" y="}.sprintf('%.1f',$y).qq{" text-anchor="$anchor" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="$size" fill="$fill" letter-spacing=".06em">$txt</text>\n}; }
sub signF { my ($u0,$u1,$v,$h0,$h1,$fill,$txt,$size)=@_; my $s=box($u0+2,$u0+4.4,$v,$v+2.4,0,$h0+2,'grey'); $s.=box($u0,$u1,$v,$v+1.6,$h0,$h1,'white'); $s.=poly($fill,'',P($u0+1.5,$v-0.3,$h0+1.5),P($u1-1.5,$v-0.3,$h0+1.5),P($u1-1.5,$v-0.3,$h1-1.5),P($u0+1.5,$v-0.3,$h1-1.5)); $s.=textF(($u0+$u1)/2,$v-0.6,$h0+($h1-$h0)/2-3,$txt,$size,'#fff','middle'); return $s; }
sub brickband { my ($u0,$u1,$v0,$v1,$h)=@_; my $s=wall($u0,$u1,$v0,$v1,0,$h,'brick'); for my $i (1..2){ my $hh=$h*$i/3; $s.=line(' opacity=".45"',P($u0,$v0-0.2,$hh),P($u1,$v0-0.2,$hh)); } return $s; }

# front-facing flat person standing at (u,v)
sub person { my ($u,$v,%o)=@_; my $top=$o{top}//'#6f8df4'; my $legs=$o{legs}//'#2b3147'; my $skin=$o{skin}//'#f3c9a6'; my $hair=$o{hair}//'#2a2d3e'; my ($x,$y)=XY($u,$v,0); my $s=''; my $st=qq{ stroke="$INK" stroke-width="1.1" stroke-linejoin="round"};
  push @pts,[$x-16,$y-48],[$x+16,$y+3];
  $s.=qq{<ellipse cx="$x" cy="}.($y+1).qq{" rx="7" ry="2.2" fill="$INK" opacity=".12"/>\n};
  $s.=qq{<rect x="}.($x-4.6).qq{" y="}.($y-15).qq{" width="4" height="15" rx="1.5" fill="$legs"$st/><rect x="}.($x+0.6).qq{" y="}.($y-15).qq{" width="4" height="15" rx="1.5" fill="$legs"$st/>\n};
  $s.=qq{<rect x="}.($x-5.4).qq{" y="}.($y-1.5).qq{" width="5.2" height="2.6" rx="1.2" fill="$INK"/><rect x="}.($x+0.2).qq{" y="}.($y-1.5).qq{" width="5.2" height="2.6" rx="1.2" fill="$INK"/>\n};
  $s.=qq{<rect x="}.($x-6.5).qq{" y="}.($y-31).qq{" width="13" height="17" rx="4" fill="$top"$st/>\n};
  if ($o{apron}) { $s.=qq{<rect x="}.($x-4).qq{" y="}.($y-27).qq{" width="8" height="12" rx="1.5" fill="#ffffff"$st/>\n}; }
  if ($o{hivis}) { $s.=qq{<path d="M}.($x-6.5).' '.($y-24).qq{h13M}.($x-6.5).' '.($y-20).qq{h13" stroke="#ffd96b" stroke-width="2"/>\n}; }
  my $army=$y-29;
  if (($o{prop}//'') eq 'point') {
    $s.=qq{<path d="M}.($x+6).' '.$army.qq{l9 -6" stroke="$top" stroke-width="4" stroke-linecap="round"/><circle cx="}.($x+15.4).qq{" cy="}.($army-6.4).qq{" r="2.3" fill="$skin"$st/>\n};
    $s.=qq{<path d="M}.($x-6).' '.$army.qq{l-3 10" stroke="$top" stroke-width="4" stroke-linecap="round"/><circle cx="}.($x-9.4).qq{" cy="}.($army+10.6).qq{" r="2.3" fill="$skin"$st/>\n}; }
  else {
    $s.=qq{<path d="M}.($x-6).' '.$army.qq{l-3 10" stroke="$top" stroke-width="4" stroke-linecap="round"/><path d="M}.($x+6).' '.$army.qq{l3 10" stroke="$top" stroke-width="4" stroke-linecap="round"/><circle cx="}.($x-9.4).qq{" cy="}.($army+10.6).qq{" r="2.3" fill="$skin"$st/><circle cx="}.($x+9.4).qq{" cy="}.($army+10.6).qq{" r="2.3" fill="$skin"$st/>\n}; }
  $s.=qq{<rect x="}.($x-1.6).qq{" y="}.($y-34).qq{" width="3.2" height="4" fill="$skin"/>\n};
  $s.=qq{<circle cx="$x" cy="}.($y-39).qq{" r="6.5" fill="$skin"$st/>\n};
  my $hs=$o{hairstyle}//'short';
  if ($hs eq 'short' || $hs eq 'bun') { $s.=qq{<path d="M}.($x-6.3).' '.($y-40).qq{a6.4 6.4 0 0 1 12.6 0 q-3 -2.4 -6.3 -2.4 q-3.3 0 -6.3 2.4z" fill="$hair"$st/>\n}; }
  if ($hs eq 'bun') { $s.=qq{<circle cx="}.($x+5).qq{" cy="}.($y-45).qq{" r="2.6" fill="$hair"$st/>\n}; }
  if ($hs eq 'long') { $s.=qq{<path d="M}.($x-6.6).' '.($y-39).qq{a6.6 6.6 0 0 1 13.2 0 l1 8 h-3 l-1 -6 q-3.6 -2 -7.2 0 l-1 6 h-3z" fill="$hair"$st/>\n}; }
  if (($o{hat}//'') eq 'hard') { $s.=qq{<path d="M}.($x-7.5).' '.($y-40).qq{a7.5 7.5 0 0 1 15 0z" fill="#f7c84a"$st/><rect x="}.($x-8.5).qq{" y="}.($y-41).qq{" width="17" height="2.2" rx="1" fill="#f7c84a"$st/>\n}; }
  $s.=qq{<circle cx="}.($x-2.2).qq{" cy="}.($y-38.5).qq{" r=".8" fill="$INK"/><circle cx="}.($x+2.2).qq{" cy="}.($y-38.5).qq{" r=".8" fill="$INK"/><path d="M}.($x-1.8).' '.($y-36).qq{q1.8 1.6 3.6 0" stroke="$INK" stroke-width=".9" fill="none" stroke-linecap="round"/>\n};
  my $p=$o{prop}//'';
  if ($p eq 'case') { $s.=qq{<rect x="}.($x+8).qq{" y="}.($y-19).qq{" width="9" height="7" rx="1.2" fill="#ff6a6b"$st/><path d="M}.($x+11).' '.($y-19).qq{v-1.5h3v1.5" stroke="$INK" stroke-width="1" fill="none"/>\n}; }
  if ($p eq 'phone') { $s.=qq{<rect x="}.($x+8.5).qq{" y="}.($y-22).qq{" width="3.4" height="5.4" rx=".8" fill="#2b3147"$st/>\n}; }
  if ($p eq 'keys') { $s.=qq{<circle cx="}.($x+10.5).qq{" cy="}.($y-20).qq{" r="2" fill="none" stroke="$INK" stroke-width="1.2"/><path d="M}.($x+12.2).' '.($y-19).qq{l3 2.4M}.($x+14).' '.($y-18.2).qq{l-1 1.2" stroke="$INK" stroke-width="1.2" stroke-linecap="round"/>\n}; }
  if ($p eq 'clipboard') { $s.=qq{<rect x="}.($x-15).qq{" y="}.($y-23).qq{" width="7" height="9" rx="1" fill="#ffffff"$st/><path d="M}.($x-13.5).' '.($y-20).qq{h4M}.($x-13.5).' '.($y-17.5).qq{h4" stroke="$INK" stroke-width=".8"/>\n}; }
  if ($p eq 'saw') { $s.=qq{<path d="M}.($x+9).' '.($y-18).qq{l10 -6 l1.5 2 l-1.5 1.5 l1.5 1.5 l-1.5 1.5 l1.5 1.5 l-8 3z" fill="#d8dbe6"$st/><rect x="}.($x+7.5).qq{" y="}.($y-19.5).qq{" width="3.5" height="4" rx="1" fill="#b9865a"$st/>\n}; }
  return $s; }

sub building { my ($id,$href,$label,$body)=@_; @pts=(); my $inner=$body->(); my ($x0,$y0,$x1,$y1)=(1e9,1e9,-1e9,-1e9); for (@pts){ $x0=$_->[0] if $_->[0]<$x0; $x1=$_->[0] if $_->[0]>$x1; $y0=$_->[1] if $_->[1]<$y0; $y1=$_->[1] if $_->[1]>$y1; }
  my $pad=4; my $vb=sprintf("%.0f %.0f %.0f %.0f",$x0-$pad,$y0-$pad,($x1-$x0)+2*$pad,($y1-$y0)+2*$pad);
  return qq{      <a class="plot" role="listitem" href="$href" data-p="$id" aria-label="$label bridging loans">\n        <svg class="plot-ill" viewBox="$vb" aria-hidden="true">\n$inner        </svg>\n        <span class="plot-btn">$label <span class="arr">&rarr;</span></span>\n      </a>\n\n}; }

unless ($main::NO_RUN) {
my $out = '';
my $cloud = qq{<path d="M20 42c-10-22 22-36 36-20 10-18 44-14 46 8 20-4 30 20 10 26H32c-16 0-20-8-12-14z" fill="#fff" stroke="$INK" stroke-width="2" stroke-linejoin="round"/>};
$out .= qq{  <!-- Illustrated street: one building per product facing the road, every building is a link -->
  <div class="hm-street">
    <div class="street-sky" aria-hidden="true">
      <svg class="cloud cloud-1" viewBox="0 0 124 54">$cloud</svg>
      <svg class="cloud cloud-2" viewBox="0 0 124 54">$cloud</svg>
      <svg class="cloud cloud-3" viewBox="0 0 124 54">$cloud</svg>
    </div>

    <div class="plots" role="list" aria-label="What we lend on">

};

$out .= building('res','/products/residential-bridging-loans','Residential', sub { my $s='';
  $s.=shadow(-12,104,0,56);
  $s.=brickband(0,92,0,56,9);
  $s.=wall(0,92,0,56,9,50,'yellow'); $s.=wall(50,92,0,56,9,50,'blue');
  $s.=roof(0,92,0,56,50,28,6,'red','blue');
  $s.=chimney(70,80,30,40,50,74);
  $s.=wall(10,44,-14,0,0,34,'yellow'); $s.=roofX(10,44,-14,0,34,16,4,'orange','yellow');
  $s.=doorF(-14,20,34,26,'#ff6a6b','none');
  $s.=winF(0,56,72,24,42); $s.=winF(0,78,90,24,42);
  $s.=winS(92,10,26,22,40); $s.=winS(92,36,50,22,40);
  $s.=hedge(52,90,-10,-4,6); $s.=tree(-4,-6,8);
  $s.=person(104,-14, top=>'#f5853a', legs=>'#c9bdf0', hairstyle=>'bun', hair=>'#5a3a2a', prop=>'keys');
  $s; });

$out .= building('auc','/products/auction-bridging-loans','Auction', sub { my $s='';
  $s.=shadow(-12,120,0,54);
  $s.=brickband(0,104,0,54,7);
  $s.=wall(0,104,0,54,7,34,'cream');
  $s.=roof(0,104,0,54,34,24,6,'orange','cream');
  $s.=chimney(22,32,28,38,34,56);
  $s.=winF(0,10,32,12,28); $s.=winF(0,72,94,12,28);
  $s.=doorF(0,44,60,28,'#2b3147','orange');
  $s.=winS(104,10,26,12,28); $s.=winS(104,32,48,12,28);
  $s.=signF(72,110,-16,30,50,'#ff6a6b','AUCTION',8.6);
  $s.=tree(-4,-6,8);
  $s.=person(4,-16, top=>'#6f8df4', legs=>'#2b3147', hairstyle=>'short', prop=>'point');
  $s.=person(30,-18, top=>'#f7c84a', legs=>'#2b3147', hairstyle=>'long', hair=>'#2a2d3e', skin=>'#9a6a4b');
  $s; });

$out .= building('nov','/products/no-valuation-bridging-loans','No valuation', sub { my $s='';
  $s.=shadow(-12,96,0,50);
  $s.=brickband(0,78,0,50,8);
  $s.=wall(0,78,0,50,8,92,'slate');
  for my $row (1..2){ my $h0=14+$row*26; $s.=winF(0,8,24,$h0,$h0+18); $s.=winF(0,31,47,$h0,$h0+18); $s.=winF(0,54,70,$h0,$h0+18); }
  $s.=winF(0,8,24,14,32); $s.=winF(0,54,70,14,32);
  $s.=doorF(0,31,47,32,'#ff6a6b','none');
  $s.=box(26,29,-5,0,0,34,'white'); $s.=box(49,52,-5,0,0,34,'white'); $s.=box(24,54,-6,0,34,38,'white');
  for my $row (0..2){ my $h0=14+$row*26; $s.=winS(78,8,22,$h0,$h0+18); $s.=winS(78,30,44,$h0,$h0+18); }
  $s.=flatroof(0,78,0,50,92,'slate');
  $s.=chimney(10,20,30,40,96,110);
  $s.=lamp(92,-8); $s.=tree(-4,-6,8);
  $s.=person(68,-16, top=>'#c9bdf0', legs=>'#2b3147', hairstyle=>'short', hair=>'#b9865a', prop=>'phone');
  my ($bx,$by)=XY(84,0,104);
  $s.=qq{<g transform="translate($bx $by)"><circle r="17" fill="#fff" stroke="$INK" stroke-width="1.2"/><circle cy="-5" r="6" fill="#5fbcae" stroke="$INK" stroke-width="1"/><path d="M-3 -5l2 2 4-4" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round" stroke-linejoin="round"/><text y="7" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="$INK">NO SITE</text><text y="13" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="$INK">VISIT</text></g>\n};
  push @pts,[$bx-17,$by-17],[$bx+17,$by+17];
  $s; });

$out .= building('ref','/products/refurbishment-bridging-loans','Refurbishment', sub { my $s='';
  $s.=shadow(-12,124,0,54);
  $s.=brickband(0,90,0,54,7);
  $s.=wall(0,90,0,54,7,44,'sage');
  $s.=roof(0,90,0,54,44,26,6,'brown','sage');
  $s.=winF(0,10,30,16,36); $s.=winF(0,62,82,16,36);
  $s.=doorF(0,38,54,30,'#faf0dc','none');
  $s.=winS(90,12,28,16,36);
  for my $u (-2,28,58,88){ $s.=box($u,$u+2.4,-9,-6.6,0,60,'yellowk'); }
  $s.=box(-4,92,-9,-4,22,25,'grey'); $s.=box(-4,92,-9,-4,42,45,'grey'); $s.=box(-3,91,-8,-6,59,61,'yellowk');
  $s.=box(100,120,-12,2,0,16,'yellowk');
  my ($sx,$sy)=XY(110,-5,17); $s.=qq{<ellipse cx="}.sprintf('%.1f',$sx).qq{" cy="}.sprintf('%.1f',$sy).qq{" rx="9" ry="4" fill="#b5b9c9" stroke="$INK" stroke-width="1"/>\n};
  $s.=person(14,-18, top=>'#f5853a', legs=>'#2b3147', hivis=>1, hat=>'hard', hairstyle=>'short', prop=>'saw');
  $s; });

$out .= building('semi','/products/semi-commercial-bridging-loans','Semi-commercial', sub { my $s='';
  $s.=shadow(-12,112,0,54);
  $s.=wall(0,100,0,54,0,66,'cream');
  $s.=winF(0,10,30,42,58); $s.=winF(0,40,60,42,58); $s.=winF(0,70,90,42,58);
  $s.=box(0,100,-2,0,28,36,'navy');
  $s.=textF(50,-2.3,29.6,'CORNER SHOP',6.8,'#fff','middle');
  $s.=poly('#ffffff','',P(4,-0.5,2),P(62,-0.5,2),P(62,-0.5,26),P(4,-0.5,26));
  $s.=poly($M{glass}[1],'',P(6,-1,4),P(60,-1,4),P(60,-1,24),P(6,-1,24));
  $s.=poly('#f7c84a','',P(10,-1.2,6),P(22,-1.2,6),P(22,-1.2,14),P(10,-1.2,14)); $s.=poly('#ff6a6b','',P(26,-1.2,6),P(40,-1.2,6),P(40,-1.2,12),P(26,-1.2,12)); $s.=poly('#7fcf6a','',P(44,-1.2,6),P(56,-1.2,6),P(56,-1.2,16),P(44,-1.2,16));
  $s.=doorF(0,70,88,26,'#2b3147','none');
  for my $i (0..7){ my $u0=2+$i*12; my $f=$i%2?'#ffffff':'#ff6a6b'; $s.=poly($f,'',P($u0,0,27),P($u0+12,0,27),P($u0+12,-9,22),P($u0,-9,22)); }
  $s.=poly('#ffffff','',P(2,-9,22),P(98,-9,22),P(98,-9,19.5),P(2,-9,19.5));
  $s.=winS(100,10,28,42,58);
  $s.=flatroof(0,100,0,54,66,'cream');
  $s.=chimney(74,84,30,40,70,82);
  $s.=person(104,-14, top=>'#6f8df4', legs=>'#2b3147', apron=>1, hairstyle=>'short', hair=>'#2a2d3e', skin=>'#9a6a4b');
  $s; });

$out .= building('com','/products/commercial-bridging-loans','Commercial', sub { my $s='';
  $s.=shadow(-12,126,0,60);
  $s.=wall(0,90,0,60,0,104,'peri');
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..3){ my $u0=5+$c*21; next if $row==0 && ($c==1||$c==2); $s.=winF(0,$u0,$u0+15,$h0,$h0+16); } }
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..2){ my $v0=6+$c*18; $s.=winS(90,$v0,$v0+12,$h0,$h0+16); } }
  $s.=doorF(0,28,62,24,'#2b3147','none');
  $s.=box(22,68,-7,0,24,27,'white');
  $s.=flatroof(0,90,0,60,104,'white');
  $s.=box(8,22,36,48,108,116,'grey');
  my ($fx,$fy)=XY(70,10,108); $s.=qq{<line x1="$fx" y1="$fy" x2="$fx" y2="}.($fy-22).qq{" stroke="$INK" stroke-width="1.5"/><path d="M$fx }.($fy-22).qq{h10l-3 4 3 4h-10z" fill="#ff6a6b" stroke="$INK" stroke-width="1"/>\n};
  push @pts,[$fx+12,$fy-24];
  $s.=tree(-4,-6,8); $s.=car(96,-12,'yellow');
  $s.=person(78,-18, top=>'#2b3147', legs=>'#2b3147', hairstyle=>'short', prop=>'case');
  $s; });

$out .= building('adv','/products/bad-credit-bridging-loans','Adverse credit', sub { my $s='';
  $s.=shadow(-12,116,0,54);
  $s.=wall(0,88,0,54,0,40,'brick');
  $s.=roof(0,88,0,54,40,30,6,'tealr','brick');
  $s.=chimney(60,70,30,40,42,64);
  $s.=winF(0,10,30,14,32); $s.=winF(0,58,78,14,32);
  $s.=doorF(0,36,52,30,'#5fbcae','orange');
  $s.=winS(88,12,28,14,32);
  $s.=signF(58,100,-16,32,52,'#5fbcae','APPROVED',8);
  $s.=tree(-4,-6,8);
  $s.=person(16,-16, top=>'#ff6a6b', legs=>'#2b3147', hairstyle=>'long', hair=>'#5a3a2a', prop=>'keys');
  $s.=person(104,-14, top=>'#f7c84a', legs=>'#c9bdf0', hairstyle=>'short', hair=>'#2a2d3e', skin=>'#9a6a4b', prop=>'clipboard');
  $s; });

$out .= qq{    </div>
  </div>
};
open my $o,'>:raw',$ARGV[0] or die; print $o $out; close $o; print "written ", length($out), " bytes\n";
}
1;
