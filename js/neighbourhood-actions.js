/* People in the homepage neighbourhood.
   Every person (.pfig) shares one body and one pair of arms. Arms run
   shoulder → elbow → hand and are re-solved each frame, so they stay attached
   while the hands do each person's job. Bodies never move; eyes blink now and then.
   Honours the pause control (body.scene-paused) and off-screen scenes. */
(() => {
  const figs = [...document.querySelectorAll('.people-scene .pfig')];
  if (!figs.length) return;

  const TAU = Math.PI * 2;
  const f = n => n.toFixed(1);
  const smooth = x => { x = Math.max(0, Math.min(1, x)); return x * x * (3 - 2 * x); };
  const SH = { L: [-11, -55], R: [11, -55] };
  const REST = { L: [-14, -30], R: [14, -30] };

  function elbow(s, h, side) {
    const dx = h[0] - s[0], dy = h[1] - s[1], d = Math.hypot(dx, dy), out = side === 'L' ? -1 : 1;
    const e = [s[0] + Math.max(-5, Math.min(5, dx * 0.35)) + out * 1.5, s[1] + 13];
    const k = smooth((d - 20) / 5);
    const m = [(s[0] + h[0]) / 2 + out * 0.8, (s[1] + h[1]) / 2];
    return [e[0] + (m[0] - e[0]) * k, e[1] + (m[1] - e[1]) * k];
  }
  function setArm(g, side, h) {
    const s = SH[side], e = elbow(s, h, side);
    const d = `M${f(s[0])} ${f(s[1])}L${f(e[0])} ${f(e[1])}L${f(h[0])} ${f(h[1])}`;
    g.querySelectorAll(`.a${side}`).forEach(p => p.setAttribute('d', d));
    const c = g.querySelector(`.h${side}`);
    if (c) { c.setAttribute('cx', f(h[0])); c.setAttribute('cy', f(h[1])); }
  }
  function place(g, sel, x, y, r = 0, extra = '') {
    const el = g.querySelector(sel);
    if (el) el.setAttribute('transform', `translate(${f(x)} ${f(y)}) rotate(${f(r)})${extra}`);
  }
  const idle = (t, side) => [REST[side][0] + 0.7 * Math.sin(t * TAU / 3.6 + (side === 'L' ? 0 : 1.3)), REST[side][1]];
  const pulse = (c, a, b, hold, out) => (c < a ? 0 : c < b ? smooth((c - a) / (b - a)) : c < hold ? 1 : c < out ? 1 - smooth((c - hold) / (out - hold)) : 0);
  const rot = (p, deg) => { const a = deg * Math.PI / 180, c = Math.cos(a), s = Math.sin(a); return [p[0] * c - p[1] * s, p[0] * s + p[1] * c]; };

  const ACTIONS = {
    // chatting: every few seconds a hand comes up to make a point
    talk(g, t) {
      const k = pulse(t % 5.2, 1.2, 2.0, 3.6, 4.4);
      const wave = 1.4 * k * Math.sin(t * TAU * 1.1);
      return { L: idle(t, 'L'), R: [14 + 4 * k + wave, -30 - 16 * k] };
    },
    // holding up new house keys and giving them a jingle
    keys(g, t) {
      const h = [16 + 0.6 * Math.sin(t * TAU * 1.6), -48 + 0.8 * Math.sin(t * TAU * 3.2)];
      place(g, '.p-keys', h[0], h[1], 14 * Math.sin(t * TAU * 1.6));
      return { L: idle(t, 'L'), R: h };
    },
    // bidding: the paddle goes up, is held, comes down
    paddle(g, t) {
      const k = pulse(t % 3.4, 0.5, 1.1, 2.4, 3.0);
      const h = [15 + 2 * k, -36 - 24 * k];
      place(g, '.p-paddle', h[0], h[1], -6 * k);
      return { L: idle(t, 'L'), R: h };
    },
    // scribbling notes on a clipboard
    clipboard(g, t, st) {
      const cycle = 3.6, u = (t % cycle) / cycle, W = 0.86;
      const ys = [-46.5, -42.5, -38.5], len = [9, 9, 6];
      let tip;
      if (u < W) {
        const w = u / W, line = Math.min(2, Math.floor(w * 3)), p = w * 3 - line;
        tip = [-4 + len[line] * p, ys[line] + 0.8 * Math.sin(t * TAU * 4.5)];
        if (st.u !== undefined && u < st.u) st.pts = [];
        (st.pts = st.pts || []).push([tip, line]);
      } else {
        const k = smooth((u - W) / (1 - W));
        tip = [5 - 9 * k, -38.5 - 8 * k - 2 * Math.sin(k * Math.PI)];
      }
      if (st.u !== undefined && u < st.u) st.pts = [];
      st.u = u;
      let d = '', prev = -1;
      (st.pts || []).forEach(([p, ln]) => { d += (ln !== prev ? 'M' : 'L') + f(p[0]) + ' ' + f(p[1]); prev = ln; });
      const sc = g.querySelector('.scribble'); if (sc) sc.setAttribute('d', d);
      const pen = g.querySelector('.pen'); if (pen) pen.setAttribute('d', `M${f(tip[0])} ${f(tip[1])}l3-6`);
      return { L: [-7, -34], R: [tip[0] + 2, tip[1] - 1.5] };
    },
    // painting with a roller, up and down
    roller(g, t) {
      const k = 0.5 - 0.5 * Math.cos(t * TAU / 2.2);
      const h = [17, -38 - 22 * k];
      place(g, '.p-roller', h[0], h[1]);
      return { L: idle(t, 'L'), R: h };
    },
    // lifting a box up to the chest and putting it back down
    lift(g, t) {
      const k = pulse(t % 3.4, 0.6, 1.4, 2.2, 3.0);
      const by = -34 - 18 * k;
      place(g, '.p-box', 0, by);
      return { L: [-9.5, by + 3], R: [9.5, by + 3] };
    },
    // walking briefcase swing
    case(g, t) {
      const a = 16 * Math.sin(t * TAU / 1.9), rad = a * Math.PI / 180;
      const h = [11 + 25 * Math.sin(rad), -55 + 25 * Math.cos(rad)];
      place(g, '.p-case', h[0], h[1], -a * 0.5);
      return { L: idle(t, 'L'), R: h };
    },
    // proudly showing the approved form
    form(g, t, st, flip) {
      const cy = -47 - 2 * Math.sin(t * TAU / 2.6), ang = 3 * Math.sin(t * TAU / 2.6 + 0.6);
      place(g, '.p-form', 0, cy, ang, flip ? ' scale(-1 1)' : '');
      const l = rot([-8, 10], ang), r = rot([8, 10], ang);
      return { L: [l[0], cy + l[1]], R: [r[0], cy + r[1]] };
    },
  };

  const items = figs.map((g, i) => ({
    g, act: ACTIONS[g.dataset.act] || ACTIONS.talk, flip: g.dataset.flip === '1',
    svg: g.closest('.people-scene'), eyes: [...g.querySelectorAll('.eye')],
    t: i * 0.61, blink: 1.5 + (i * 1.37) % 3, st: {},
  }));

  function draw(it) {
    const pose = it.act(it.g, it.t, it.st, it.flip);
    setArm(it.g, 'L', pose.L);
    setArm(it.g, 'R', pose.R);
    const shut = (it.t + it.blink) % 4.6 < 0.13;
    it.eyes.forEach(e => e.setAttribute('ry', shut ? '0.25' : '1.6'));
  }
  items.forEach(draw);

  let last;
  function frame(now) {
    const dt = last === undefined ? 0 : Math.min(now - last, 80) / 1000; last = now;
    const paused = document.body.classList.contains('scene-paused') || document.hidden;
    if (!paused) items.forEach(it => {
      if (it.svg && it.svg.classList.contains('scene-offscreen')) return;
      it.t += dt; draw(it);
    });
    requestAnimationFrame(frame);
  }
  requestAnimationFrame(frame);
})();
