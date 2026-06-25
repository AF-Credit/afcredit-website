(function () {
  'use strict';

  /* Detect depth so relative links work from both root and subfolders */
  var loc  = window.location.pathname;
  var sub  = loc.indexOf('/products/') !== -1 || loc.indexOf('/blog/') !== -1 || loc.indexOf('/case-studies/') !== -1;
  var root = sub ? '../' : '';

  /* ─── Logo HTML ─────────────────────────────────────────────── */
  var LOGO_HTML = function(href, white) {
    var src = white
      ? root + 'images/White Logo AF Credit.avif'
      : root + 'images/AF Credit Logo.png';
    return '<a href="' + href + '" class="logo" aria-label="AF Credit home">'
      + '<img src="' + src + '" alt="AF Credit" class="logo-img" width="160" height="40">'
      + '</a>';
  };

  /* ─── NAV HTML ──────────────────────────────────────────── */
  var NAV = '<header class="site-header">'
    + '<div class="nav-wrap">'
    + LOGO_HTML(root + 'index.html', false)
    + '<nav aria-label="Main navigation">'
    + '<button class="nav-toggle" id="navToggle" aria-label="Toggle menu" aria-expanded="false">'
    + '<span></span><span></span><span></span>'
    + '</button>'
    + '<ul class="nav-links" id="navLinks" role="list">'
    + '<li class="has-dropdown" id="productsLi">'
    + '<button class="nav-btn" id="productsBtn" aria-expanded="false">Products &#9662;</button>'
    + '<div class="dropdown-menu" role="region" aria-label="Products menu">'
    + '<div class="dd-col">'
    + '<span class="dd-heading">By property type</span>'
    + '<a href="' + root + 'products/residential-bridging-loans.html"><span class="dd-icon">🏠</span><span class="dd-text"><strong>Residential Bridging</strong><span>Houses &amp; flats, all conditions</span></span></a>'
    + '<a href="' + root + 'products/auction-bridging-loans.html"><span class="dd-icon">🔨</span><span class="dd-text"><strong>Auction Finance</strong><span>Complete in 28 days, guaranteed</span></span></a>'
    + '<a href="' + root + 'products/commercial-bridging-loans.html"><span class="dd-icon">🏢</span><span class="dd-text"><strong>Commercial Bridging</strong><span>Offices, retail, industrial, leisure</span></span></a>'
    + '<a href="' + root + 'products/semi-commercial-bridging-loans.html"><span class="dd-icon">🏪</span><span class="dd-text"><strong>Semi-Commercial</strong><span>Mixed-use &amp; shop-with-flat above</span></span></a>'
    + '<a href="' + root + 'products/refurbishment-bridging-loans.html"><span class="dd-icon">🔧</span><span class="dd-text"><strong>Refurbishment Finance</strong><span>Light &amp; heavy refurb, staged drawdown</span></span></a>'
    + '</div>'
    + '<div class="dd-col">'
    + '<span class="dd-heading">By valuation route</span>'
    + '<a href="' + root + 'products/no-valuation-bridging-loans.html"><span class="dd-icon">⚡</span><span class="dd-text"><strong>No Valuation Bridging</strong><span>AVM or desktop — skip the survey</span></span></a>'
    + '<a href="' + root + 'products/avm-bridging-loans.html"><span class="dd-icon">🤖</span><span class="dd-text"><strong>AVM Bridging Loans</strong><span>Instant algorithm valuation, £0 cost</span></span></a>'
    + '<a href="' + root + 'products/desktop-valuation-bridging-loans.html"><span class="dd-icon">💻</span><span class="dd-text"><strong>Desktop Valuation</strong><span>RICS remote survey, 48–72 hrs</span></span></a>'
    + '</div>'
    + '<div class="dd-col-cta">'
    + '<div class="dd-cta-card">'
    + '<strong>Get a quote today</strong>'
    + '<p>Same-day indicative terms from a direct principal lender.</p>'
    + '<a href="' + root + 'contact.html">Speak to an expert →</a>'
    + '</div>'
    + '</div>'
    + '</div>'
    + '</li>'
    + '<li><a href="' + root + 'blog/index.html">Guides</a></li>'
    + '<li><a href="' + root + 'case-studies/index.html">Case Studies</a></li>'
    + '<li><a href="' + root + 'about.html">About</a></li>'
    + '<li><a href="' + root + 'faq.html">FAQ</a></li>'
    + '<li><a href="' + root + 'contact.html">Contact</a></li>'
    + '<li><a href="' + root + 'contact.html" class="btn btn-primary nav-cta">Get a Quote</a></li>'
    + '</ul>'
    + '</nav>'
    + '</div>'
    + '</header>';

  /* ─── FOOTER HTML ────────────────────────────────────────── */
  var FOOTER = '<footer class="site-footer">'
    + '<div class="footer-grid">'
    + '<div class="footer-about">'
    + LOGO_HTML(root + 'index.html', true)
    + '<p>Specialist bridging finance for property professionals, investors and homeowners across England and Wales. We are a direct principal lender — no committees, no delays.</p>'
    + '<div class="footer-contact-info">'
    + '<a href="tel:01451514563"><svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M6.6 10.8c1.4 2.8 3.8 5.1 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1-9.4 0-17-7.6-17-17 0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.3 0 .7-.2 1L6.6 10.8z"/></svg> 01451 514 563</a>'
    + '<a href="mailto:enquiries@afcredit.co.uk"><svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg> enquiries@afcredit.co.uk</a>'
    + '</div>'
    + '</div>'
    + '<div class="footer-col">'
    + '<h4>Products</h4>'
    + '<ul>'
    + '<li><a href="' + root + 'products/residential-bridging-loans.html">Residential Bridging</a></li>'
    + '<li><a href="' + root + 'products/auction-bridging-loans.html">Auction Finance</a></li>'
    + '<li><a href="' + root + 'products/no-valuation-bridging-loans.html">No Valuation Bridging</a></li>'
    + '<li><a href="' + root + 'products/avm-bridging-loans.html">AVM Bridging Loans</a></li>'
    + '<li><a href="' + root + 'products/desktop-valuation-bridging-loans.html">Desktop Valuation</a></li>'
    + '<li><a href="' + root + 'products/commercial-bridging-loans.html">Commercial Bridging</a></li>'
    + '<li><a href="' + root + 'products/semi-commercial-bridging-loans.html">Semi-Commercial</a></li>'
    + '<li><a href="' + root + 'products/refurbishment-bridging-loans.html">Refurbishment Finance</a></li>'
    + '</ul>'
    + '</div>'
    + '<div class="footer-col">'
    + '<h4>Company</h4>'
    + '<ul>'
    + '<li><a href="' + root + 'about.html">About AF Credit</a></li>'
    + '<li><a href="' + root + 'case-studies/index.html">Case Studies</a></li>'
    + '<li><a href="' + root + 'blog/index.html">Blog &amp; Guides</a></li>'
    + '<li><a href="' + root + 'faq.html">FAQs</a></li>'
    + '<li><a href="' + root + 'contact.html">Contact Us</a></li>'
    + '</ul>'
    + '</div>'
    + '<div class="footer-col">'
    + '<h4>Legal</h4>'
    + '<ul>'
    + '<li><a href="#">Privacy Policy</a></li>'
    + '<li><a href="#">Cookie Policy</a></li>'
    + '<li><a href="#">Terms of Use</a></li>'
    + '<li><a href="#">Complaints</a></li>'
    + '</ul>'
    + '</div>'
    + '</div>'
    + '<hr class="footer-divider">'
    + '<div class="footer-legal">'
    + '<p>Any property used as security may be repossessed if you do not repay your loan within the agreed term. All lending is subject to underwriting and credit approval is not guaranteed. AF Credit acts solely as a lender and does not provide financial advice. AF Credit is a trading name of [Company Name] registered in England and Wales. Company number: [XXXXXXXX]. Registered office: [Address]. Authorised and regulated by the Financial Conduct Authority. FCA number: [XXXXXX].</p>'
    + '</div>'
    + '</footer>';

  /* ─── Inject ──────────────────────────────────────────────── */
  var navEl    = document.getElementById('site-nav');
  var footerEl = document.getElementById('site-footer');
  if (navEl)    navEl.outerHTML    = NAV;
  if (footerEl) footerEl.outerHTML = FOOTER;

  /* ─── Mobile nav ──────────────────────────────────────────── */
  var toggle   = document.getElementById('navToggle');
  var links    = document.getElementById('navLinks');
  var prodLi   = document.getElementById('productsLi');
  var prodBtn  = document.getElementById('productsBtn');

  if (toggle && links) {
    toggle.addEventListener('click', function () {
      var open = links.classList.toggle('open');
      toggle.classList.toggle('open', open);
      toggle.setAttribute('aria-expanded', String(open));
    });
  }

  if (prodBtn && prodLi) {
    prodBtn.addEventListener('click', function (e) {
      e.stopPropagation();
      var open = prodLi.classList.toggle('open');
      prodBtn.setAttribute('aria-expanded', String(open));
    });
  }

  /* Close nav on outside click */
  document.addEventListener('click', function (e) {
    if (links && !e.target.closest('.nav-wrap')) {
      links.classList.remove('open');
      if (toggle) { toggle.classList.remove('open'); toggle.setAttribute('aria-expanded', 'false'); }
      if (prodLi) { prodLi.classList.remove('open'); }
      if (prodBtn) { prodBtn.setAttribute('aria-expanded', 'false'); }
    }
  });

  /* ─── FAQ accordion ──────────────────────────────────────── */
  document.querySelectorAll('.faq-q').forEach(function (btn) {
    btn.addEventListener('click', function () {
      var item = btn.closest('.faq-item');
      var open = item.classList.toggle('open');
      btn.setAttribute('aria-expanded', String(open));
    });
  });

  /* ─── Contact form ───────────────────────────────────────── */
  var form = document.getElementById('contactForm');
  if (form) {
    form.addEventListener('submit', function (e) {
      e.preventDefault();
      var btn = form.querySelector('[type=submit]');
      btn.textContent = 'Message sent — we\'ll be in touch shortly.';
      btn.disabled = true;
    });
  }

})();
