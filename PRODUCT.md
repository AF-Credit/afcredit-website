# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

Two audiences of equal weight, both in England and Wales:

- Property investors: landlords, auction buyers, refurbishment investors, SPVs and limited companies. Typical situation: a deadline (28-day auction, a bridge about to expire, a lender that has withdrawn) or a property a mortgage lender will not touch yet (uninhabitable, tenanted, awkward title, mixed-use). Job: get a straight answer on whether the deal can be funded, what it costs, and complete on time.
- Brokers and introducers placing cases for those investors. Job: a lender that answers quickly, speaks directly to the underwriter, protects the client relationship and pays a procuration fee on completion.

## Product Purpose

AF Credit is a direct (principal) bridging lender. It lends its own capital from £10,000 to £2,000,000, secured on investment, semi-commercial and commercial property, with indicative terms the day of enquiry and completions in 5 to 10 working days on clean cases. Success is a funded deal completed inside the borrower's deadline, and a broker who places the next case too.

## Positioning

The underwriter who reads the case is the person who decides it, because AF Credit lends its own money. No valuation routes (AVM to 65% LTV at no fee, desktop valuation to 75%) remove the surveyor visit on eligible property. Appetite for the stock other lenders avoid: auction lots, tenanted property, incomplete legal packs, unmortgageable houses, mixed-use titles, adverse credit on the borrower.

## Operating Context

Enquiries arrive by the online quote tool, phone, email and WhatsApp, directly or through a broker, often with an auction legal pack or a redemption statement attached. Hours Mon to Fri 9:00 to 17:30, Sat 9:00 to 14:00; enquiries are handled 24/7. The site is static HTML on Cloudflare Pages, deployed from GitHub (AF-Credit/afcredit-website); nav, footer and site-wide bands are injected by js/main.js; shared styles live in css/style.css.

## Capabilities and Constraints

- Unregulated bridging only. Never lends against a borrower's or close family member's own home. Investment-only chain breaks.
- First charge only. No land. No second charge. Not preventing repossession.
- Residential up to 75% LTV (including uninhabitable), semi-commercial 70%, commercial 65%. In some cases, where structure and exit support it, standard LTV limits have been exceeded.
- Rates from 0.79% a month residential and semi-commercial, 0.99% commercial. Terms 3 to 24 months. Interest retained or rolled; no early repayment charge, 3-month minimum interest, exit fee of one month's interest.
- Fees scale on the net loan: £1,000 arrangement + £375 admin + £495 legal at £10,000 net, rising to £2,000 (or 2 to 3%) + £995 + about £1,600 from £25,000 net.
- Third-party charges over a director's main residence possible in some instances, subject to credit and circumstances.
- Legal entity: Avalon Financial Limited, Co. No. 16865484, Salisbury House, London Wall, London EC2M 5QQ. No ICO number is shown until Avalon is registered.
- No Trustpilot or review widgets. No named solicitor firms or clients. Auction houses and platforms may be named.

## Brand Commitments

- Name: AF Credit. Logo files images/af-credit-logo.png and images/af-credit-white-logo.png; coral square mark images/logo-mark.svg.
- Colours retained: navy #1b2b3b and coral #ff6a6b.
- Voice: a confident, retail-facing lender. Institutional and concise on brand sections ("Principal lending. Decided in-house."); an experienced underwriter's voice in guides and case studies. Never frames brokers negatively. No "same-day" or "no committee" repeated more than once or twice per page.
- Binding visual references given by the owner: auracapital.co.uk and lovey.com, plus a supplied flat line-art house illustration (navy outline, flat fills, coral and teal accents). Consumer/retail feel rather than private-lender.
- Every page ends with the risk warning: "Your property may be repossessed if you do not repay a loan secured on it." All lending subject to underwriting.

## Evidence on Hand

- 21 real case studies under case-studies/ with figures and timelines (Dover £120,000 on an AVM, funding evidence overnight; Preston £65,250 tenanted auction lot, terms in 42 minutes; Coventry £260,000 semi-commercial auction, 8 days from enquiry; Leeds, Hull, Newport, Leyton, Penge and others).
- Photography under images/ (case study properties, the Georgian house used on the homepage, the refurbished new build).
- 43 guides under blog/, product pages under products/, a working quote engine in get-a-quote.html.
- Absent, do not fabricate: review scores, customer testimonials, volume or "hundreds of deals" claims, aggregate rescue counts.

## Product Principles

- Lead with the borrower's situation and the outcome, then explain the mechanism.
- Prove with real cases and real numbers; never with adjectives.
- Put the cost in writing before the borrower commits; show every fee.
- Serve brokers and investors as equals; each gets a clear route within one screen.
- Say no early when the answer is no.
