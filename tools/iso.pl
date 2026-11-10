use strict; use warnings;
# Flat outlined street generator for af.credit (v5): bespoke details, posed people, fitted sign text.
our ($DX,$DY) = (0.52, 0.30);
our $INK = '#1f1f24';
our @pts;
sub P { my ($u,$v,$h)=@_; my $x=$u+$v*$DX; my $y=-$h-$v*$DY; push @pts,[$x,$y]; return sprintf("%.1f,%.1f",$x,$y); }
sub XY { my ($u,$v,$h)=@_; return ($u+$v*$DX, -$h-$v*$DY); }
sub r1 { return sprintf('%.1f',$_[0]); }
sub poly { my ($fill,$extra,@p)=@_; $extra//=''; my $st = ($extra =~ /nostroke/) ? '' : qq{ stroke="$INK" stroke-width="1.1" stroke-linejoin="round"}; $extra =~ s/ ?nostroke//; return qq{<polygon points="}.join(' ',@p).qq{" fill="$fill"$st$extra/>\n}; }
sub line { my ($extra,@p)=@_; return qq{<path d="M}.join(' L',@p).qq{" fill="none" stroke="$INK" stroke-width="1" stroke-linecap="round"$extra/>\n}; }

our %M = (
  yellow=>['#f3e6cf','#ead9bc','#d4c2a3'], blue=>['#8fd0c3','#5fb2a2','#3f8a7c'], cream=>['#fbf6ec','#f4ecdc','#e3d6bf'],
  sage=>['#cfe9e2','#b3dcd2','#8fc3b7'], slate=>['#e7eef6','#dbe7f3','#b9cde3'], brick=>['#ead9bc','#d4c2a3','#b9a584'],
  teal=>['#8fd0c3','#5fb2a2','#3f8a7c'], glass=>['#eef4fa','#e3eef8','#c4d6e8'], navy=>['#2a2a33','#1f1f24','#141418'],
  white=>['#ffffff','#ffffff','#eef3f8'], green=>['#b3dcd2','#8fd0c3','#5fb2a2'], yellowk=>['#f3e6cf','#ead9bc','#d4c2a3'],
  grey=>['#eef3f8','#e3eef8','#b9cde3'], coral=>['#ff8a8a','#ff6a6b','#d94f52'], orange=>['#5c7290','#3d4e63','#2f3e50'],
  hedge=>['#b3dcd2','#8fd0c3','#5fb2a2'], lilac=>['#e7eef6','#dbe7f3','#b9cde3'], peri=>['#7a8fab','#5c7290','#3d4e63'],
);
our %ROOF = ( red=>['#5c7290','#3d4e63'], orange=>['#3d4e63','#2f3e50'], tealr=>['#5fb2a2','#3f8a7c'], slater=>['#b9cde3','#9fb3c9'], brown=>['#b9a584','#9c8a6c'], plum=>['#3d4e63','#2f3e50'], peri=>['#5c7290','#3d4e63'] );
sub defs { return qq{<svg width="0" height="0" style="position:absolute" aria-hidden="true" focusable="false"><defs><pattern id="hatch" width="3.2" height="3.2" patternUnits="userSpaceOnUse" patternTransform="rotate(45)"><line x1="0" y1="0" x2="0" y2="3.2" stroke="#1f1f24" stroke-width=".55" opacity=".32"/></pattern><filter id="sketch" x="-3%" y="-3%" width="106%" height="106%"><feTurbulence type="fractalNoise" baseFrequency="0.045" numOctaves="2" seed="7" result="n"/><feDisplacementMap in="SourceGraphic" in2="n" scale="1.7" xChannelSelector="R" yChannelSelector="G"/></filter></defs></svg>\n}; }

sub box { my ($u0,$u1,$v0,$v1,$h0,$h1,$m)=@_; my ($t,$f,$sd)=@{$M{$m}}; my $s='';
  $s.=poly($t,'',P($u0,$v0,$h1),P($u1,$v0,$h1),P($u1,$v1,$h1),P($u0,$v1,$h1));
  $s.=poly($sd,'',P($u1,$v0,$h0),P($u1,$v1,$h0),P($u1,$v1,$h1),P($u1,$v0,$h1));
  $s.=poly($f,'',P($u0,$v0,$h0),P($u1,$v0,$h0),P($u1,$v0,$h1),P($u0,$v0,$h1));
  return $s; }
sub wall { my @a=@_; return box(@a[0..6]); }
sub shadow { my ($u0,$u1,$v0,$v1)=@_; my ($cx,$cy)=XY(($u0+$u1)/2,($v0+$v1)/2,0); my $rx=($u1-$u0)*0.55; push @pts,[$cx-$rx,$cy-6],[$cx+$rx,$cy+8]; return qq{<ellipse cx="}.r1($cx).qq{" cy="}.r1($cy+2).qq{" rx="$rx" ry="7" fill="$INK" opacity=".10"/>\n}; }
sub plinth { my ($u0,$u1,$v0,$v1,$th)=@_; my $s=''; my ($cx,$cy)=XY(($u0+$u1)/2,($v0+$v1)/2,-$th); $s.=qq{<ellipse cx="}.r1($cx).qq{" cy="}.r1($cy+4).qq{" rx="}.(($u1-$u0)*0.6).qq{" ry="10" fill="$INK" opacity=".10"/>\n}; $s.=box($u0,$u1,$v0,$v1,-$th,0,'green'); return $s; }

sub roof { my ($u0,$u1,$v0,$v1,$h,$R,$o,$col,$m)=@_; my $vm=($v0+$v1)/2; my ($f,$b)=@{$ROOF{$col}}; my $s='';
  $s.=poly($b,'',P($u0-$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R),P($u1+$o,$v1+$o,$h),P($u0-$o,$v1+$o,$h));
  $s.=poly($M{$m}[2],'',P($u1,$v0,$h-1),P($u1,$v1,$h-1),P($u1,$vm,$h+$R-1));
  $s.=poly($f,'',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  my $n=int(($u1-$u0+2*$o)/9); for my $i (1..$n-1){ my $u=$u0-$o+($u1-$u0+2*$o)*$i/$n; $s.=line(' opacity=".55"',P($u,$v0-$o,$h),P($u,$vm,$h+$R)); }
  $s.=poly('#ffffff','',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h-3),P($u0-$o,$v0-$o,$h-3));
  $s.=poly('#ffffff','',P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3),P($u1+$o,$v0-$o,$h-3));
  $s.=poly('#eef3f8','',P($u1+$o,$v1+$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3),P($u1+$o,$v1+$o,$h-3));
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

# front window; optional curtain colour and flower box
sub winF { my ($v,$u0,$u1,$h0,$h1,%o)=@_; my $s='';
  $s.=poly('#ffffff','',P($u0-1.5,$v-0.6,$h0-1.5),P($u1+1.5,$v-0.6,$h0-1.5),P($u1+1.5,$v-0.6,$h1+1.5),P($u0-1.5,$v-0.6,$h1+1.5));
  $s.=poly($M{glass}[1],'',P($u0,$v-0.8,$h0),P($u1,$v-0.8,$h0),P($u1,$v-0.8,$h1),P($u0,$v-0.8,$h1));
  if ($o{curtain}) { my $w=($u1-$u0)*0.22; $s.=poly($o{curtain},' nostroke',P($u0,$v-0.85,$h0),P($u0+$w,$v-0.85,$h0),P($u0+$w*0.7,$v-0.85,$h1),P($u0,$v-0.85,$h1)); $s.=poly($o{curtain},' nostroke',P($u1-$w,$v-0.85,$h0),P($u1,$v-0.85,$h0),P($u1,$v-0.85,$h1),P($u1-$w*0.7,$v-0.85,$h1)); }
  if ($o{lamp}) { my ($lx,$ly)=XY(($u0+$u1)/2,$v-0.9,$h0+($h1-$h0)*0.45); $s.=qq{<path d="M}.($lx-3).' '.$ly.qq{h6l-1.2 -4h-3.6z" fill="#f3e6cf" stroke="$INK" stroke-width=".9"/><rect x="}.($lx-0.6).qq{" y="$ly" width="1.2" height="3" fill="$INK"/>\n}; }
  my $um=($u0+$u1)/2; my $hm=($h0+$h1)/2; $s.=line('',P($um,$v-0.9,$h0),P($um,$v-0.9,$h1)); $s.=line('',P($u0,$v-0.9,$hm),P($u1,$v-0.9,$hm));
  $s.=poly('#ffffff','',P($u0-2.5,$v-2.6,$h0-2.4),P($u1+2.5,$v-2.6,$h0-2.4),P($u1+2.5,$v-0.6,$h0-1.5),P($u0-2.5,$v-0.6,$h0-1.5));
  if ($o{flowers}) { $s.=box($u0-1,$u1+1,$v-4,$v-0.6,$h0-6,$h0-2.6,'brick'); for my $i (0..3){ my $uu=$u0+($u1-$u0)*(0.12+0.25*$i); my ($fx,$fy)=XY($uu,$v-4.2,$h0-1.6); my $c=$i%2?'#5c7290':'#ead9bc'; $s.=qq{<circle cx="}.r1($fx).qq{" cy="}.r1($fy).qq{" r="1.7" fill="$c" stroke="$INK" stroke-width=".8"/>\n}; } }
  return $s; }
sub winS { my ($u,$v0,$v1,$h0,$h1)=@_; my $s='';
  $s.=poly('#ffffff','',P($u+0.6,$v0-1.5,$h0-1.5),P($u+0.6,$v1+1.5,$h0-1.5),P($u+0.6,$v1+1.5,$h1+1.5),P($u+0.6,$v0-1.5,$h1+1.5));
  $s.=poly($M{glass}[2],'',P($u+0.8,$v0,$h0),P($u+0.8,$v1,$h0),P($u+0.8,$v1,$h1),P($u+0.8,$v0,$h1));
  my $vm=($v0+$v1)/2; my $hm=($h0+$h1)/2; $s.=line('',P($u+0.9,$vm,$h0),P($u+0.9,$vm,$h1)); $s.=line('',P($u+0.9,$v0,$hm),P($u+0.9,$v1,$hm));
  return $s; }
sub doorF { my ($v,$u0,$u1,$h1,$fill,$canopy,%o)=@_; $fill//='#5c7290'; $canopy//='orange'; my $s='';
  $s.=poly('#ffffff','',P($u0-1.5,$v-0.6,0),P($u1+1.5,$v-0.6,0),P($u1+1.5,$v-0.6,$h1+1.5),P($u0-1.5,$v-0.6,$h1+1.5));
  $s.=poly($fill,'',P($u0,$v-0.8,0),P($u1,$v-0.8,0),P($u1,$v-0.8,$h1),P($u0,$v-0.8,$h1));
  if ($o{glass}) { $s.=poly($M{glass}[1],'',P($u0+2.5,$v-0.9,$h1*.55),P($u1-2.5,$v-0.9,$h1*.55),P($u1-2.5,$v-0.9,$h1-3),P($u0+2.5,$v-0.9,$h1-3)); }
  else { $s.=line(' opacity=".5"',P($u0+2.5,$v-0.9,$h1-3),P($u1-2.5,$v-0.9,$h1-3),P($u1-2.5,$v-0.9,$h1*.5),P($u0+2.5,$v-0.9,$h1*.5),P($u0+2.5,$v-0.9,$h1-3)); }
  my ($kx,$ky)=XY($u1-2.2,$v-0.9,$h1*.42); $s.=qq{<circle cx="}.r1($kx).qq{" cy="}.r1($ky).qq{" r="1.1" fill="$INK"/>\n};
  if ($o{number}) { my ($nx,$ny)=XY($u1+5,$v-0.9,$h1*.8); $s.=qq{<text x="}.r1($nx).qq{" y="}.r1($ny).qq{" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5" fill="$INK">$o{number}</text>\n}; }
  $s.=box($u0-3,$u1+3,$v-8,$v,$h1+2,$h1+4.5,$canopy) if $canopy ne 'none';
  $s.=box($u0-2,$u1+2,$v-5,$v-1,0,2.2,'white');
  $s.=poly('#dbe7f3','',P($u0-1,$v-6.5,0.1),P($u1+1,$v-6.5,0.1),P($u1+1,$v-9,0.1),P($u0-1,$v-9,0.1)) if $o{mat};
  return $s; }
sub tree { my ($u,$v,$sz)=@_; my ($x,$y)=XY($u,$v,0); push @pts,[$x-$sz*0.9,$y-$sz*2.7],[$x+$sz*0.9,$y+4]; my $s='';
  $s.=qq{<ellipse cx="$x" cy="}.($y+1).qq{" rx="}.($sz*0.7).qq{" ry="}.($sz*0.25).qq{" fill="$INK" opacity=".10"/>\n};
  $s.=qq{<rect x="}.($x-$sz*0.14).qq{" y="}.($y-$sz*1.1).qq{" width="}.($sz*0.28).qq{" height="}.($sz*1.1).qq{" fill="#b9a584" stroke="$INK" stroke-width="1"/>\n};
  $s.=qq{<ellipse cx="$x" cy="}.($y-$sz*1.7).qq{" rx="}.($sz*0.8).qq{" ry="}.($sz*0.9).qq{" fill="#8fd0c3" stroke="$INK" stroke-width="1.1"/>\n};
  $s.=qq{<ellipse cx="}.($x-$sz*0.25).qq{" cy="}.($y-$sz*1.95).qq{" rx="}.($sz*0.3).qq{" ry="}.($sz*0.32).qq{" fill="#b3dcd2"/>\n};
  $s.=qq{<path d="M}.($x+$sz*0.1).' '.($y-$sz*1.4).qq{q}.($sz*0.4).qq{ 0 }.($sz*0.5).' '.(-$sz*0.5).qq{" fill="none" stroke="$INK" stroke-width=".8" opacity=".5"/>\n};
  return $s; }
sub hedge { my ($u0,$u1,$v0,$v1,$h)=@_; my $s=box($u0,$u1,$v0,$v1,0,$h,'hedge'); for my $i (0..int(($u1-$u0)/9)){ my ($bx,$by)=XY($u0+4+$i*9,$v0-0.2,$h*0.5); $s.=qq{<circle cx="}.r1($bx).qq{" cy="}.r1($by).qq{" r="1.2" fill="#5fb2a2"/>\n}; } return $s; }
sub lamp { my ($u,$v)=@_; my $s=box($u-1.2,$u+1.2,$v-1.2,$v+1.2,0,34,'grey'); my ($x,$y)=XY($u,$v,36); $s.=qq{<circle cx="}.r1($x).qq{" cy="}.r1($y).qq{" r="3.6" fill="#f3e6cf" stroke="$INK" stroke-width="1"/><circle cx="}.r1($x).qq{" cy="}.r1($y-3.6).qq{" r="2.2" fill="$INK"/>\n}; push @pts,[$x,$y-8]; return $s; }
sub bin { my ($u,$v,$m)=@_; $m//='navy'; my $s=box($u,$u+8,$v,$v+6,0,10,$m); $s.=box($u-0.8,$u+8.8,$v-0.8,$v+6.8,10,11.6,'grey'); return $s; }
sub bike { my ($u,$v)=@_; my ($x,$y)=XY($u,$v,0); push @pts,[$x-14,$y-14],[$x+14,$y+2]; my $st=qq{ stroke="$INK" stroke-width="1.1" fill="none"}; return qq{<circle cx="}.($x-8).qq{" cy="}.($y-5).qq{" r="5"$st/><circle cx="}.($x+8).qq{" cy="}.($y-5).qq{" r="5"$st/><path d="M}.($x-8).' '.($y-5).qq{l5 -7h6l5 7M}.($x-3).' '.($y-12).qq{l3 7l-1 -7M}.($x+3).' '.($y-12).qq{l-1 -2h3M}.($x-4).' '.($y-13.5).qq{h3"$st/>\n}; }
sub smoke { my ($u,$v,$h)=@_; my ($x,$y)=XY($u,$v,$h); push @pts,[$x-6,$y-16],[$x+8,$y]; my $s=''; for my $i (0..2){ my $r=2+$i*0.8; my $cx=$x+$i*2.6; my $cy=$y-3-$i*4.6; $s.=qq{<circle cx="}.r1($cx).qq{" cy="}.r1($cy).qq{" r="$r" fill="#fff" stroke="$INK" stroke-width=".9" opacity="}.(0.9-$i*0.22).qq{"/>\n}; } return $s; }
sub bird { my ($x,$y)=@_; push @pts,[$x-4,$y-3],[$x+4,$y+1]; return qq{<path d="M}.($x-4).' '.$y.qq{q2 -3 4 0q2 -3 4 0" fill="none" stroke="$INK" stroke-width="1" stroke-linecap="round"/>\n}; }
sub car { my ($u,$v,$m)=@_; $m//='coral'; my $s=''; $s.=shadow($u-2,$u+28,$v,$v+12);
  $s.=box($u,$u+26,$v,$v+12,2,8,$m); $s.=box($u+6,$u+19,$v+1,$v+11,8,14,'glass');
  my ($x1,$y1)=XY($u+6,$v-0.5,2.5); my ($x2,$y2)=XY($u+20,$v-0.5,2.5); $s.=qq{<circle cx="$x1" cy="$y1" r="3.6" fill="$INK"/><circle cx="$x2" cy="$y2" r="3.6" fill="$INK"/><circle cx="$x1" cy="$y1" r="1.5" fill="#e3eef8"/><circle cx="$x2" cy="$y2" r="1.5" fill="#e3eef8"/>\n};
  $s.=poly('#f3e6cf','',P($u+26,$v+1.5,4.5),P($u+26,$v+4.5,4.5),P($u+26,$v+4.5,6.5),P($u+26,$v+1.5,6.5));
  return $s; }
sub chimney { my ($u0,$u1,$v0,$v1,$h0,$h1)=@_; return box($u0,$u1,$v0,$v1,$h0,$h1,'white').box($u0-1,$u1+1,$v0-1,$v1+1,$h1,$h1+2.5,'grey'); }
sub textF { my ($u,$v,$h,$txt,$size,$fill,$anchor,$fit)=@_; $anchor//='start'; my ($x,$y)=XY($u,$v,$h); my $tl=$fit?qq{ textLength="$fit" lengthAdjust="spacingAndGlyphs"}:''; return qq{<text x="}.r1($x).qq{" y="}.r1($y).qq{" text-anchor="$anchor" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="$size" fill="$fill" letter-spacing=".04em"$tl>$txt</text>\n}; }
sub signF { my ($u0,$u1,$v,$h0,$h1,$fill,$txt,$size)=@_; my $s=box($u0+2,$u0+4.4,$v,$v+2.4,0,$h0+2,'grey'); $s.=box($u0,$u1,$v,$v+1.6,$h0,$h1,'white'); $s.=poly($fill,'',P($u0+1.5,$v-0.3,$h0+1.5),P($u1-1.5,$v-0.3,$h0+1.5),P($u1-1.5,$v-0.3,$h1-1.5),P($u0+1.5,$v-0.3,$h1-1.5)); $s.=textF(($u0+$u1)/2,$v-0.6,$h0+($h1-$h0)/2-3,$txt,$size,'#fff','middle',($u1-$u0-8)); return $s; }
sub brickband { my ($u0,$u1,$v0,$v1,$h)=@_; my $s=wall($u0,$u1,$v0,$v1,0,$h,'brick'); for my $i (1..2){ my $hh=$h*$i/3; $s.=line(' opacity=".45"',P($u0,$v0-0.2,$hh),P($u1,$v0-0.2,$hh)); } my $n=int(($u1-$u0)/10); for my $i (0..$n){ my $uu=$u0+5+$i*10; $s.=line(' opacity=".35"',P($uu,$v0-0.2,0),P($uu,$v0-0.2,$h/3)); $s.=line(' opacity=".35"',P($uu+5,$v0-0.2,$h/3),P($uu+5,$v0-0.2,2*$h/3)) if $uu+5<$u1; } return $s; }
sub drainpipe { my ($u,$v,$h)=@_; return line(' stroke-width="1.6"',P($u,$v-1,0),P($u,$v-1,$h)); }

# front-facing flat person. opts: top, legs, skin, hair, hairstyle(short|bun|long), hat(hard), apron, hivis, prop(point|hifive-r|hifive-l|case|phone|keys|clipboard|saw|cash|paper), delay
sub person { my ($u,$v,%o)=@_; my $top=$o{top}//'#5fb2a2'; my $legs=$o{legs}//'#1f1f24'; my $skin=$o{skin}//'#f3c9a6'; my $hair=$o{hair}//'#1f1f24'; my ($x,$y)=XY($u,$v,0); my $s=''; my $st=qq{ stroke="$INK" stroke-width="1.1" stroke-linejoin="round"}; my $p=$o{prop}//''; my $d=$o{delay}//0;
  push @pts,[$x-20,$y-52],[$x+22,$y+3];
  $s.=qq{<ellipse cx="$x" cy="}.($y+1).qq{" rx="7" ry="2.2" fill="$INK" opacity=".12"/>\n};
  $s.=qq{<!--P--><g class="person" style="animation-delay:${d}s">\n};
  $s.=qq{<rect x="}.($x-4.6).qq{" y="}.($y-15).qq{" width="4" height="15" rx="1.5" fill="$legs"$st/><rect x="}.($x+0.6).qq{" y="}.($y-15).qq{" width="4" height="15" rx="1.5" fill="$legs"$st/>\n};
  $s.=qq{<rect x="}.($x-5.4).qq{" y="}.($y-1.5).qq{" width="5.2" height="2.6" rx="1.2" fill="$INK"/><rect x="}.($x+0.2).qq{" y="}.($y-1.5).qq{" width="5.2" height="2.6" rx="1.2" fill="$INK"/>\n};
  $s.=qq{<rect x="}.($x-6.5).qq{" y="}.($y-31).qq{" width="13" height="17" rx="4" fill="$top"$st/>\n};
  if ($o{apron}) { $s.=qq{<path d="M}.($x-4).' '.($y-30).qq{h8v14h-8z" fill="#ffffff"$st/><path d="M}.($x-4).' '.($y-30).qq{l-2 -1M}.($x+4).' '.($y-30).qq{l2 -1" stroke="$INK" stroke-width="1"/>\n}; }
  if ($o{hivis}) { $s.=qq{<path d="M}.($x-6.5).' '.($y-24).qq{h13M}.($x-6.5).' '.($y-20).qq{h13" stroke="#f3e6cf" stroke-width="2"/>\n}; }
  my $army=$y-29;
  # arm builders: ($dx,$dy) = hand offset from the shoulder; returns path + hand
  my $armr = sub { my ($dx,$dy,$r)=@_; $r//=2.3; return qq{<path d="M}.($x+6).' '.$army.qq{l$dx $dy" stroke="$top" stroke-width="4" stroke-linecap="round"/><circle cx="}.($x+6+$dx).qq{" cy="}.($army+$dy).qq{" r="$r" fill="$skin"$st/>}; };
  my $arml = sub { my ($dx,$dy,$r)=@_; $r//=2.3; return qq{<path d="M}.($x-6).' '.$army.qq{l$dx $dy" stroke="$top" stroke-width="4" stroke-linecap="round"/><circle cx="}.($x-6+$dx).qq{" cy="}.($army+$dy).qq{" r="$r" fill="$skin"$st/>}; };
  my ($hx,$hy)=($x+9.4,$army+10.6); # default right hand
  my $props = {
    keys  => sub { my ($px,$py)=@_; qq{<circle cx="}.($px+1).qq{" cy="}.($py-1.5).qq{" r="2" fill="none" stroke="$INK" stroke-width="1.2"/><path d="M}.($px+2.7).' '.($py-0.5).qq{l3 2.4M}.($px+4.5).' '.($py+0.3).qq{l-1 1.2" stroke="$INK" stroke-width="1.2" stroke-linecap="round"/>}; },
    phone => sub { my ($px,$py)=@_; qq{<rect x="}.($px-0.8).qq{" y="}.($py-4.2).qq{" width="3.4" height="5.6" rx=".8" fill="#1f1f24"$st/>}; },
    case  => sub { my ($px,$py)=@_; qq{<rect x="}.($px-1).qq{" y="}.($py).qq{" width="12" height="9" rx="1.4" fill="#1f1f24"$st/><path d="M}.($px+3).' '.($py).qq{v-2h4v2" stroke="$INK" stroke-width="1.1" fill="none"/><rect x="}.($px+3.5).qq{" y="}.($py+3.5).qq{" width="3" height="2" fill="#5c7290" stroke="$INK" stroke-width=".7"/>}; },
    saw   => sub { my ($px,$py)=@_; qq{<path d="M}.($px-0.5).' '.($py+0.5).qq{l10 -6 l1.5 2 l-1.5 1.5 l1.5 1.5 l-1.5 1.5 l1.5 1.5 l-8 3z" fill="#e3eef8"$st/><rect x="}.($px-2).qq{" y="}.($py-1).qq{" width="3.5" height="4" rx="1" fill="#b9a584"$st/>}; },
    cash  => sub { my ($px,$py)=@_; qq{<g transform="rotate(-18 $px $py)"><rect x="}.($px-2).qq{" y="}.($py-5).qq{" width="14" height="7" rx="1" fill="#8fd0c3"$st/><circle cx="}.($px+5).qq{" cy="}.($py-1.5).qq{" r="2" fill="#b3dcd2" stroke="$INK" stroke-width=".8"/><text x="}.($px+5).qq{" y="}.($py-0.1).qq{" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="3.4" fill="$INK">£</text></g>}; },
  };
  if ($p eq 'hifive-r' || $p eq 'hifive-l') {
    my $L = $p eq 'hifive-l' ? qq{<g class="arm-hi-l">}.$arml->(-7,-13,2.6).qq{</g>} : qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g>};
    my $R = $p eq 'hifive-r' ? qq{<g class="arm-hi-r">}.$armr->(7,-13,2.6).qq{</g>} : qq{<g class="arm-idle-r">}.$armr->(3,10).qq{</g>};
    $s.=$L.$R."\n"; }
  elsif ($p eq 'paper' || $p eq 'clipboard' || $p eq 'plan') {
    my $sheet = $p eq 'plan'
      ? qq{<rect x="}.($x-7).qq{" y="}.($y-26).qq{" width="14" height="11" rx="1" fill="#fbf6ec"$st/><path d="M}.($x-4).' '.($y-18).qq{v-4l4 -3 4 3v4z" fill="none" stroke="$INK" stroke-width=".9" stroke-linejoin="round"/><path d="M}.($x-1).' '.($y-18).qq{v-2h2v2" fill="none" stroke="$INK" stroke-width=".8"/><path d="M}.($x-5.5).' '.($y-24).qq{h3M}.($x+2.5).' '.($y-24).qq{h3" stroke="$INK" stroke-width=".7" opacity=".6"/>}
      : $p eq 'paper'
      ? qq{<rect x="}.($x-5.5).qq{" y="}.($y-25).qq{" width="11" height="13" rx="1" fill="#ffffff"$st/>}.join('', map { my $ty=$y-22+$_*3.6; qq{<path d="M}.($x-3.8).' '.$ty.qq{l1.2 1.2 2.2-2.4" stroke="#3f8a7c" stroke-width="1.2" fill="none" stroke-linecap="round" stroke-linejoin="round"/><path d="M}.($x+0.8).' '.($ty+0.2).qq{h3.6" stroke="$INK" stroke-width=".8" opacity=".6"/>} } 0..2)
      : qq{<rect x="}.($x-5).qq{" y="}.($y-24).qq{" width="10" height="12" rx="1" fill="#ffffff"$st/><rect x="}.($x-2).qq{" y="}.($y-25.5).qq{" width="4" height="2.4" rx=".6" fill="#1f1f24"/><path d="M}.($x-3).' '.($y-19).qq{h6M}.($x-3).' '.($y-16).qq{h6" stroke="$INK" stroke-width=".8"/>};
    $s.=qq{<g class="act-raise">}.$arml->(4,7).$armr->(-4,7).$sheet.qq{</g>\n}; }
  elsif ($p eq 'cash') {
    $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-cash">}.$armr->(8,-6).$props->{cash}->($x+14,$army-6).qq{</g>\n}; }
  elsif ($p eq 'phone') {
    $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-phone">}.$armr->(3,10).$props->{phone}->($hx,$hy).qq{</g>\n}; }
  elsif ($p eq 'keys') {
    $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-keys">}.$armr->(6,-9).$props->{keys}->($x+12,$army-9).qq{</g>\n}; }
  elsif ($p eq 'thumbs') {
    my ($fx,$fy)=($x+6+7,$army-8);
    $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-thumbs">}.$armr->(7,-8,2.9).qq{<rect x="}.($fx-0.6).qq{" y="}.($fy-7.2).qq{" width="2.4" height="5" rx="1.2" fill="$skin"$st/></g>\n}; }
  elsif ($p eq 'saw') {
    $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-saw">}.$armr->(4,9).$props->{saw}->($x+10,$army+9).qq{</g>\n}; }
  elsif ($p eq 'case') {
    $s.=qq{<g class="act-watch">}.$arml->(-3,10).qq{<circle cx="}.($x-9.4).qq{" cy="}.($army+8.2).qq{" r="1.4" fill="#f3e6cf" stroke="$INK" stroke-width=".8"/></g><g class="act-case">}.$armr->(3,10).$props->{case}->($hx-1,$hy+1).qq{</g>\n}; }
  else { $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="arm-idle-r">}.$armr->(3,10).qq{</g>\n}; }
  # head
  $s.=qq{<rect x="}.($x-1.6).qq{" y="}.($y-34).qq{" width="3.2" height="4" fill="$skin"/>\n};
  $s.=qq{<circle cx="$x" cy="}.($y-39).qq{" r="6.5" fill="$skin"$st/>\n};
  my $hs=$o{hairstyle}//'short';
  if ($hs eq 'short' || $hs eq 'bun') { $s.=qq{<path d="M}.($x-6.3).' '.($y-40).qq{a6.4 6.4 0 0 1 12.6 0 q-3 -2.4 -6.3 -2.4 q-3.3 0 -6.3 2.4z" fill="$hair"$st/>\n}; }
  if ($hs eq 'bun') { $s.=qq{<circle cx="}.($x+5).qq{" cy="}.($y-45).qq{" r="2.6" fill="$hair"$st/>\n}; }
  if ($hs eq 'long') { $s.=qq{<path d="M}.($x-6.6).' '.($y-39).qq{a6.6 6.6 0 0 1 13.2 0 l1 8 h-3 l-1 -6 q-3.6 -2 -7.2 0 l-1 6 h-3z" fill="$hair"$st/>\n}; }
  if ($hs eq 'curly') { for my $i (-2..2){ $s.=qq{<circle cx="}.($x+$i*2.6).qq{" cy="}.($y-44.5+abs($i)*0.9).qq{" r="2.4" fill="$hair"$st/>\n}; } }
  if (($o{hat}//'') eq 'hard') { $s.=qq{<path d="M}.($x-7.5).' '.($y-40).qq{a7.5 7.5 0 0 1 15 0z" fill="#ead9bc"$st/><rect x="}.($x-8.5).qq{" y="}.($y-41).qq{" width="17" height="2.2" rx="1" fill="#ead9bc"$st/>\n}; }
  $s.=qq{<circle cx="}.($x-2.2).qq{" cy="}.($y-38.5).qq{" r=".8" fill="$INK"/><circle cx="}.($x+2.2).qq{" cy="}.($y-38.5).qq{" r=".8" fill="$INK"/><path d="M}.($x-1.8).' '.($y-36).qq{q1.8 1.6 3.6 0" stroke="$INK" stroke-width=".9" fill="none" stroke-linecap="round"/>\n};
  $s.=qq{</g>\n};
  my $oR=qq{ style="transform-origin:}.($x+6).qq{px ${army}px"}; my $oL=qq{ style="transform-origin:}.($x-6).qq{px ${army}px"};
  $s =~ s{<g class="(arm-idle-r|arm-hi-r|act-keys|act-phone|act-saw|act-cash|act-case|act-thumbs)">}{<g class="$1"$oR>}g;
  $s =~ s{<g class="(arm-idle-l|arm-hi-l|act-watch)">}{<g class="$1"$oL>}g;
  return $s; }
sub clap { my ($x,$y)=@_; push @pts,[$x-6,$y-6],[$x+6,$y+6]; return qq{<g class="clap"><path d="M$x }.($y-6).qq{v3M$x }.($y+3).qq{v3M}.($x-6).qq{ $y h3M}.($x+3).qq{ $y h3M}.($x-4.2).' '.($y-4.2).qq{l2 2M}.($x+2.2).' '.($y+2.2).qq{l2 2M}.($x+4.2).' '.($y-4.2).qq{l-2 2M}.($x-2.2).' '.($y+2.2).qq{l-2 2" stroke="#3d4e63" stroke-width="1.4" stroke-linecap="round"/></g>\n}; }

no warnings 'redefine';
# ── artistic overrides: hatching, tiles, bricks, mullions, panelled doors, ornate lamps, layered trees ──
sub box { my ($u0,$u1,$v0,$v1,$h0,$h1,$m,$nohatch)=@_; my ($t,$f,$sd)=@{$M{$m}}; my $s='';
  $s.=poly($t,'',P($u0,$v0,$h1),P($u1,$v0,$h1),P($u1,$v1,$h1),P($u0,$v1,$h1));
  $s.=poly($sd,'',P($u1,$v0,$h0),P($u1,$v1,$h0),P($u1,$v1,$h1),P($u1,$v0,$h1));
  $s.=poly('url(#hatch)',' nostroke',P($u1,$v0,$h0),P($u1,$v1,$h0),P($u1,$v1,$h1),P($u1,$v0,$h1)) if ($h1-$h0)>6 && !$nohatch;
  $s.=poly($f,'',P($u0,$v0,$h0),P($u1,$v0,$h0),P($u1,$v0,$h1),P($u0,$v0,$h1));
  return $s; }
sub roof { my ($u0,$u1,$v0,$v1,$h,$R,$o,$col,$m)=@_; my $vm=($v0+$v1)/2; my ($f,$b)=@{$ROOF{$col}}; my $s='';
  $s.=poly($b,'',P($u0-$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R),P($u1+$o,$v1+$o,$h),P($u0-$o,$v1+$o,$h));
  $s.=poly('url(#hatch)',' nostroke',P($u0-$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R),P($u1+$o,$v1+$o,$h),P($u0-$o,$v1+$o,$h));
  $s.=poly($M{$m}[2],'',P($u1,$v0,$h-1),P($u1,$v1,$h-1),P($u1,$vm,$h+$R-1));
  $s.=poly($f,'',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u0-$o,$vm,$h+$R));
  # tile courses with staggered ticks
  my $rows=4; my $W=$u1-$u0+2*$o; my $step=9;
  for my $r (0..$rows){ my $t0=$r/$rows; my $vv=$v0-$o+($vm-$v0+$o)*$t0; my $hh=$h+$R*$t0;
    $s.=line(' opacity=".5" stroke-width=".8"',P($u0-$o,$vv,$hh),P($u1+$o,$vv,$hh)) if $r>0 && $r<$rows;
    next if $r==$rows; my $t1=($r+1)/$rows; my $vv1=$v0-$o+($vm-$v0+$o)*$t1; my $hh1=$h+$R*$t1;
    my $off=($r%2)*$step/2; my $uu=$u0-$o+$off+$step/2; while ($uu<$u1+$o-1){ $s.=line(' opacity=".45" stroke-width=".8"',P($uu,$vv,$hh),P($uu,$vv1,$hh1)); $uu+=$step; } }
  $s.=poly('#ffffff','',P($u0-$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h),P($u1+$o,$v0-$o,$h-3),P($u0-$o,$v0-$o,$h-3));
  $s.=poly('#ffffff','',P($u1+$o,$v0-$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3),P($u1+$o,$v0-$o,$h-3));
  $s.=poly('#eef3f8','',P($u1+$o,$v1+$o,$h),P($u1+$o,$vm,$h+$R),P($u1+$o,$vm,$h+$R-3),P($u1+$o,$v1+$o,$h-3));
  $s.=line(' stroke-width="1.6"',P($u0-$o,$vm,$h+$R+0.6),P($u1+$o,$vm,$h+$R+0.6));
  return $s; }
sub winF { my ($v,$u0,$u1,$h0,$h1,%o)=@_; my $s='';
  $s.=poly('#ffffff','',P($u0-1.8,$v-0.6,$h0-1.8),P($u1+1.8,$v-0.6,$h0-1.8),P($u1+1.8,$v-0.6,$h1+1.8),P($u0-1.8,$v-0.6,$h1+1.8));
  $s.=poly($M{glass}[1],'',P($u0,$v-0.8,$h0),P($u1,$v-0.8,$h0),P($u1,$v-0.8,$h1),P($u0,$v-0.8,$h1));
  if ($o{curtain}) { my $w=($u1-$u0)*0.22; $s.=poly($o{curtain},' nostroke',P($u0,$v-0.85,$h0),P($u0+$w,$v-0.85,$h0),P($u0+$w*0.7,$v-0.85,$h1),P($u0,$v-0.85,$h1)); $s.=poly($o{curtain},' nostroke',P($u1-$w,$v-0.85,$h0),P($u1,$v-0.85,$h0),P($u1,$v-0.85,$h1),P($u1-$w*0.7,$v-0.85,$h1)); $s.=line(' stroke-width=".7" opacity=".6"',P($u0+$w*0.35,$v-0.9,$h0+2),P($u0+$w*0.3,$v-0.9,$h1-2)); $s.=line(' stroke-width=".7" opacity=".6"',P($u1-$w*0.35,$v-0.9,$h0+2),P($u1-$w*0.3,$v-0.9,$h1-2)); }
  if ($o{lamp}) { my ($lx,$ly)=XY(($u0+$u1)/2,$v-0.9,$h0+($h1-$h0)*0.45); $s.=qq{<path d="M}.($lx-3).' '.$ly.qq{h6l-1.2 -4h-3.6z" fill="#f3e6cf" stroke="$INK" stroke-width=".9"/><rect x="}.($lx-0.6).qq{" y="$ly" width="1.2" height="3" fill="$INK"/>\n}; }
  # glazing bars: 2 columns, 2–3 rows
  my $cols=($u1-$u0)>18?3:2; my $rowsn=($h1-$h0)>16?3:2;
  for my $i (1..$cols-1){ my $uu=$u0+($u1-$u0)*$i/$cols; $s.=line(' stroke-width=".9"',P($uu,$v-0.9,$h0),P($uu,$v-0.9,$h1)); }
  for my $i (1..$rowsn-1){ my $hh=$h0+($h1-$h0)*$i/$rowsn; $s.=line(' stroke-width=".9"',P($u0,$v-0.9,$hh),P($u1,$v-0.9,$hh)); }
  # glint
  $s.=line(' stroke="#fff" stroke-width="1.2" opacity=".8"',P($u0+2,$v-1,$h1-3),P($u0+2+($u1-$u0)*.25,$v-1,$h1-3));
  # sill + lintel
  $s.=poly('#ffffff','',P($u0-2.8,$v-2.8,$h0-2.6),P($u1+2.8,$v-2.8,$h0-2.6),P($u1+2.8,$v-0.6,$h0-1.8),P($u0-2.8,$v-0.6,$h0-1.8));
  $s.=poly('#eef3f8','',P($u0-1.8,$v-1.6,$h1+1.8),P($u1+1.8,$v-1.6,$h1+1.8),P($u1+1.8,$v-1.6,$h1+3.6),P($u0-1.8,$v-1.6,$h1+3.6));
  if ($o{flowers}) { $s.=box($u0-1,$u1+1,$v-4,$v-0.6,$h0-6,$h0-2.6,'brick',1); for my $i (0..3){ my $uu=$u0+($u1-$u0)*(0.12+0.25*$i); my ($fx,$fy)=XY($uu,$v-4.2,$h0-1.6); my $c=$i%2?'#5c7290':'#ead9bc'; $s.=qq{<circle cx="}.r1($fx).qq{" cy="}.r1($fy).qq{" r="1.7" fill="$c" stroke="$INK" stroke-width=".8"/><path d="M}.r1($fx-2.2).' '.r1($fy+1.2).qq{q1 -1.6 2.2 -.4" fill="none" stroke="#3f8a7c" stroke-width=".8"/>\n}; } }
  return $s; }
sub doorF { my ($v,$u0,$u1,$h1,$fill,$canopy,%o)=@_; $fill//='#5c7290'; $canopy//='orange'; my $s='';
  my $fan = ($canopy eq 'none' && $h1>=30 && !$o{glass});
  $s.=poly('#ffffff','',P($u0-1.8,$v-0.6,0),P($u1+1.8,$v-0.6,0),P($u1+1.8,$v-0.6,$h1+1.8),P($u0-1.8,$v-0.6,$h1+1.8));
  $s.=poly($fill,'',P($u0,$v-0.8,0),P($u1,$v-0.8,0),P($u1,$v-0.8,$h1),P($u0,$v-0.8,$h1));
  if ($o{glass}) { $s.=poly($M{glass}[1],'',P($u0+2.5,$v-0.9,$h1*.55),P($u1-2.5,$v-0.9,$h1*.55),P($u1-2.5,$v-0.9,$h1-3),P($u0+2.5,$v-0.9,$h1-3)); $s.=line(' stroke-width=".8"',P(($u0+$u1)/2,$v-1,$h1*.55),P(($u0+$u1)/2,$v-1,$h1-3)); }
  else { my $iw=2.6; $s.=line(' opacity=".6" stroke-width=".8"',P($u0+$iw,$v-0.9,$h1-3),P($u1-$iw,$v-0.9,$h1-3),P($u1-$iw,$v-0.9,$h1*.58),P($u0+$iw,$v-0.9,$h1*.58),P($u0+$iw,$v-0.9,$h1-3)); $s.=line(' opacity=".6" stroke-width=".8"',P($u0+$iw,$v-0.9,$h1*.46),P($u1-$iw,$v-0.9,$h1*.46),P($u1-$iw,$v-0.9,4),P($u0+$iw,$v-0.9,4),P($u0+$iw,$v-0.9,$h1*.46)); }
  my ($kx,$ky)=XY($u1-2.4,$v-0.9,$h1*.5); $s.=qq{<circle cx="}.r1($kx).qq{" cy="}.r1($ky).qq{" r="1.1" fill="$INK"/>\n};
  if ($o{number}) { my ($nx,$ny)=XY($u1+5,$v-0.9,$h1*.8); $s.=qq{<text x="}.r1($nx).qq{" y="}.r1($ny).qq{" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5" fill="$INK">$o{number}</text>\n}; }
  if ($fan) { my ($cx,$cy)=XY(($u0+$u1)/2,$v-0.9,$h1+1.8); my $r=($u1-$u0)/2+1.8; $s.=qq{<path d="M}.r1($cx-$r).' '.r1($cy).qq{a$r $r 0 0 1 }.($r*2).qq{ 0z" fill="$M{glass}[1]" stroke="$INK" stroke-width="1.1"/><path d="M$cx $cy l0 -}.r1($r-1).qq{M$cx $cy l-}.r1($r*0.7).qq{ -}.r1($r*0.7).qq{M$cx $cy l}.r1($r*0.7).qq{ -}.r1($r*0.7).qq{" stroke="$INK" stroke-width=".8" fill="none"/>\n}; push @pts,[$cx-$r,$cy-$r]; }
  $s.=box($u0-3,$u1+3,$v-8,$v,$h1+2,$h1+4.5,$canopy,1) if $canopy ne 'none';
  $s.=box($u0-2,$u1+2,$v-5,$v-1,0,2.2,'white',1);
  $s.=poly('#dbe7f3','',P($u0-1,$v-6.5,0.1),P($u1+1,$v-6.5,0.1),P($u1+1,$v-9,0.1),P($u0-1,$v-9,0.1)) if $o{mat};
  return $s; }
sub tree { my ($u,$v,$sz)=@_; my ($x,$y)=XY($u,$v,0); push @pts,[$x-$sz*1.0,$y-$sz*2.9],[$x+$sz*1.0,$y+4]; my $s='';
  $s.=qq{<ellipse cx="$x" cy="}.($y+1).qq{" rx="}.($sz*0.7).qq{" ry="}.($sz*0.25).qq{" fill="$INK" opacity=".10"/>\n};
  $s.=qq{<path d="M}.($x-$sz*0.16).' '.$y.qq{v-}.($sz*1.2).qq{M}.($x+$sz*0.16).' '.$y.qq{v-}.($sz*1.2).qq{M$x }.($y-$sz*0.9).qq{l-}.($sz*0.5).qq{ -}.($sz*0.5).qq{M$x }.($y-$sz*1.1).qq{l}.($sz*0.45).qq{ -}.($sz*0.45).qq{" fill="none" stroke="$INK" stroke-width="1.1" stroke-linecap="round"/>\n};
  $s.=qq{<rect x="}.($x-$sz*0.16).qq{" y="}.($y-$sz*1.2).qq{" width="}.($sz*0.32).qq{" height="}.($sz*1.2).qq{" fill="#b9a584" stroke="none"/>\n};
  my $st=qq{ stroke="$INK" stroke-width="1.1"};
  $s.=qq{<ellipse cx="}.($x-$sz*0.45).qq{" cy="}.($y-$sz*1.55).qq{" rx="}.($sz*0.55).qq{" ry="}.($sz*0.6).qq{" fill="#8fd0c3"$st/><ellipse cx="}.($x+$sz*0.45).qq{" cy="}.($y-$sz*1.6).qq{" rx="}.($sz*0.55).qq{" ry="}.($sz*0.62).qq{" fill="#8fd0c3"$st/><ellipse cx="$x" cy="}.($y-$sz*2.1).qq{" rx="}.($sz*0.62).qq{" ry="}.($sz*0.66).qq{" fill="#b3dcd2"$st/>\n};
  $s.=qq{<path d="M}.($x-$sz*0.2).' '.($y-$sz*2.3).qq{q}.($sz*0.3).qq{ -}.($sz*0.3).qq{ }.($sz*0.5).qq{ -}.($sz*0.1).qq{M}.($x-$sz*0.7).' '.($y-$sz*1.5).qq{q}.($sz*0.2).qq{ -}.($sz*0.3).qq{ }.($sz*0.45).qq{ -}.($sz*0.2).qq{" fill="none" stroke="$INK" stroke-width=".8" opacity=".55"/>\n};
  return $s; }
sub lamp { my ($u,$v)=@_; my ($x,$y)=XY($u,$v,0); my $s=''; push @pts,[$x-8,$y-50],[$x+8,$y+2];
  $s.=qq{<ellipse cx="$x" cy="}.($y+1).qq{" rx="4" ry="1.4" fill="$INK" opacity=".12"/>\n};
  $s.=qq{<path d="M}.($x-3).' '.$y.qq{h6l-1 -3h-4z" fill="#e3eef8" stroke="$INK" stroke-width="1"/><rect x="}.($x-1.1).qq{" y="}.($y-40).qq{" width="2.2" height="37" fill="#e3eef8" stroke="$INK" stroke-width="1"/>\n};
  $s.=qq{<path d="M$x }.($y-40).qq{q0 -6 6 -6" fill="none" stroke="$INK" stroke-width="1.4"/><path d="M}.($x+3).' '.($y-46).qq{h6l-1.5 7h-3z" fill="#f3e6cf" stroke="$INK" stroke-width="1"/><path d="M}.($x+6).' '.($y-46).qq{v-2.5" stroke="$INK" stroke-width="1.2"/><circle cx="}.($x+6).qq{" cy="}.($y-49.5).qq{" r="1.2" fill="$INK"/>\n};
  return $s; }
sub chimney { my ($u0,$u1,$v0,$v1,$h0,$h1)=@_; my $s=box($u0,$u1,$v0,$v1,$h0,$h1,'white').box($u0-1,$u1+1,$v0-1,$v1+1,$h1,$h1+2.5,'grey',1);
  my $w=($u1-$u0); $s.=box($u0+$w*0.15,$u0+$w*0.4,$v0+2,$v0+5,$h1+2.5,$h1+6,'brick',1).box($u0+$w*0.6,$u0+$w*0.85,$v0+2,$v0+5,$h1+2.5,$h1+6,'brick',1); return $s; }
sub brickband { my ($u0,$u1,$v0,$v1,$h)=@_; my $s=wall($u0,$u1,$v0,$v1,0,$h,'brick'); my $rows=int($h/3)||1; my $bw=8;
  for my $r (1..$rows-1){ my $hh=$h*$r/$rows; $s.=line(' opacity=".5" stroke-width=".7"',P($u0,$v0-0.2,$hh),P($u1,$v0-0.2,$hh)); }
  for my $r (0..$rows-1){ my $h0=$h*$r/$rows; my $h1=$h*($r+1)/$rows; my $off=($r%2)*$bw/2; my $uu=$u0+$off+$bw/2; while($uu<$u1-0.5){ $s.=line(' opacity=".45" stroke-width=".7"',P($uu,$v0-0.2,$h0),P($uu,$v0-0.2,$h1)); $uu+=$bw; } }
  return $s; }
sub railing { my ($u0,$u1,$v,$h)=@_; my $s=''; my $uu=$u0; while($uu<=$u1){ $s.=line(' stroke-width="1"',P($uu,$v,0),P($uu,$v,$h)); $uu+=4; } $s.=line(' stroke-width="1.4"',P($u0,$v,$h),P($u1,$v,$h)); $s.=line(' stroke-width="1"',P($u0,$v,$h*0.5),P($u1,$v,$h*0.5)); return $s; }

sub sketchwrap { my $in=shift; my $i=index($in,'<!--P-->'); my $pre = $i<0 ? $in : substr($in,0,$i); my $post = $i<0 ? '' : substr($in,$i); my $j=index($pre,'<ellipse'); my $shadow = $j<0 ? '' : substr($pre,0,index($pre,"\n",$j)+1); $pre = substr($pre,length($shadow)); return $shadow.qq{<g filter="url(#sketch)">\n}.$pre.qq{</g>\n}.$post; }
sub building { my ($id,$href,$label,$body)=@_; @pts=(); my $inner=$body->(); $inner = sketchwrap($inner); my ($x0,$y0,$x1,$y1)=(1e9,1e9,-1e9,-1e9); for (@pts){ $x0=$_->[0] if $_->[0]<$x0; $x1=$_->[0] if $_->[0]>$x1; $y0=$_->[1] if $_->[1]<$y0; $y1=$_->[1] if $_->[1]>$y1; }
  my $pad=4; my $vb=sprintf("%.0f %.0f %.0f %.0f",$x0-$pad,$y0-$pad,($x1-$x0)+2*$pad,($y1-$y0)+2*$pad);
  return qq{      <a class="plot" role="listitem" href="$href" data-p="$id" aria-label="$label bridging loans">\n        <svg class="plot-ill" viewBox="$vb" aria-hidden="true">\n$inner        </svg>\n        <span class="plot-btn">$label <span class="arr">&rarr;</span></span>\n      </a>\n\n}; }

unless ($main::NO_RUN) {
my $out = '';
my $shapes = qq{<circle cx="32" cy="30" r="16"/><circle cx="56" cy="20" r="20"/><circle cx="84" cy="27" r="17"/><rect x="14" y="30" width="92" height="20" rx="10"/>};
my $cloud = qq{<g fill="#fff" stroke="$INK" stroke-width="2.2">$shapes</g><g fill="#fff">$shapes</g>};
$out .= qq{  <!-- Illustrated street: one building per product facing the road, every building is a link -->
  <div class="hm-street">
}.defs().qq{    <div class="street-sky" aria-hidden="true">
      <svg class="cloud cloud-1" viewBox="8 -4 108 58">$cloud</svg>
      <svg class="cloud cloud-2" viewBox="8 -4 108 58">$cloud</svg>
      <svg class="cloud cloud-3" viewBox="8 -4 108 58">$cloud</svg>
    </div>

    <div class="plots" role="list" aria-label="What we lend on">

};

# 1 Residential
$out .= building('res','/products/residential-bridging-loans','Residential', sub { my $s='';
  $s.=shadow(-12,104,0,56);
  $s.=brickband(0,92,0,56,9);
  $s.=wall(0,92,0,56,9,50,'yellow'); $s.=wall(50,92,0,56,9,50,'blue');
  $s.=roof(0,92,0,56,50,28,6,'red','blue');
  $s.=chimney(70,80,30,40,50,74); $s.=smoke(75,35,76);
  $s.=wall(10,44,-14,0,0,34,'yellow'); $s.=roofX(10,44,-14,0,34,16,4,'orange','yellow');
  $s.=doorF(-14,20,34,26,'#ff6a6b','none', number=>'12', mat=>1);
  $s.=winF(0,56,72,24,42, curtain=>'#dbe7f3', flowers=>1); $s.=winF(0,78,90,24,42, curtain=>'#dbe7f3');
  $s.=winS(92,10,26,22,40); $s.=winS(92,36,50,22,40);
  $s.=drainpipe(93.5,0,50);
  $s.=hedge(52,90,-10,-4,6); $s.=tree(-4,-6,8);
  $s.=bird(60,-96); $s.=bird(72,-100);
  $s.=person(106,-16, top=>'#ff6a6b', legs=>'#dbe7f3', hairstyle=>'bun', hair=>'#5a3a2a', prop=>'keys', delay=>0.3);
  $s; });

# 2 Auction: couple high-fiving in front of the board
$out .= building('auc','/products/auction-bridging-loans','Auction', sub { my $s='';
  $s.=shadow(-12,120,0,54);
  $s.=brickband(0,104,0,54,7);
  $s.=wall(0,104,0,54,7,34,'cream');
  $s.=roof(0,104,0,54,34,24,6,'orange','cream');
  $s.=chimney(22,32,28,38,34,56);
  $s.=winF(0,10,32,12,28, curtain=>'#3d4e63', lamp=>1); $s.=winF(0,72,94,12,28, curtain=>'#3d4e63');
  $s.=doorF(0,44,60,28,'#1f1f24','orange', number=>'14', glass=>1);
  $s.=winS(104,10,26,12,28); $s.=winS(104,32,48,12,28);
  $s.=signF(66,118,-16,30,50,'#ff6a6b','AUCTION',8.4);
  $s.=tree(-4,-6,8); $s.=hedge(2,40,-9,-4,5);
  $s.=person(6,-18, top=>'#5fb2a2', legs=>'#1f1f24', hairstyle=>'short', prop=>'hifive-r', delay=>0.1);
  $s.=person(32,-18, top=>'#ead9bc', legs=>'#1f1f24', hairstyle=>'long', hair=>'#1f1f24', skin=>'#9a6a4b', prop=>'hifive-l', delay=>0.1);
  my ($cx,$cy)=XY(19,-18,0); $s.=clap($cx,$cy-44);
  $s; });

# 3 No valuation
$out .= building('nov','/products/no-valuation-bridging-loans','No valuation', sub { my $s='';
  $s.=shadow(-12,96,0,50);
  $s.=brickband(0,78,0,50,8);
  $s.=wall(0,78,0,50,8,92,'slate');
  for my $row (1..2){ my $h0=14+$row*26; $s.=winF(0,8,24,$h0,$h0+18, curtain=>($row==2?'#ead9bc':undef), flowers=>($row==1)); $s.=winF(0,31,47,$h0,$h0+18, lamp=>($row==1)); $s.=winF(0,54,70,$h0,$h0+18, curtain=>'#dbe7f3'); }
  $s.=winF(0,8,24,14,32, curtain=>'#5fb2a2'); $s.=winF(0,54,70,14,32, curtain=>'#5fb2a2');
  $s.=doorF(0,31,47,32,'#ff6a6b','none', number=>'7');
  $s.=box(26,29,-5,0,0,34,'white'); $s.=box(49,52,-5,0,0,34,'white'); $s.=box(24,54,-6,0,34,38,'white');
  $s.=railing(2,22,-4,9); $s.=railing(56,76,-4,9);
  for my $row (0..2){ my $h0=14+$row*26; $s.=winS(78,8,22,$h0,$h0+18); $s.=winS(78,30,44,$h0,$h0+18); }
  $s.=flatroof(0,78,0,50,92,'slate');
  $s.=chimney(10,20,30,40,96,110); $s.=smoke(15,35,112);
  $s.=lamp(92,-8); $s.=tree(-4,-6,8);
  $s.=person(68,-16, top=>'#dbe7f3', legs=>'#1f1f24', hairstyle=>'curly', hair=>'#b9a584', prop=>'phone', delay=>0.6);
  my ($bx,$by)=XY(84,0,104);
  $s.=qq{<g transform="translate($bx $by)"><circle r="17" fill="#fff" stroke="$INK" stroke-width="1.2"/><circle cy="-5" r="6" fill="#5fb2a2" stroke="$INK" stroke-width="1"/><path d="M-3 -5l2 2 4-4" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round" stroke-linejoin="round"/><text y="7" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="$INK">NO SITE</text><text y="13" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="5.2" fill="$INK">VISIT</text></g>\n};
  push @pts,[$bx-17,$by-17],[$bx+17,$by+17];
  $s; });

# 4 Refurbishment
$out .= building('ref','/products/refurbishment-bridging-loans','Refurbishment', sub { my $s='';
  $s.=shadow(-12,124,0,54);
  $s.=brickband(0,90,0,54,7);
  $s.=wall(0,90,0,54,7,44,'sage');
  $s.=roof(0,90,0,54,44,26,6,'brown','sage');
  $s.=winF(0,10,30,16,36); $s.=winF(0,62,82,16,36);
  $s.=doorF(0,38,54,30,'#f4ecdc','none');
  $s.=winS(90,12,28,16,36);
  for my $u (-2,28,58,88){ $s.=box($u,$u+2.4,-9,-6.6,0,60,'yellowk'); }
  $s.=box(-4,92,-9,-4,22,25,'grey'); $s.=box(-4,92,-9,-4,42,45,'grey'); $s.=box(-3,91,-8,-6,59,61,'yellowk');
  # ladder
  $s.=line(' stroke-width="1.4"',P(66,-10,0),P(66,-10,24)); $s.=line(' stroke-width="1.4"',P(72,-10,0),P(72,-10,24)); for my $i (1..4){ $s.=line('',P(66,-10,$i*5),P(72,-10,$i*5)); }
  $s.=box(100,120,-12,2,0,16,'yellowk');
  my ($sx,$sy)=XY(110,-5,17); $s.=qq{<ellipse cx="}.r1($sx).qq{" cy="}.r1($sy).qq{" rx="9" ry="4" fill="#b9cde3" stroke="$INK" stroke-width="1"/>\n};
  $s.=person(14,-20, top=>'#3d4e63', legs=>'#1f1f24', hivis=>1, hat=>'hard', hairstyle=>'short', prop=>'saw', delay=>0.9);
  $s.=person(70,-20, top=>'#dbe7f3', legs=>'#1f1f24', hairstyle=>'long', hair=>'#1f1f24', skin=>'#9a6a4b', prop=>'plan', delay=>0.4);
  $s; });

# 5 Semi-commercial: shopkeeper holding money
$out .= building('semi','/products/semi-commercial-bridging-loans','Semi-commercial', sub { my $s='';
  $s.=shadow(-12,112,0,54);
  $s.=wall(0,100,0,54,0,66,'cream');
  $s.=winF(0,10,30,42,58, curtain=>'#5c7290', flowers=>1); $s.=winF(0,40,60,42,58, lamp=>1); $s.=winF(0,70,90,42,58, curtain=>'#5c7290');
  $s.=box(0,100,-2,0,28,36,'navy');
  $s.=textF(50,-2.3,29.6,'CORNER SHOP',6.8,'#fff','middle');
  $s.=poly('#ffffff','',P(4,-0.5,2),P(62,-0.5,2),P(62,-0.5,26),P(4,-0.5,26));
  $s.=poly($M{glass}[1],'',P(6,-1,4),P(60,-1,4),P(60,-1,24),P(6,-1,24));
  $s.=poly('#ead9bc','',P(10,-1.2,6),P(22,-1.2,6),P(22,-1.2,14),P(10,-1.2,14)); $s.=poly('#5c7290','',P(26,-1.2,6),P(40,-1.2,6),P(40,-1.2,12),P(26,-1.2,12)); $s.=poly('#8fd0c3','',P(44,-1.2,6),P(56,-1.2,6),P(56,-1.2,16),P(44,-1.2,16));
  $s.=poly('#dbe7f3','',P(8,-1.2,17),P(58,-1.2,17),P(58,-1.2,21),P(8,-1.2,21)); $s.=textF(33,-1.4,17.8,'OPEN',3.6,$INK,'middle');
  $s.=doorF(0,70,88,26,'#1f1f24','none', glass=>1);
  for my $i (0..7){ my $u0=2+$i*12; my $f=$i%2?'#ffffff':'#ff6a6b'; $s.=poly($f,'',P($u0,0,27),P($u0+12,0,27),P($u0+12,-9,22),P($u0,-9,22)); }
  $s.=poly('#ffffff','',P(2,-9,22),P(98,-9,22),P(98,-9,19.5),P(2,-9,19.5));
  $s.=winS(100,10,28,42,58);
  $s.=flatroof(0,100,0,54,66,'cream');
  $s.=chimney(74,84,30,40,70,82);
  $s.=person(106,-16, top=>'#5fb2a2', legs=>'#1f1f24', apron=>1, hairstyle=>'short', hair=>'#1f1f24', skin=>'#9a6a4b', prop=>'cash', delay=>0.4);
  $s; });

# 6 Commercial: broker with a briefcase
$out .= building('com','/products/commercial-bridging-loans','Commercial', sub { my $s='';
  $s.=shadow(-12,126,0,60);
  $s.=wall(0,90,0,60,0,104,'peri');
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..3){ my $u0=5+$c*21; next if $row==0 && ($c==1||$c==2); $s.=winF(0,$u0,$u0+15,$h0,$h0+16, lamp=>(($row+$c)%3==1)); } }
  for my $row (0..3){ my $h0=12+$row*23; for my $c (0..2){ my $v0=6+$c*18; $s.=winS(90,$v0,$v0+12,$h0,$h0+16); } }
  $s.=doorF(0,28,62,24,'#1f1f24','none', glass=>1);
  $s.=box(22,68,-7,0,24,27,'white'); $s.=textF(45,-7.3,24.6,'AF CREDIT HOUSE',3.6,$INK,'middle');
  $s.=flatroof(0,90,0,60,104,'white');
  $s.=box(8,22,36,48,108,116,'grey');
  my ($fx,$fy)=XY(70,10,108); $s.=qq{<line x1="$fx" y1="$fy" x2="$fx" y2="}.($fy-22).qq{" stroke="$INK" stroke-width="1.5"/><path d="M$fx }.($fy-22).qq{h10l-3 4 3 4h-10z" fill="#ff6a6b" stroke="$INK" stroke-width="1"/>\n};
  push @pts,[$fx+12,$fy-24];
  $s.=tree(-4,-6,8);
  $s.=person(72,-20, top=>'#1f1f24', legs=>'#1f1f24', hairstyle=>'short', prop=>'case', delay=>0.7);
  $s.=person(98,-18, top=>'#5fb2a2', legs=>'#dbe7f3', hairstyle=>'bun', hair=>'#5a3a2a', prop=>'plan', delay=>0.2);
  $s; });

# 7 Adverse credit: approval paper with green ticks
$out .= building('adv','/products/bad-credit-bridging-loans','Adverse credit', sub { my $s='';
  $s.=shadow(-12,116,0,54);
  $s.=wall(0,88,0,54,0,40,'brick');
  $s.=roof(0,88,0,54,40,30,6,'tealr','brick');
  $s.=chimney(60,70,30,40,42,64); $s.=smoke(65,35,66);
  $s.=winF(0,10,30,14,32, curtain=>'#5fb2a2', flowers=>1); $s.=winF(0,58,78,14,32, curtain=>'#5fb2a2', lamp=>1);
  $s.=doorF(0,36,52,30,'#5fb2a2','orange', number=>'3', mat=>1);
  $s.=winS(88,12,28,14,32);
  $s.=signF(56,106,-16,32,52,'#5fb2a2','APPROVED',8);
  $s.=tree(-4,-6,8);
  $s.=person(16,-18, top=>'#5c7290', legs=>'#1f1f24', hairstyle=>'long', hair=>'#5a3a2a', prop=>'paper', delay=>0.2);
  $s.=person(110,-16, top=>'#ead9bc', legs=>'#dbe7f3', hairstyle=>'short', hair=>'#1f1f24', skin=>'#9a6a4b', prop=>'thumbs', delay=>0.5);
  $s; });

$out .= qq{    </div>
    <div class="swipe-badge" aria-hidden="true"><svg viewBox="0 0 40 40" fill="none" stroke="#1f1f24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M31 7c-6-4-15-4-22 1"/><path d="M11 5l-2 3 3.5 1.5"/><g class="swipe-hand"><path d="M17 14v10l-3-3.5c-1.2-1.2-3-.6-3 1l5 7.5c1 1.6 2.6 2.5 4.4 2.5H25c2.6 0 4.5-1.8 4.6-4.4L30 21c0-1.4-1-2.4-2.3-2.4S25.5 19.5 25.5 21M21 14v8M21 14a2 2 0 0 0-4 0M25.5 21v-3a2 2 0 0 0-4 0v4" fill="#fff"/></g></svg></div>
  </div>
};
open my $o,'>:raw',$ARGV[0] or die; print $o $out; close $o; print "written ", length($out), " bytes\n";
}
1;
