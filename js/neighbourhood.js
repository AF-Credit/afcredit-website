(() => {
  const control = document.querySelector('.motion-toggle');
  if (!control) return;
  const reduced = matchMedia('(prefers-reduced-motion: reduce)');
  let paused = reduced.matches;
  function render() {
    document.body.classList.toggle('scene-paused', paused);
    document.body.classList.toggle('scene-playing', !paused);
    control.setAttribute('aria-pressed', String(paused));
    control.textContent = paused ? 'Play movement' : 'Pause movement';
  }
  control.hidden = false;
  control.addEventListener('click', () => { paused = !paused; render(); });
  reduced.addEventListener('change', () => { paused = reduced.matches; render(); });
  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver(entries => entries.forEach(entry => {
      entry.target.classList.toggle('scene-offscreen', !entry.isIntersecting);
    }));
    document.querySelectorAll('.people-scene').forEach(scene => observer.observe(scene));
  }
  render();
  const scenes = [...document.querySelectorAll('.people-scene')].map(svg => ({svg, time:0}));
  const smooth = x => {x=Math.max(0,Math.min(1,x));return x*x*(3-2*x);};
  const lerp = (a,b,t) => a+(b-a)*t;
  function update(svg,time) {
    const painter=svg.querySelector('.wall-paint');
    if(painter){
      const dy=4*Math.sin(time*Math.PI/2200);
      painter.querySelector('.paint-tool').setAttribute('transform',`translate(0 ${dy})`);
      painter.querySelector('.paint-arm').setAttribute('d',`M10-57Q20-53 19-44L25 ${-34+dy} 22 ${-30+dy} 14-40 8-48Z`);
    }
    const actor=svg.querySelector('.delivery');
    if(!actor)return;
    const t=(time/1000)%14;
    let parcel, bend, release;
    if(t<1){parcel=0;bend=0;release=0;}
    else if(t<4){parcel=bend=smooth((t-1)/3);release=0;}
    else if(t<5){parcel=1;release=smooth(t-4);bend=1-release;}
    else if(t<8){parcel=1;bend=0;release=1;}
    else if(t<9){parcel=1;bend=smooth(t-8);release=1-bend;}
    else if(t<12){parcel=bend=1-smooth((t-9)/3);release=0;}
    else{parcel=0;bend=0;release=0;}
    const angle=bend*32*Math.PI/180, shift=bend*8;
    const point=(x,y)=>[182+(x-182)*Math.cos(angle)-(y-166)*Math.sin(angle),166+shift+(x-182)*Math.sin(angle)+(y-166)*Math.cos(angle)];
    actor.querySelector('.delivery-upper').setAttribute('transform',`translate(0 ${shift}) rotate(${bend*32} 182 166)`);
    actor.querySelector('.delivery-legs').setAttribute('d',`M174 ${164+shift}L${170-bend*4} 181 170 193H177L183 ${174+shift} 187 193H195L${199+bend*2} 180 192 ${164+shift}Z`);
    actor.querySelector('.delivery-parcel').setAttribute('transform',`translate(0 ${parcel*28})`);
    const a=point(177,142),b=point(190,142);
    const handA=[lerp(202,a[0]-3,release),lerp(165+parcel*28,a[1]+31,release)];
    const handB=[lerp(219,b[0]+5,release),lerp(165+parcel*28,b[1]+31,release)];
    const arm=(s,h)=>{
      const dx=h[0]-s[0],dy=h[1]-s[1],length=Math.hypot(dx,dy)||1;
      const nx=-dy/length,ny=dx/length;
      const cx=(s[0]+h[0])/2-4,cy=Math.max(s[1],h[1])-3;
      return `M${s[0]+nx*3} ${s[1]+ny*3}Q${cx+nx*2.5} ${cy+ny*2.5} ${h[0]+nx*1.8} ${h[1]+ny*1.8}L${h[0]-nx*1.8} ${h[1]-ny*1.8}Q${cx-nx*2.5} ${cy-ny*2.5} ${s[0]-nx*3} ${s[1]-ny*3}Z`;
    };
    ['.delivery-arm-back','.delivery-arm-line'].forEach(c=>actor.querySelector(c).setAttribute('d',arm(a,handA)));
    ['.delivery-arm-front','.delivery-arm-outline'].forEach(c=>actor.querySelector(c).setAttribute('d',arm(b,handB)));
    actor.querySelector('.delivery-hands').setAttribute('d',`M${handA[0]} ${handA[1]}l3 1M${handB[0]} ${handB[1]}l3-1`);
  }
  scenes.forEach(scene=>update(scene.svg,0));
  let last;
  function frame(now){
    const delta=last===undefined?0:Math.min(now-last,80);last=now;
    if(!paused&&!document.hidden)scenes.forEach(scene=>{
      if(!scene.svg.classList.contains('scene-offscreen')){scene.time+=delta;update(scene.svg,scene.time);}
    });
    requestAnimationFrame(frame);
  }
  requestAnimationFrame(frame);
})();
