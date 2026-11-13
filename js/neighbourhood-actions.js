/* Actions for four of the neighbourhood people (clipboard, box, briefcase, form).
   The figures themselves are unchanged; only the arm doing the job moves. Arms are drawn
   in the same style as the other characters' arms (light sleeve shape, thin navy outline
   inherited from .neighbour-body, small hand) and re-shaped every frame from
   shoulder → elbow → hand so they stay attached. Honours the pause control and
   off-screen scenes. Local coordinates: feet at y = 0, figure faces +x. */
(() => {
  const acts = [...document.querySelectorAll('.people-scene .act')];
  if (!acts.length) return;

  const TAU = Math.PI * 2;
  const NEAR = [9, -57], FAR = [-12, -57];
  const f = n => n.toFixed(1);
  const smooth = x => { x = Math.max(0, Math.min(1, x)); return x * x * (3 - 2 * x); };
  const pulse = (c, a, b, hold, out) => (c < a ? 0 : c < b ? smooth((c - a) / (b - a)) : c < hold ? 1 : c < out ? 1 - smooth((c - hold) / (out - hold)) : 0);
  const rot = (p, deg) => { const a = deg * Math.PI / 180, c = Math.cos(a), s = Math.sin(a); return [p[0] * c - p[1] * s, p[0] * s + p[1] * c]; };

  function elbow(s, h) {
    const dx = h[0] - s[0], dy = h[1] - s[1], d = Math.hypot(dx, dy);
    // a hand raised close to the shoulder (writing, holding up) folds the elbow back and down
    const high = smooth((-(dy) + 4 - 12) / 8 + 1) * smooth((24 - d) / 6);
    const e = [s[0] + Math.max(-5, Math.min(6, dx * 0.35)) - 6 * high, s[1] + 16 - 3 * high];
    const k = smooth((d - 28) / 7), m = [(s[0] + h[0]) / 2 - 1, (s[1] + h[1]) / 2];
    return [e[0] + (m[0] - e[0]) * k, e[1] + (m[1] - e[1]) * k];
  }
  const nrm = (a, b) => { const dx = b[0] - a[0], dy = b[1] - a[1], l = Math.hypot(dx, dy) || 1; return [-dy / l, dx / l]; };
  function sleeve(s, h) {
    const e = elbow(s, h), n1 = nrm(s, e), n2 = nrm(e, h), ne = [(n1[0] + n2[0]) / 2, (n1[1] + n2[1]) / 2];
    const w0 = 3.4, w1 = 2.7 * 2, w2 = 2.1;
    const P = (p, n, w) => `${f(p[0] + n[0] * w)} ${f(p[1] + n[1] * w)}`;
    return `M${P(s, n1, w0)}Q${P(e, ne, w1)} ${P(h, n2, w2)}L${P(h, n2, -w2)}Q${P(e, ne, -w1)} ${P(s, n1, -w0)}Z`;
  }
  function arm(g, name, s, h) {
    const p = g.querySelector('.' + name); if (p) p.setAttribute('d', sleeve(s, h));
    const c = g.querySelector('.' + name + '-h'); if (c) { c.setAttribute('cx', f(h[0])); c.setAttribute('cy', f(h[1])); }
  }

  const ACTIONS = {
    // scribbling on a clipboard; the pen writes along the lines, lifts, starts again
    clipboard(g, t, st) {
      const cycle = 3.6, u = (t % cycle) / cycle, W = 0.86, ys = [-45.5, -42, -38.5], len = [7, 7, 5];
      let tip;
      if (st.u !== undefined && u < st.u) st.pts = [];
      st.u = u;
      if (u < W) {
        const w = u / W, line = Math.min(2, Math.floor(w * 3)), p = w * 3 - line;
        tip = [6.4 + len[line] * p, ys[line] + 0.7 * Math.sin(t * TAU * 4.5)];
        (st.pts = st.pts || []).push([tip, line]);
      } else {
        const k = smooth((u - W) / (1 - W));
        tip = [11.4 - 5 * k, -38.5 - 7 * k - 2 * Math.sin(k * Math.PI)];
      }
      let d = '', prev = -1;
      (st.pts || []).forEach(([p, ln]) => { d += (ln !== prev ? 'M' : 'L') + f(p[0]) + ' ' + f(p[1]); prev = ln; });
      g.querySelector('.scribble').setAttribute('d', d);
      g.querySelector('.pen').setAttribute('d', `M${f(tip[0])} ${f(tip[1])}l2.5-5`);
      arm(g, 'far', FAR, [4, -35]);
      arm(g, 'near', NEAR, [tip[0] + 1.5, tip[1] - 1.5]);
    },
    // lifting the box up to the chest and putting it back down
    lift(g, t) {
      const k = pulse(t % 3.4, 0.6, 1.4, 2.2, 3.0), dy = -15 * k;
      g.querySelector('.box').setAttribute('transform', `translate(0 ${f(dy)})`);
      arm(g, 'far', FAR, [14, -33 + dy]);
      arm(g, 'near', NEAR, [2, -33 + dy]);
    },
    // briefcase swinging at his side
    case(g, t) {
      const a = 15 * Math.sin(t * TAU / 1.9), rad = a * Math.PI / 180, r = 34;
      const h = [NEAR[0] + r * Math.sin(rad), NEAR[1] + r * Math.cos(rad)];
      g.querySelector('.case').setAttribute('transform', `translate(${f(h[0])} ${f(h[1])}) rotate(${f(-a * 0.5)})`);
      arm(g, 'near', NEAR, h);
    },
    // holding up the approved form
    form(g, t, st, flip) {
      const cy = -50 - 2 * Math.sin(t * TAU / 2.6), cx = 14, ang = 3 * Math.sin(t * TAU / 2.6 + 0.6);
      g.querySelector('.form').setAttribute('transform', `translate(${cx} ${f(cy)}) rotate(${f(ang)})${flip ? ' scale(-1 1)' : ''}`);
      const l = rot([-6, 9], ang), r = rot([6, 9], ang);
      arm(g, 'far', FAR, [cx + r[0], cy + r[1]]);
      arm(g, 'near', NEAR, [cx + l[0], cy + l[1]]);
    },
  };

  const items = acts.map((g, i) => {
    const fig = g.closest('.neighbour');
    const flip = /scale\(-/.test(fig ? fig.getAttribute('transform') || '' : '');
    return { g, act: ACTIONS[g.dataset.act], flip, svg: g.closest('.people-scene'), t: i * 0.37, st: {} };
  }).filter(it => it.act);
  items.forEach(it => it.act(it.g, it.t, it.st, it.flip));

  let last;
  function frame(now) {
    const dt = last === undefined ? 0 : Math.min(now - last, 80) / 1000; last = now;
    const paused = document.body.classList.contains('scene-paused') || document.hidden;
    if (!paused) items.forEach(it => {
      if (it.svg && it.svg.classList.contains('scene-offscreen')) return;
      it.t += dt; it.act(it.g, it.t, it.st, it.flip);
    });
    requestAnimationFrame(frame);
  }
  requestAnimationFrame(frame);
})();
