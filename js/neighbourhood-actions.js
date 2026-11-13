/* Character actions for the homepage neighbourhood.
   Each .act group belongs to one figure (local coordinates: feet at y=0, facing +x).
   Arms are two segments (shoulder–elbow–hand) solved every frame, so hands stay on
   their props and arms never detach. Honours the existing pause control
   (body.scene-paused) and off-screen scenes (.scene-offscreen). */
(() => {
  const acts = [...document.querySelectorAll('.people-scene .act')];
  if (!acts.length) return;

  const UP = 17, LO = 17;
  const NEAR = [9, -57], FAR = [-8, -57];
  const TAU = Math.PI * 2;
  const smooth = x => { x = Math.max(0, Math.min(1, x)); return x * x * (3 - 2 * x); };
  const f = n => n.toFixed(1);

  // Natural elbow: the upper arm hangs down from the shoulder and the forearm reaches the
  // prop; as the arm extends (e.g. carrying a case) it straightens smoothly.
  function ik(s, h) {
    const dx = h[0] - s[0], dy = h[1] - s[1], d = Math.hypot(dx, dy);
    const ex = Math.max(-5, Math.min(6, dx * 0.35));
    const e = [s[0] + ex, s[1] + 15];
    const k = smooth((d - 26) / 7);
    const m = [(s[0] + h[0]) / 2 - 1, (s[1] + h[1]) / 2];
    return { e: [e[0] + (m[0] - e[0]) * k, e[1] + (m[1] - e[1]) * k], h };
  }
  function arm(g, name, s, h) {
    const r = ik(s, h);
    const d = `M${f(s[0])} ${f(s[1])}L${f(r.e[0])} ${f(r.e[1])}L${f(r.h[0])} ${f(r.h[1])}`;
    g.querySelectorAll(`.${name}-o,.${name}-i`).forEach(p => p.setAttribute('d', d));
    const hand = g.querySelector(`.${name}-h`);
    if (hand) { hand.setAttribute('cx', f(r.h[0])); hand.setAttribute('cy', f(r.h[1])); }
  }
  const rot = (p, deg) => { const a = deg * Math.PI / 180, c = Math.cos(a), s = Math.sin(a); return [p[0] * c - p[1] * s, p[0] * s + p[1] * c]; };

  const actions = {
    // No valuation: pen moves along the three lines of the clipboard, writing as it goes.
    clipboard(g, t, st) {
      const cycle = 3.6, u = (t % cycle) / cycle;
      const writing = Math.min(u / 0.86, 1);            // last 14% of the cycle: pen lifts and returns
      const line = Math.min(2, Math.floor(writing * 3)), p = (writing * 3) - line;
      const ys = [-44.5, -39.5, -34.5], xs = [5, 5, 5], len = [9, 9, 7];
      let tip;
      if (u < 0.86) tip = [xs[line] + len[line] * p, ys[line] + 0.9 * Math.sin(t * TAU * 4.5)];
      else { const k = smooth((u - 0.86) / 0.14); tip = [12 - 7 * k, -36 - 8.5 * k - 2.5 * Math.sin(k * Math.PI)]; }
      if (st.u !== undefined && u < st.u) st.pts = [];
      st.u = u;
      if (u < 0.86) { st.pts = st.pts || []; st.pts.push(tip); }
      const sc = g.querySelector('.scribble');
      if (sc) {
        let d = ''; let prevLine = null;
        (st.pts || []).forEach(pt => { const ln = Math.round((pt[1] + 44.5) / 5); d += (ln !== prevLine ? 'M' : 'L') + f(pt[0]) + ' ' + f(pt[1]); prevLine = ln; });
        sc.setAttribute('d', d);
      }
      g.querySelector('.pen').setAttribute('d', `M${f(tip[0])} ${f(tip[1])}l3.5-7`);
      arm(g, 'far', FAR, [2, -32]);
      arm(g, 'near', NEAR, [tip[0] + 2.5, tip[1] - 2]);
    },
    // Semi-commercial: lift the box up to the chest, hold, lower it again.
    lift(g, t) {
      const cycle = 3.4, u = t % cycle;
      let k;
      if (u < 0.6) k = 0; else if (u < 1.4) k = smooth((u - 0.6) / 0.8);
      else if (u < 2.2) k = 1; else if (u < 3.0) k = 1 - smooth((u - 2.2) / 0.8); else k = 0;
      const by = -38 - 16 * k;
      g.querySelector('.box').setAttribute('transform', `translate(0 ${f(by + 38)})`);
      arm(g, 'far', FAR, [17, by + 4]);
      arm(g, 'near', NEAR, [3, by + 4]);
    },
    // Commercial: briefcase swings from the hand like a pendulum.
    case(g, t) {
      const a = 18 * Math.sin(t * TAU / 1.9);
      const r = 33, rad = a * Math.PI / 180;
      const h = [NEAR[0] + r * Math.sin(rad), NEAR[1] + r * Math.cos(rad)];
      g.querySelector('.case').setAttribute('transform', `translate(${f(h[0])} ${f(h[1])}) rotate(${f(-a * 0.55)})`);
      arm(g, 'near', NEAR, h);
    },
    // Adverse credit: hold the approved form up and show it off.
    form(g, t) {
      const cy = -57 - 3 * Math.sin(t * TAU / 2.6), cx = 14, ang = 4 * Math.sin(t * TAU / 2.6 + 0.6);
      g.querySelector('.form').setAttribute('transform', `translate(${cx} ${f(cy)}) rotate(${f(ang)})`);
      const bl = rot([-7, 10.5], ang), br = rot([7, 10.5], ang);
      arm(g, 'far', FAR, [cx + br[0], cy + br[1]]);
      arm(g, 'near', NEAR, [cx + bl[0], cy + bl[1]]);
    },
  };

  const items = acts.map((g, i) => ({ g, act: actions[g.dataset.act], svg: g.closest('.people-scene'), t: i * 0.37, st: {} }))
                    .filter(it => it.act);
  items.forEach(it => it.act(it.g, it.t, it.st));

  let last;
  function frame(now) {
    const dt = last === undefined ? 0 : Math.min(now - last, 80) / 1000; last = now;
    const paused = document.body.classList.contains('scene-paused') || document.hidden;
    if (!paused) items.forEach(it => {
      if (it.svg && it.svg.classList.contains('scene-offscreen')) return;
      it.t += dt; it.act(it.g, it.t, it.st);
    });
    requestAnimationFrame(frame);
  }
  requestAnimationFrame(frame);
})();
