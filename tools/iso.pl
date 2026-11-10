use strict; use warnings;
# Front-elevation flat street generator (v6): bold simple shapes, flat brand colours, thin clean outlines.
our $INK = '#1b2b3b';
our @pts;
sub r1 { sprintf('%.1f',$_[0]) }
sub pt { my ($x,$y)=@_; push @pts,[$x,$y]; return r1($x).','.r1($y); }
sub XY { my ($u,$v,$h)=@_; return ($u, -$h); }   # 2D: people stand on y=0
sub poly { my ($fill,$extra,@p)=@_; $extra//=''; my $st = ($extra =~ /nostroke/) ? '' : qq{ stroke="$INK" stroke-width="1.6" stroke-linejoin="round"}; $extra =~ s/ ?nostroke//; return qq{<polygon points="}.join(' ',@p).qq{" fill="$fill"$st$extra/>\n}; }
sub rect { my ($x,$y,$w,$h,$fill,$extra)=@_; $extra//=''; my $st=($extra=~/nostroke/)?'':qq{ stroke="$INK" stroke-width="1.6" stroke-linejoin="round"}; $extra=~s/ ?nostroke//; push @pts,[$x,$y],[$x+$w,$y+$h]; return qq{<rect x="}.r1($x).qq{" y="}.r1($y).qq{" width="}.r1($w).qq{" height="}.r1($h).qq{" fill="$fill"$st$extra/>\n}; }
sub line { my ($extra,@p)=@_; return qq{<path d="M}.join(' L',@p).qq{" fill="none" stroke="$INK" stroke-width="1.4" stroke-linecap="round"$extra/>\n}; }

# palette: brand navy ink, brand blues, white, coral accent, teal foliage
our %C = ( white=>'#ffffff', sky=>'#dbe7f3', sky2=>'#b9cde3', blue=>'#1b2b3b', navy=>'#1b2b3b', coral=>'#ff6a6b', teal=>'#2f7d6d', teal2=>'#5fb2a2', cream=>'#f4ecdc', grey=>'#c9d3df' );

sub gable { my ($x,$w,$yEave,$rise,$o,$fill)=@_; return poly($fill,'',pt($x-$o,$yEave),pt($x+$w/2,$yEave-$rise),pt($x+$w+$o,$yEave)); }
sub hip  { my ($x,$w,$yEave,$rise,$o,$fill,$top)=@_; $top//=0.45; my $t=$w*$top; return poly($fill,'',pt($x-$o,$yEave),pt($x+($w-$t)/2,$yEave-$rise),pt($x+($w+$t)/2,$yEave-$rise),pt($x+$w+$o,$yEave)); }
sub window { my ($x,$y,$w,$h,%o)=@_; my $s=rect($x,$y,$w,$h,$o{fill}//$C{sky}); my $cols=$o{cols}//2; my $rows=$o{rows}//2; for my $i (1..$cols-1){ my $xx=$x+$w*$i/$cols; $s.=line(' stroke="#fff" stroke-width="1.8"',pt($xx,$y+1),pt($xx,$y+$h-1)); } for my $i (1..$rows-1){ my $yy=$y+$h*$i/$rows; $s.=line(' stroke="#fff" stroke-width="1.8"',pt($x+1,$yy),pt($x+$w-1,$yy)); } if ($o{lit}) { $s.=rect($x+2,$y+2,$w*0.42,$h*0.42,'#f3e6cf',' nostroke'); } return $s; }
sub door { my ($x,$y,$w,$h,$fill,%o)=@_; $fill//=$C{coral}; my $s=rect($x,$y-$h,$w,$h,$fill); $s.=qq{<circle cx="}.r1($x+$w-3.2).qq{" cy="}.r1($y-$h*0.5).qq{" r="1.3" fill="$INK"/>\n}; if ($o{panes}) { $s.=rect($x+$w*0.25,$y-$h*0.82,$w*0.5,$h*0.28,$C{sky}); $s.=line(' stroke="#fff" stroke-width="1.6"',pt($x+$w*0.5,$y-$h*0.8),pt($x+$w*0.5,$y-$h*0.56)); } if ($o{step}) { $s.=rect($x-3,$y,$w+6,3,$C{white}); } return $s; }
sub chimney { my ($x,$y,$w,$h,$fill)=@_; $fill//=$C{blue}; return rect($x,$y-$h,$w,$h,$fill).rect($x-1.5,$y-$h-3,$w+3,3,$fill); }
sub cloudpath { my ($x,$y,$s)=@_; push @pts,[$x,$y-$s*0.9],[$x+$s*1.8,$y+1]; return qq{<path d="M}.($x+$s*0.2).' '.$y.qq{a}.($s*0.35).' '.($s*0.35).qq{ 0 0 1 }.($s*0.35).' -'.($s*0.42).qq{a}.($s*0.45).' '.($s*0.45).qq{ 0 0 1 }.($s*0.8).' -'.($s*0.12).qq{a}.($s*0.3).' '.($s*0.3).qq{ 0 0 1 }.($s*0.25).' '.($s*0.54).qq{z" fill="#fff" stroke="$INK" stroke-width="1.6" stroke-linejoin="round"/>\n}; }
# trees: blob canopy with branch lines, like the references
sub tree { my ($x,$kind,$sz,$fill)=@_; $kind//='round'; $fill//=$C{teal2}; my $s=''; push @pts,[$x-$sz,-$sz*3.2],[$x+$sz,1];
  if ($kind eq 'round') { $s.=line(' stroke-width="1.6"',pt($x,0),pt($x,-$sz*1.6)); $s.=qq{<circle cx="$x" cy="}.(-$sz*2.1).qq{" r="}.($sz*0.95).qq{" fill="$fill" stroke="none"/>\n}; $s.=line(' stroke-width="1.4"',pt($x,-$sz*1.6),pt($x,-$sz*2.8)).line(' stroke-width="1.2"',pt($x,-$sz*2.2),pt($x-$sz*0.45,-$sz*2.6)).line(' stroke-width="1.2"',pt($x,-$sz*1.95),pt($x+$sz*0.45,-$sz*2.4)); }
  elsif ($kind eq 'tall') { $s.=qq{<path d="M$x -}.($sz*3.2).qq{c}.($sz*0.9).' '.($sz*0.2).' '.($sz*0.95).' '.($sz*1.6).' '.($sz*0.3).' '.($sz*2.4).qq{q-}.($sz*0.3).' '.($sz*0.3).' -'.($sz*0.3).' '.($sz*0.8).qq{h-}.($sz*0.6).qq{q0 -}.($sz*0.5).' -'.($sz*0.3).' -'.($sz*0.8).qq{c-}.($sz*0.65).' -'.($sz*0.8).' -'.($sz*0.6).' -'.($sz*2.2).' '.($sz*0.3).' -'.($sz*2.4).qq{z" fill="$fill"/>\n}; $s.=line(' stroke-width="1.6"',pt($x,0),pt($x,-$sz*2.9)); for my $i (0..2){ my $yy=-$sz*(1.2+$i*0.6); $s.=line(' stroke-width="1.2"',pt($x,$yy),pt($x-$sz*0.4,$yy-$sz*0.35)).line(' stroke-width="1.2"',pt($x,$yy-$sz*0.3),pt($x+$sz*0.4,$yy-$sz*0.65)); } }
  elsif ($kind eq 'bush') { $s.=qq{<path d="M}.($x-$sz).qq{ 0a}.($sz*0.55).' '.($sz*0.55).qq{ 0 0 1 }.($sz*0.9).' -'.($sz*0.5).qq{a}.($sz*0.6).' '.($sz*0.6).qq{ 0 0 1 }.($sz*1.1).' '.($sz*0.5).qq{z" fill="$fill"/>\n}; }
  return $s; }
sub signpost { my ($x,$w,$y1,$h,$fill,$txt,$size)=@_; my $s=line(' stroke-width="2.2"',pt($x+$w/2,0),pt($x+$w/2,$y1)); $s.=rect($x,$y1-$h,$w,$h,$fill); $s.=qq{<text x="}.r1($x+$w/2).qq{" y="}.r1($y1-$h/2+$size*0.36).qq{" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="$size" fill="#fff" letter-spacing=".05em" textLength="}.($w-8).qq{" lengthAdjust="spacingAndGlyphs">$txt</text>\n}; return $s; }
sub badge { my ($x,$y,$r,$l1,$l2)=@_; push @pts,[$x-$r,$y-$r],[$x+$r,$y+$r]; return qq{<g transform="translate($x $y)"><circle r="$r" fill="#fff" stroke="$INK" stroke-width="1.6"/><circle cy="}.(-$r*0.3).qq{" r="}.($r*0.34).qq{" fill="$C{teal2}" stroke="$INK" stroke-width="1.2"/><path d="M}.(-$r*0.16).' '.(-$r*0.3).qq{l}.($r*0.12).' '.($r*0.12).qq{ }.($r*0.26).' -'.($r*0.26).qq{" stroke="#fff" stroke-width="1.8" fill="none" stroke-linecap="round" stroke-linejoin="round"/><text y="}.($r*0.38).qq{" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="}.($r*0.3).qq{" fill="$INK">$l1</text><text y="}.($r*0.72).qq{" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="}.($r*0.3).qq{" fill="$INK">$l2</text></g>\n}; }

# ── artistic layer: flowing backdrops, lamp, bench, birds, window boxes, planters ──
sub backdrop { my ($x,$w,$h,$fill)=@_; $fill//=$C{sky}; my $cx=$x+$w/2; push @pts,[$x-$w*0.25,-$h-14],[$x+$w*1.25,0]; return qq{<path d="M}.($x-$w*0.22).qq{ 0c-}.($w*0.1).qq{ -}.($h*0.55).qq{ }.($w*0.25).qq{ -}.($h*0.95).qq{ }.($w*0.55).qq{ -}.($h*0.9).qq{c}.($w*0.3).qq{ -}.($h*0.25).qq{ }.($w*0.75).qq{ -}.($h*0.05).qq{ }.($w*0.72).qq{ }.($h*0.45).qq{c}.($w*0.05).qq{ }.($h*0.25).qq{ -}.($w*0.1).qq{ }.($h*0.4).qq{ -}.($w*0.1).qq{ }.($h*0.45).qq{z" fill="$fill"/>\n}; }
sub lamp2 { my ($x,$h)=@_; $h//=52; push @pts,[$x-6,-$h-8],[$x+6,0]; return line(' stroke-width="2"',pt($x,0),pt($x,-$h)).qq{<circle cx="$x" cy="}.(-$h-3).qq{" r="4.2" fill="$C{coral}" stroke="$INK" stroke-width="1.6"/>\n}.rect($x-4,-3,8,3,$INK,' nostroke'); }
sub bench { my ($x,$w)=@_; return rect($x,-9,$w,2.6,$C{white}).line(' stroke-width="1.6"',pt($x+3,-6.4),pt($x+3,0)).line(' stroke-width="1.6"',pt($x+$w-3,-6.4),pt($x+$w-3,0)).line(' stroke-width="1.6"',pt($x+2,-16),pt($x+$w-2,-16)).line(' stroke-width="1.6"',pt($x+4,-16),pt($x+3,-9)).line(' stroke-width="1.6"',pt($x+$w-4,-16),pt($x+$w-3,-9)); }
sub birds { my ($x,$y)=@_; push @pts,[$x-10,$y-6],[$x+10,$y+2]; return qq{<path d="M}.($x-9).' '.$y.qq{q3 -4 6 0q3 -4 6 0M}.($x+2).' '.($y-5).qq{q2.5 -3.4 5 0q2.5 -3.4 5 0" fill="none" stroke="$INK" stroke-width="1.3" stroke-linecap="round"/>\n}; }
sub windowbox { my ($x,$y,$w)=@_; my $s=rect($x-1,$y,$w+2,4,$C{coral}); for my $i (0..2){ my $cx=$x+2+$i*($w-4)/2; $s.=qq{<circle cx="}.r1($cx).qq{" cy="}.($y-1.5).qq{" r="2" fill="$C{teal2}" stroke="$INK" stroke-width="1.1"/>\n}; } return $s; }
sub planter { my ($x,$w,$h)=@_; $h//=10; my $s=rect($x,-$h,$w,$h,$C{navy}); $s.=qq{<ellipse cx="}.($x+$w/2).qq{" cy="}.(-$h-6).qq{" rx="}.($w*0.6).qq{" ry="7" fill="$C{teal2}" stroke="$INK" stroke-width="1.4"/>\n}; push @pts,[$x,-$h-14]; return $s; }

# ── people ──
sub person { my ($u,$v,%o)=@_; my $top=$o{top}//$C{blue}; my $legs=$o{legs}//$INK; my $skin=$o{skin}//'#f3c9a6'; my $hair=$o{hair}//$INK; my ($x,$y)=XY($u,$v,0); my $s=''; my $st=qq{ stroke="$INK" stroke-width="1.3" stroke-linejoin="round"}; my $p=$o{prop}//''; my $d=$o{delay}//0;
  push @pts,[$x-20,$y-52],[$x+22,$y+3];
  $s.=qq{<g class="person" style="animation-delay:${d}s">\n};
  $s.=qq{<rect x="}.($x-4.2).qq{" y="}.($y-18).qq{" width="3.6" height="18" rx="1.6" fill="$legs"$st/><rect x="}.($x+0.6).qq{" y="}.($y-18).qq{" width="3.6" height="18" rx="1.6" fill="$legs"$st/>\n};
  $s.=qq{<path d="M}.($x-5.5).' '.($y-17).qq{v-13a5.5 5.5 0 0 1 11 0v13z" fill="$top"$st/>\n};
  if ($o{apron}) { $s.=qq{<path d="M}.($x-4).' '.($y-30).qq{h8v14h-8z" fill="#ffffff"$st/>\n}; }
  if ($o{hivis}) { $s.=qq{<path d="M}.($x-6.5).' '.($y-24).qq{h13M}.($x-6.5).' '.($y-20).qq{h13" stroke="#f3e6cf" stroke-width="2"/>\n}; }
  my $army=$y-29;
  my $armr = sub { my ($dx,$dy,$r)=@_; $r//=2.3; return qq{<path d="M}.($x+6).' '.$army.qq{l$dx $dy" stroke="$top" stroke-width="4" stroke-linecap="round"/><circle cx="}.($x+6+$dx).qq{" cy="}.($army+$dy).qq{" r="$r" fill="$skin"$st/>}; };
  my $arml = sub { my ($dx,$dy,$r)=@_; $r//=2.3; return qq{<path d="M}.($x-6).' '.$army.qq{l$dx $dy" stroke="$top" stroke-width="4" stroke-linecap="round"/><circle cx="}.($x-6+$dx).qq{" cy="}.($army+$dy).qq{" r="$r" fill="$skin"$st/>}; };
  my ($hx,$hy)=($x+9.4,$army+10.6);
  my $props = {
    keys  => sub { my ($px,$py)=@_; my $k=qq{<g transform="rotate(-35 $px $py)"><circle cx="$px" cy="$py" r="3.4" fill="#fff" stroke="$INK" stroke-width="1.5"/><circle cx="$px" cy="$py" r="1.2" fill="$INK"/><path d="M}.($px+3.4).' '.$py.qq{h10" stroke="$INK" stroke-width="2.2" stroke-linecap="round"/><path d="M}.($px+10).' '.$py.qq{v3.2M}.($px+13).' '.$py.qq{v2.4" stroke="$INK" stroke-width="2" stroke-linecap="round"/><path d="M}.($px-1.5).' '.($py+3.4).qq{l-2.5 5.5" stroke="$INK" stroke-width="1.3"/><rect x="}.($px-7.2).qq{" y="}.($py+8.6).qq{" width="6.4" height="4.2" rx="1.2" fill="$C{coral}" stroke="$INK" stroke-width="1.2"/></g>}; $k; },
    phone => sub { my ($px,$py)=@_; qq{<rect x="}.($px-0.8).qq{" y="}.($py-4.2).qq{" width="3.4" height="5.6" rx=".8" fill="$INK"/>}; },
    case  => sub { my ($px,$py)=@_; qq{<rect x="}.($px-1).qq{" y="}.($py).qq{" width="12" height="9" rx="1.4" fill="$INK"/><path d="M}.($px+3).' '.($py).qq{v-2h4v2" stroke="$INK" stroke-width="1.3" fill="none"/><rect x="}.($px+3.5).qq{" y="}.($py+3.5).qq{" width="3" height="2" fill="$C{coral}"/>}; },
    saw   => sub { my ($px,$py)=@_; qq{<path d="M}.($px-0.5).' '.($py+0.5).qq{l10 -6 l1.5 2 l-1.5 1.5 l1.5 1.5 l-1.5 1.5 l1.5 1.5 l-8 3z" fill="$C{grey}"$st/><rect x="}.($px-2).qq{" y="}.($py-1).qq{" width="3.5" height="4" rx="1" fill="$INK"/>}; },
    cash  => sub { my ($px,$py)=@_; qq{<g transform="rotate(-18 $px $py)"><rect x="}.($px-2).qq{" y="}.($py-5).qq{" width="14" height="7" rx="1" fill="$C{teal2}"$st/><circle cx="}.($px+5).qq{" cy="}.($py-1.5).qq{" r="2" fill="#fff" stroke="$INK" stroke-width=".8"/></g>}; },
  };
  if ($p eq 'hifive-r' || $p eq 'hifive-l') {
    my $L = $p eq 'hifive-l' ? qq{<g class="arm-hi-l">}.$arml->(-7,-13,2.6).qq{</g>} : qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g>};
    my $R = $p eq 'hifive-r' ? qq{<g class="arm-hi-r">}.$armr->(7,-13,2.6).qq{</g>} : qq{<g class="arm-idle-r">}.$armr->(3,10).qq{</g>};
    $s.=$L.$R."\n"; }
  elsif ($p eq 'paper' || $p eq 'plan') {
    my $sheet = $p eq 'plan'
      ? qq{<rect x="}.($x-7).qq{" y="}.($y-26).qq{" width="14" height="11" rx="1" fill="#fff"$st/><path d="M}.($x-4).' '.($y-18).qq{v-4l4 -3 4 3v4z" fill="none" stroke="$INK" stroke-width="1" stroke-linejoin="round"/>}
      : qq{<rect x="}.($x-5.5).qq{" y="}.($y-25).qq{" width="11" height="13" rx="1" fill="#fff"$st/>}.join('', map { my $ty=$y-22+$_*3.6; qq{<path d="M}.($x-3.8).' '.$ty.qq{l1.2 1.2 2.2-2.4" stroke="$C{teal2}" stroke-width="1.3" fill="none" stroke-linecap="round" stroke-linejoin="round"/><path d="M}.($x+0.8).' '.($ty+0.2).qq{h3.6" stroke="$INK" stroke-width=".8" opacity=".5"/>} } 0..2);
    $s.=qq{<g class="act-raise">}.$arml->(4,7).$armr->(-4,7).$sheet.qq{</g>\n}; }
  elsif ($p eq 'cash')  { $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-cash">}.$armr->(8,-6).$props->{cash}->($x+14,$army-6).qq{</g>\n}; }
  elsif ($p eq 'phone') { $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-phone">}.$armr->(3,10).$props->{phone}->($hx,$hy).qq{</g>\n}; }
  elsif ($p eq 'keys')  { $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-keys">}.$armr->(6,-9).$props->{keys}->($x+12,$army-9).qq{</g>\n}; }
  elsif ($p eq 'thumbs'){ my ($fx,$fy)=($x+13,$army-8); $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-thumbs">}.$armr->(7,-8,2.9).qq{<rect x="}.($fx-0.6).qq{" y="}.($fy-7.2).qq{" width="2.4" height="5" rx="1.2" fill="$skin"$st/></g>\n}; }
  elsif ($p eq 'saw')   { $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="act-saw">}.$armr->(4,9).$props->{saw}->($x+10,$army+9).qq{</g>\n}; }
  elsif ($p eq 'case')  { $s.=qq{<g class="act-watch">}.$arml->(-3,10).qq{</g><g class="act-case">}.$armr->(3,10).$props->{case}->($hx-1,$hy+1).qq{</g>\n}; }
  else { $s.=qq{<g class="arm-idle-l">}.$arml->(-3,10).qq{</g><g class="arm-idle-r">}.$armr->(3,10).qq{</g>\n}; }
  $s.=qq{<rect x="}.($x-1.6).qq{" y="}.($y-34).qq{" width="3.2" height="4" fill="$skin"/>\n};
  $s.=qq{<circle cx="$x" cy="}.($y-39).qq{" r="6.5" fill="$skin"$st/>\n};
  my $hs=$o{hairstyle}//'short';
  if ($hs eq 'short' || $hs eq 'bun') { $s.=qq{<path d="M}.($x-6.3).' '.($y-40).qq{a6.4 6.4 0 0 1 12.6 0 q-3 -2.4 -6.3 -2.4 q-3.3 0 -6.3 2.4z" fill="$hair"$st/>\n}; }
  if ($hs eq 'bun') { $s.=qq{<circle cx="}.($x+5).qq{" cy="}.($y-45).qq{" r="2.6" fill="$hair"$st/>\n}; }
  if ($hs eq 'long') { $s.=qq{<path d="M}.($x-6.6).' '.($y-39).qq{a6.6 6.6 0 0 1 13.2 0 l1 8 h-3 l-1 -6 q-3.6 -2 -7.2 0 l-1 6 h-3z" fill="$hair"$st/>\n}; }
  if (($o{hat}//'') eq 'hard') { $s.=qq{<path d="M}.($x-7.5).' '.($y-40).qq{a7.5 7.5 0 0 1 15 0z" fill="$C{coral}"$st/><rect x="}.($x-8.5).qq{" y="}.($y-41).qq{" width="17" height="2.2" rx="1" fill="$C{coral}"$st/>\n}; }
  $s.=qq{<circle cx="}.($x-2.1).qq{" cy="}.($y-39).qq{" r=".75" fill="$INK"/><circle cx="}.($x+2.1).qq{" cy="}.($y-39).qq{" r=".75" fill="$INK"/>\n};
  $s.=qq{</g>\n};
  my $oR=qq{ style="transform-origin:}.($x+6).qq{px ${army}px"}; my $oL=qq{ style="transform-origin:}.($x-6).qq{px ${army}px"};
  $s =~ s{<g class="(arm-idle-r|arm-hi-r|act-keys|act-phone|act-saw|act-cash|act-case|act-thumbs)">}{<g class="$1"$oR>}g;
  $s =~ s{<g class="(arm-idle-l|arm-hi-l|act-watch)">}{<g class="$1"$oL>}g;
  return $s; }
sub clap { my ($x,$y)=@_; push @pts,[$x-6,$y-6],[$x+6,$y+6]; return qq{<g class="clap"><path d="M$x }.($y-6).qq{v3M$x }.($y+3).qq{v3M}.($x-6).qq{ $y h3M}.($x+3).qq{ $y h3M}.($x-4.2).' '.($y-4.2).qq{l2 2M}.($x+2.2).' '.($y+2.2).qq{l2 2M}.($x+4.2).' '.($y-4.2).qq{l-2 2M}.($x-2.2).' '.($y+2.2).qq{l-2 2" stroke="$C{coral}" stroke-width="1.5" stroke-linecap="round"/></g>\n}; }

sub frame { my ($inner)=@_; my ($x0,$y0,$x1,$y1)=(1e9,1e9,-1e9,-1e9); for (@pts){ $x0=$_->[0] if $_->[0]<$x0; $x1=$_->[0] if $_->[0]>$x1; $y0=$_->[1] if $_->[1]<$y0; $y1=$_->[1] if $_->[1]>$y1; } $y1=2 if $y1<2; my $pad=5; return sprintf("%.0f %.0f %.0f %.0f",$x0-$pad,$y0-$pad,($x1-$x0)+2*$pad,($y1-$y0)+2*$pad); }
sub building { my ($id,$href,$label,$body)=@_; @pts=(); my $inner=$body->(); my $vb=frame($inner);
  return qq{      <a class="plot" role="listitem" href="$href" data-p="$id" aria-label="$label bridging loans">\n        <svg class="plot-ill" viewBox="$vb" aria-hidden="true">\n$inner        </svg>\n        <span class="plot-btn">$label <span class="arr">&rarr;</span></span>\n      </a>\n\n}; }

unless ($main::NO_RUN) {
my $out = '';
my $cloud = qq{<path d="M10 40a14 14 0 0 1 12-20a18 18 0 0 1 34-4a12 12 0 0 1 20 8a10 10 0 0 1 2 16z" fill="#fff" stroke="$INK" stroke-width="2.2" stroke-linejoin="round"/>};
$out .= qq{  <!-- Illustrated street: one building per product facing the road, every building is a link -->
  <div class="hm-street">
    <div class="street-sky" aria-hidden="true">
      <svg class="cloud cloud-1" viewBox="0 -2 92 46">$cloud</svg>
      <svg class="cloud cloud-2" viewBox="0 -2 92 46">$cloud</svg>
      <svg class="cloud cloud-3" viewBox="0 -2 92 46">$cloud</svg>
    </div>

    <div class="plots" role="list" aria-label="What we lend on">

};

# 1 Residential: gabled house, blue roof, coral door, trees either side; buyer with keys
$out .= building('res','/products/residential-bridging-loans','Residential', sub { my $s='';
  $s.=backdrop(4,96,80); $s.=birds(70,-104);
  $s.=tree(-14,'tall',14,$C{coral}); $s.=tree(112,'round',12,$C{sky2});
  $s.=rect(10,-62,84,62,$C{white});
  $s.=chimney(68,-74,9,16,$C{blue});
  $s.=gable(10,84,-62,32,6,$C{blue});
  $s.=window(20,-50,18,16); $s.=window(66,-50,18,16); $s.=windowbox(20,-34,18); $s.=windowbox(66,-34,18);
  $s.=window(43,-84,18,16, rows=>2, cols=>2) if 0;
  $s.=door(43,0,18,32,$C{coral}, panes=>1);
  $s.=rect(10,-10,33,10,$C{sky},' nostroke'); $s.=rect(61,-10,33,10,$C{sky},' nostroke');
  $s.=tree(-4,'bush',12,$C{teal});
  $s.=person(124,0, top=>$C{coral}, legs=>$INK, hairstyle=>'bun', hair=>'#5a3a2a', prop=>'keys', delay=>0.3);
  $s; });

# 2 Auction: low wide bungalow, hipped roof, AUCTION board; couple high-five
$out .= building('auc','/products/auction-bridging-loans','Auction', sub { my $s='';
  $s.=backdrop(0,130,66); $s.=tree(-10,'round',12,$C{teal2});
  $s.=rect(10,-46,110,46,$C{white});
  $s.=chimney(30,-60,9,16,$C{blue});
  $s.=hip(10,110,-46,24,6,$C{blue},0.5);
  $s.=window(22,-36,22,16); $s.=window(86,-36,22,16);
  $s.=door(55,0,20,30,$INK, panes=>1);
  $s.=rect(10,-8,110,8,$C{sky},' nostroke');
  $s.=signpost(118,46,-30,20,$C{coral},'AUCTION',9);
  $s.=person(-22,0, top=>$C{sky2}, hairstyle=>'short', prop=>'hifive-r', delay=>0.1);
  $s.=person(4,0, top=>$C{teal2}, hairstyle=>'long', skin=>'#9a6a4b', prop=>'hifive-l', delay=>0.1);
  $s.=clap(-9,-44);
  $s; });

# 3 No valuation: tall townhouse with parapet, window grid; badge; caller on the phone
$out .= building('nov','/products/no-valuation-bridging-loans','No valuation', sub { my $s='';
  $s.=backdrop(-6,112,112,$C{sky2}); $s.=birds(118,-126);
  $s.=rect(10,-96,80,96,$C{sky});
  $s.=rect(6,-100,88,6,$C{white});
  $s.=chimney(20,-100,9,12,$C{blue});
  for my $r (0..2){ my $y=-88+$r*28; $s.=window(18,$y,16,18,fill=>$C{white}); $s.=window(42,$y,16,18,fill=>$C{white}) if $r<2; $s.=window(66,$y,16,18,fill=>$C{white}); }
  $s.=door(41,0,18,30,$C{coral}, panes=>1, step=>1);
  $s.=line(' stroke-width="1.6"',pt(10,-12),pt(36,-12)); $s.=line(' stroke-width="1.6"',pt(64,-12),pt(90,-12));
  $s.=badge(96,-96,17,'NO SITE','VISIT');
  $s.=tree(-6,'round',11,$C{teal2}); $s.=lamp2(132,50);
  $s.=person(110,0, top=>$C{sky2}, hairstyle=>'short', hair=>'#b9865a', prop=>'phone', delay=>0.6);
  $s; });

# 4 Refurbishment: house with two scaffold poles and boards, skip; builder sawing, client with plans
$out .= building('ref','/products/refurbishment-bridging-loans','Refurbishment', sub { my $s='';
  $s.=backdrop(0,116,78);
  $s.=rect(10,-58,96,58,$C{white});
  $s.=gable(10,96,-58,28,6,$C{sky2});
  $s.=window(20,-46,20,16); $s.=window(76,-46,20,16);
  $s.=door(49,0,18,30,$C{sky}, panes=>0);
  $s.=line(' stroke-width="2.2"',pt(14,0),pt(14,-78)); $s.=line(' stroke-width="2.2"',pt(102,0),pt(102,-78));
  $s.=rect(10,-30,96,3,$C{navy},' nostroke'); $s.=rect(10,-62,96,3,$C{navy},' nostroke');
  $s.=rect(112,-18,30,18,$C{coral}); $s.=line(' stroke-width="1.4"',pt(116,-18),pt(119,-24),pt(135,-24),pt(138,-18));
  $s.=person(-10,0, top=>$C{navy}, hivis=>1, hat=>'hard', hairstyle=>'short', prop=>'saw', delay=>0.9);
  $s.=person(156,0, top=>$C{sky2}, hairstyle=>'long', skin=>'#9a6a4b', prop=>'plan', delay=>0.4);
  $s; });

# 5 Semi-commercial: shop with flat above, awning; shopkeeper with cash
$out .= building('semi','/products/semi-commercial-bridging-loans','Semi-commercial', sub { my $s='';
  $s.=backdrop(0,128,92);
  $s.=rect(10,-76,108,76,$C{white});
  $s.=rect(6,-80,116,5,$C{blue});
  $s.=window(20,-66,18,16); $s.=window(55,-66,18,16); $s.=window(90,-66,18,16);
  $s.=rect(10,-44,108,10,$C{navy});
  $s.=qq{<text x="64" y="-36.6" text-anchor="middle" font-family="Manrope, system-ui, sans-serif" font-weight="800" font-size="7" fill="#fff" letter-spacing=".12em">CORNER SHOP</text>\n};
  for my $i (0..8){ my $x=8+$i*12.5; $s.=rect($x,-34,12.5,8,$i%2?$C{white}:$C{coral},' nostroke'); } $s.=rect(8,-34,112.5,8,'none');
  $s.=window(18,-24,56,22,fill=>$C{sky},cols=>3,rows=>1);
  $s.=door(86,0,20,26,$INK, panes=>1);
  $s.=tree(-8,'bush',14,$C{teal}); $s.=planter(122,12,9);
  $s.=person(134,0, top=>$C{teal2}, apron=>1, hairstyle=>'short', skin=>'#9a6a4b', prop=>'cash', delay=>0.4);
  $s; });

# 6 Commercial: office block, window grid, flag; broker with case, client with documents
$out .= building('com','/products/commercial-bridging-loans','Commercial', sub { my $s='';
  $s.=backdrop(-8,136,128,$C{sky}); $s.=birds(136,-130);
  $s.=rect(10,-112,100,112,$C{sky2});
  $s.=rect(6,-116,108,5,$C{white});
  for my $r (0..3){ my $y=-104+$r*24; for my $c (0..3){ my $x=18+$c*22; next if $r==3 && ($c==1||$c==2); $s.=window($x,$y,16,16,fill=>$C{sky},cols=>2,rows=>2); } }
  $s.=door(42,0,36,24,$C{sky}, panes=>0); $s.=line(' stroke-width="1.6"',pt(60,-24),pt(60,0));
  $s.=line(' stroke-width="1.8"',pt(96,-116),pt(96,-136)); $s.=poly($C{coral},'',pt(96,-136),pt(110,-132),pt(96,-128));
  $s.=tree(-6,'round',12,$C{teal2}); $s.=bench(114,22);
  $s.=person(142,0, top=>$INK, hairstyle=>'short', prop=>'case', delay=>0.7);
  $s.=person(166,0, top=>$C{teal2}, legs=>$C{sky2}, hairstyle=>'bun', hair=>'#5a3a2a', prop=>'plan', delay=>0.2);
  $s; });

# 7 Adverse credit: cottage, teal roof, APPROVED board; approval paper + thumbs-up
$out .= building('adv','/products/bad-credit-bridging-loans','Adverse credit', sub { my $s='';
  $s.=backdrop(0,116,72); $s.=tree(-10,'round',12,$C{teal2});
  $s.=rect(10,-50,96,50,$C{white});
  $s.=chimney(76,-66,9,18,$C{teal});
  $s.=gable(10,96,-50,30,6,$C{teal});
  $s.=window(20,-40,20,16); $s.=window(76,-40,20,16); $s.=windowbox(20,-24,20); $s.=windowbox(76,-24,20);
  $s.=door(49,0,18,30,$C{coral}, panes=>1);
  $s.=rect(10,-10,39,10,$C{sky},' nostroke'); $s.=rect(67,-10,39,10,$C{sky},' nostroke');
  $s.=signpost(104,50,-32,20,$C{teal2},'APPROVED',9);
  $s.=person(-28,0, top=>$C{coral}, hairstyle=>'long', hair=>'#5a3a2a', prop=>'paper', delay=>0.2);
  $s.=person(168,0, top=>$C{navy}, legs=>$C{sky2}, hairstyle=>'short', skin=>'#9a6a4b', prop=>'thumbs', delay=>0.5);
  $s; });

$out .= qq{    </div>
    <div class="swipe-badge" aria-hidden="true"><svg viewBox="0 0 40 40" fill="none" stroke="$INK" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M31 7c-6-4-15-4-22 1"/><path d="M11 5l-2 3 3.5 1.5"/><g class="swipe-hand"><path d="M17 14v10l-3-3.5c-1.2-1.2-3-.6-3 1l5 7.5c1 1.6 2.6 2.5 4.4 2.5H25c2.6 0 4.5-1.8 4.6-4.4L30 21c0-1.4-1-2.4-2.3-2.4S25.5 19.5 25.5 21M21 14v8M21 14a2 2 0 0 0-4 0M25.5 21v-3a2 2 0 0 0-4 0v4" fill="#fff"/></g></svg></div>
  </div>
};
open my $o,'>:raw',$ARGV[0] or die; print $o $out; close $o; print "written ", length($out), " bytes\n";
}
1;
