/* Google tag (gtag.js) — GA4, loaded only after cookie consent */
(function () {
  var CONSENT_KEY = 'af-cookie-consent';

  function loadAnalytics() {
    var s = document.createElement('script');
    s.async = true;
    s.src = 'https://www.googletagmanager.com/gtag/js?id=G-BZV2Q4DPKD';
    document.head.appendChild(s);
    window.dataLayer = window.dataLayer || [];
    function gtag() { dataLayer.push(arguments); }
    gtag('js', new Date());
    gtag('config', 'G-BZV2Q4DPKD');
  }

  function getConsent() {
    try { return localStorage.getItem(CONSENT_KEY); } catch (e) { return null; }
  }
  function setConsent(value) {
    try { localStorage.setItem(CONSENT_KEY, value); } catch (e) {}
  }

  function showBanner() {
    var banner = document.createElement('div');
    banner.id = 'cookie-banner';
    banner.setAttribute('role', 'dialog');
    banner.setAttribute('aria-label', 'Cookie consent');
    banner.style.cssText = 'position:fixed;bottom:0;left:0;right:0;z-index:9999;background:#1b2b3b;color:#fff;padding:18px 20px;box-shadow:0 -4px 20px rgba(0,0,0,.25);font-family:Inter,system-ui,sans-serif';
    banner.innerHTML =
      '<div style="max-width:1100px;margin:0 auto;display:flex;flex-wrap:wrap;gap:14px;align-items:center;justify-content:space-between">'
      + '<p style="margin:0;font-size:14px;font-weight:300;line-height:1.6;flex:1 1 420px">We use one optional analytics cookie (Google Analytics) to understand how this site is used. No advertising or tracking cookies. See our <a href="/cookie-policy" style="color:#ff8a8b;text-decoration:underline">Cookie Policy</a>.</p>'
      + '<div style="display:flex;gap:10px;flex-shrink:0">'
      + '<button id="cookie-decline" style="background:transparent;color:#fff;border:1px solid rgba(255,255,255,.4);border-radius:8px;padding:10px 18px;font-size:14px;cursor:pointer">Decline</button>'
      + '<button id="cookie-accept" style="background:#ff6a6b;color:#fff;border:none;border-radius:8px;padding:10px 22px;font-size:14px;font-weight:600;cursor:pointer">Accept</button>'
      + '</div></div>';
    document.body.appendChild(banner);
    document.getElementById('cookie-accept').addEventListener('click', function () {
      setConsent('accepted');
      banner.remove();
      loadAnalytics();
    });
    document.getElementById('cookie-decline').addEventListener('click', function () {
      setConsent('declined');
      banner.remove();
    });
  }

  function init() {
    var choice = getConsent();
    if (choice === 'accepted') {
      loadAnalytics();
    } else if (choice !== 'declined') {
      showBanner();
    }
    /* "Manage cookie preferences" reset link (cookie policy page) */
    var reset = document.getElementById('cookie-reset');
    if (reset) {
      reset.addEventListener('click', function (e) {
        e.preventDefault();
        try { localStorage.removeItem(CONSENT_KEY); } catch (err) {}
        location.reload();
      });
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();

(function () {
  'use strict';

  /* ─── Logo HTML ─────────────────────────────────────────────── */
  var LOGO_HTML = function(white) {
    var src = white
      ? '/images/af-credit-white-logo.png'
      : '/images/af-credit-logo.png';
    return '<a href="/" class="logo" aria-label="AF Credit home">'
      + '<img src="' + src + '" alt="AF Credit" class="logo-img" width="160" height="40">'
      + '</a>';
  };

  /* ─── NAV HTML ──────────────────────────────────────────── */
  var NAV = '<header class="site-header">'
    + '<div class="nav-wrap">'
    + LOGO_HTML(false)
    + '<nav aria-label="Main navigation">'
    + '<button class="nav-toggle" id="navToggle" aria-label="Toggle menu" aria-expanded="false">'
    + '<span></span><span></span><span></span>'
    + '</button>'
    + '<ul class="nav-links" id="navLinks" role="list">'
    + '<li class="has-dropdown" id="productsLi">'
    + '<a href="/products" class="nav-btn" id="productsBtn" aria-expanded="false">Products <span class="nav-chevron">&#9662;</span></a>'
    + '<div class="dropdown-menu" role="region" aria-label="Products menu">'
    + '<div class="dd-col">'
    + '<span class="dd-heading">By property type</span>'
    + '<a href="/products/residential-bridging-loans"><span class="dd-icon">🏠</span><span class="dd-text"><strong>Residential Bridging</strong><span>Houses &amp; flats, all conditions</span></span></a>'
    + '<a href="/products/auction-bridging-loans"><span class="dd-icon">🔨</span><span class="dd-text"><strong>Auction Finance</strong><span>Complete in 28 days, guaranteed</span></span></a>'
    + '<a href="/products/commercial-bridging-loans"><span class="dd-icon">🏢</span><span class="dd-text"><strong>Commercial Bridging</strong><span>Offices, retail, industrial, leisure</span></span></a>'
    + '<a href="/products/semi-commercial-bridging-loans"><span class="dd-icon">🏪</span><span class="dd-text"><strong>Semi-Commercial</strong><span>Mixed-use &amp; shop-with-flat above</span></span></a>'
    + '<a href="/products/refurbishment-bridging-loans"><span class="dd-icon">🔧</span><span class="dd-text"><strong>Refurbishment Finance</strong><span>Light &amp; heavy refurb, staged drawdown</span></span></a>'
    + '</div>'
    + '<div class="dd-col">'
    + '<span class="dd-heading">By speciality</span>'
    + '<a href="/products/no-valuation-bridging-loans"><span class="dd-icon">⚡</span><span class="dd-text"><strong>No Valuation Bridging</strong><span>AVM or desktop — skip the survey</span></span></a>'
    + '<a href="/products/avm-bridging-loans"><span class="dd-icon">🤖</span><span class="dd-text"><strong>AVM Bridging Loans</strong><span>Instant algorithm valuation, £0 cost</span></span></a>'
    + '<a href="/products/desktop-valuation-bridging-loans"><span class="dd-icon">💻</span><span class="dd-text"><strong>Desktop Valuation</strong><span>RICS remote survey, 48–72 hrs</span></span></a>'
    + '<a href="/products/bad-credit-bridging-loans"><span class="dd-icon">🔑</span><span class="dd-text"><strong>Bad Credit Bridging</strong><span>CCJs, defaults &amp; IVAs considered</span></span></a>'
    + '</div>'
    + '<div class="dd-col-cta">'
    + '<div class="dd-cta-card">'
    + '<strong>Get a quote today</strong>'
    + '<p>Same-day indicative terms from a direct principal lender.</p>'
    + '<a href="/contact">Speak to an expert →</a>'
    + '</div>'
    + '</div>'
    + '</div>'
    + '</li>'
    + '<li><a href="/blog">Guides</a></li>'
    + '<li><a href="/case-studies">Case Studies</a></li>'
    + '<li><a href="/about">About</a></li>'
    + '<li><a href="/faq">FAQ</a></li>'
    + '<li><a href="/contact">Contact</a></li>'
    + '<li><a href="/contact" class="btn btn-primary nav-cta">Get a Quote</a></li>'
    + '</ul>'
    + '</nav>'
    + '</div>'
    + '</header>';

  /* ─── FOOTER HTML ────────────────────────────────────────── */
  var FOOTER = '<footer class="site-footer">'
    + '<div class="footer-grid">'
    + '<div class="footer-about">'
    + LOGO_HTML(true)
    + '<p>Specialist Bridging Finance for property professionals and investors across England and Wales.</p>'
    + '<div class="footer-contact-info">'
    + '<a href="tel:01451514563"><svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M6.6 10.8c1.4 2.8 3.8 5.1 6.6 6.6l2.2-2.2c.3-.3.7-.4 1-.2 1.1.4 2.3.6 3.6.6.6 0 1 .4 1 1V20c0 .6-.4 1-1 1-9.4 0-17-7.6-17-17 0-.6.4-1 1-1h3.5c.6 0 1 .4 1 1 0 1.3.2 2.5.6 3.6.1.3 0 .7-.2 1L6.6 10.8z"/></svg> 01451 514 563</a>'
    + '<a href="mailto:enquiries@afcredit.co.uk"><svg width="14" height="14" viewBox="0 0 24 24" fill="currentColor"><path d="M20 4H4c-1.1 0-2 .9-2 2v12c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 4l-8 5-8-5V6l8 5 8-5v2z"/></svg> enquiries@afcredit.co.uk</a>'
    + '</div>'
    + '</div>'
    + '<div class="footer-col">'
    + '<h4>Products</h4>'
    + '<ul>'
    + '<li><a href="/products/residential-bridging-loans">Residential Bridging</a></li>'
    + '<li><a href="/products/auction-bridging-loans">Auction Finance</a></li>'
    + '<li><a href="/products/no-valuation-bridging-loans">No Valuation Bridging</a></li>'
    + '<li><a href="/products/avm-bridging-loans">AVM Bridging Loans</a></li>'
    + '<li><a href="/products/desktop-valuation-bridging-loans">Desktop Valuation</a></li>'
    + '<li><a href="/products/commercial-bridging-loans">Commercial Bridging</a></li>'
    + '<li><a href="/products/semi-commercial-bridging-loans">Semi-Commercial</a></li>'
    + '<li><a href="/products/refurbishment-bridging-loans">Refurbishment Finance</a></li>'
    + '</ul>'
    + '</div>'
    + '<div class="footer-col">'
    + '<h4>Company</h4>'
    + '<ul>'
    + '<li><a href="/about">About AF Credit</a></li>'
    + '<li><a href="/case-studies">Case Studies</a></li>'
    + '<li><a href="/blog">Blog &amp; Guides</a></li>'
    + '<li><a href="/faq">FAQs</a></li>'
    + '<li><a href="/contact">Contact Us</a></li>'
    + '</ul>'
    + '</div>'
    + '<div class="footer-col">'
    + '<h4>Legal</h4>'
    + '<ul>'
    + '<li><a href="/privacy-policy">Privacy Policy</a></li>'
    + '<li><a href="/cookie-policy">Cookie Policy</a></li>'
    + '<li><a href="/terms-of-use">Terms of Use</a></li>'
    + '<li><a href="/complaints">Complaints</a></li>'
    + '</ul>'
    + '</div>'
    + '</div>'
    + '<hr class="footer-divider">'
    + '<div class="footer-legal">'
    + '<p><strong>Important information &amp; risk warning.</strong> Bridging loans are credit agreements secured against property. Your property may be repossessed if you do not repay your loan within the agreed term. Bridging finance is short-term in nature — you are responsible for ensuring any product is suitable for your individual circumstances, financial obligations, and that a clear and viable exit strategy is in place before proceeding. We strongly recommend seeking independent legal and financial advice before entering into any agreement.</p>'
    + '<p>All products, rates, and indicative terms presented on this website are subject to formal underwriting and credit approval. They do not constitute offers, commitments, or guarantees. The availability and terms of any loan are at the sole discretion of AF Credit and may differ from any initial indication provided. AF Credit makes no representation that any particular product will be available or that any terms discussed will be confirmed.</p>'
    + '<p>As part of any application, credit checks and property searches will be conducted and may be recorded on your credit file. AF Credit does not provide regulated mortgages, consumer credit agreements, or financial advice. Nothing on this website constitutes a recommendation. AF Credit lends exclusively to businesses and property professionals on an unregulated basis. Where a regulated product may be required, we will refer you to an FCA-authorised and regulated lender or broker — such referrals are made on an introductory basis only and AF Credit accepts no responsibility for advice or services provided by any third party.</p>'
    + '<p>AF Credit is a trading style of Chammosair Limited and its associated companies, registered in England and Wales (Company No. 15786496). Registered office: 4 Capricorn Centre, Cranes Farm Road, Basildon, Essex, SS14 3JJ. Registered with the Information Commissioner\'s Office (ICO) under Registration Reference ZB729589.</p>'
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
      /* On mobile: toggle dropdown instead of navigating */
      if (window.innerWidth <= 1024) {
        e.preventDefault();
        e.stopPropagation();
        var open = prodLi.classList.toggle('open');
        prodBtn.setAttribute('aria-expanded', String(open));
      }
      /* On desktop: link navigates normally; dropdown opens via CSS :hover */
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
