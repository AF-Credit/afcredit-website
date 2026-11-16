(() => {
  const street = document.querySelector('.plots');
  if (!street) return;
  const hint = document.createElement('p');
  hint.className = 'street-swipe-hint';
  hint.id = 'street-swipe-hint';
  hint.hidden = true;
  hint.innerHTML = '<svg width="42" height="32" viewBox="0 0 42 32" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"><path d="M11 7H2m4-4L2 7l4 4M31 7h9m-4-4 4 4-4 4" stroke="#FF6B6B"/><path d="M16 18V9q0-4 4-4t4 4v10-4q0-3 3-3t3 3v5-2q0-3 3-3t3 3v6q0 7-8 7h-4q-4 0-7-3l-6-6q-3-3 0-5 2-1 5 1Z"/></svg><span></span>';
  street.after(hint);
  street.setAttribute('tabindex', '0');
  street.setAttribute('aria-describedby', hint.id);
  const label = hint.querySelector('span');
  function update() {
    const overflow = street.scrollWidth > street.clientWidth + 2;
    hint.hidden = !overflow;
    street.classList.toggle('has-swipe-hint', overflow);
    label.textContent = matchMedia('(pointer: coarse)').matches ? 'Swipe to explore' : 'Scroll sideways to explore';
    street.setAttribute('tabindex', overflow ? '0' : '-1');
  }
  street.addEventListener('keydown', event => {
    if (!['ArrowLeft','ArrowRight'].includes(event.key)) return;
    event.preventDefault();
    street.scrollBy({left: (event.key === 'ArrowRight' ? 1 : -1) * 190, behavior: matchMedia('(prefers-reduced-motion: reduce)').matches ? 'instant' : 'smooth'});
  });
  new ResizeObserver(update).observe(street);
  update();
})();
