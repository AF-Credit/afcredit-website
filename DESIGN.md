---
name: AF Credit
description: Illustrated, retail-facing design system for a direct unregulated bridging lender; navy ink, coral action, sky ground, Manrope throughout.
colors:
  navy-ink: "#1b2b3b"
  navy-deep: "#10202e"
  coral: "#ff6a6b"
  coral-hover: "#e85556"
  coral-text: "#cc3e3f"
  coral-tint: "#fff0f0"
  coral-on-navy: "#ff8a8b"
  sky: "#f3f7fb"
  sky-deep: "#e7eef6"
  fill-light: "#dbe7f3"
  fill-mid: "#b9cde3"
  roof-blue: "#7c98c8"
  foliage-teal: "#2f7d6d"
  body-slate: "#3d4b5c"
  muted-slate: "#66768a"
  line: "#dde5ee"
  white: "#ffffff"
  ok-green: "#1f9d6a"
  mint-on-navy: "#7ee2b4"
  error-red: "#c0392b"
typography:
  display:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "clamp(36px, 5.4vw, 62px)"
    fontWeight: 800
    lineHeight: 1.04
    letterSpacing: "-0.035em"
  headline:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "clamp(28px, 3.8vw, 44px)"
    fontWeight: 800
    lineHeight: 1.08
    letterSpacing: "-0.03em"
  title:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "clamp(20px, 2.6vw, 28px)"
    fontWeight: 800
    lineHeight: 1.2
    letterSpacing: "-0.02em"
  subtitle:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "18px"
    fontWeight: 700
    lineHeight: 1.35
  lead:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "clamp(16px, 1.8vw, 19px)"
    fontWeight: 500
    lineHeight: 1.7
  body:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "16px"
    fontWeight: 500
    lineHeight: 1.6
  ui:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "15px"
    fontWeight: 600
    lineHeight: 1.3
  button:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "15px"
    fontWeight: 700
    lineHeight: 1
  stat:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "24px"
    fontWeight: 800
    lineHeight: 1.1
    letterSpacing: "-0.02em"
    fontFeature: "tnum"
  label:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "12px"
    fontWeight: 700
    lineHeight: 1.4
  label-caps:
    fontFamily: "Manrope, system-ui, -apple-system, sans-serif"
    fontSize: "11px"
    fontWeight: 800
    lineHeight: 1.4
    letterSpacing: "0.06em"
rounded:
  pill: "999px"
  panel: "22px"
  inner: "16px"
  sm: "14px"
  field: "12px"
  chip: "10px"
  focus: "6px"
spacing:
  container-max: "1240px"
  gutter: "clamp(20px, 5vw, 56px)"
  section: "clamp(64px, 8vw, 104px)"
  section-mobile: "56px"
  nav-height: "76px"
  panel-pad: "clamp(28px, 3.5vw, 40px)"
  card-pad: "28px"
  grid-gap: "24px"
  grid-gap-sm: "18px"
  button-gap: "12px"
  list-gap: "10px"
components:
  button-primary:
    backgroundColor: "{colors.coral}"
    textColor: "{colors.white}"
    typography: "{typography.button}"
    rounded: "{rounded.pill}"
    padding: "14px 28px"
    height: "52px"
  button-primary-hover:
    backgroundColor: "{colors.coral-hover}"
    textColor: "{colors.white}"
  button-navy:
    backgroundColor: "{colors.navy-ink}"
    textColor: "{colors.white}"
    typography: "{typography.button}"
    rounded: "{rounded.pill}"
    padding: "14px 28px"
    height: "52px"
  button-navy-hover:
    backgroundColor: "{colors.navy-deep}"
    textColor: "{colors.white}"
  button-outline:
    backgroundColor: "transparent"
    textColor: "{colors.navy-ink}"
    typography: "{typography.button}"
    rounded: "{rounded.pill}"
    padding: "14px 28px"
    height: "52px"
  button-outline-hover:
    backgroundColor: "{colors.navy-ink}"
    textColor: "{colors.white}"
  button-ghost:
    backgroundColor: "transparent"
    textColor: "{colors.white}"
    typography: "{typography.button}"
    rounded: "{rounded.pill}"
    padding: "14px 28px"
    height: "52px"
  button-ghost-hover:
    backgroundColor: "rgba(255,255,255,0.1)"
    textColor: "{colors.white}"
  button-soft:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    typography: "{typography.button}"
    rounded: "{rounded.pill}"
    padding: "14px 28px"
    height: "52px"
  nav-link:
    backgroundColor: "transparent"
    textColor: "{colors.navy-ink}"
    typography: "{typography.ui}"
    rounded: "{rounded.pill}"
    padding: "10px 14px"
  nav-link-hover:
    backgroundColor: "{colors.sky}"
    textColor: "{colors.navy-ink}"
  nav-dropdown:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.panel}"
    padding: "24px"
    width: "720px"
  card:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.panel}"
    padding: "{spacing.card-pad}"
  panel:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.panel}"
    padding: "{spacing.panel-pad}"
  panel-navy:
    backgroundColor: "{colors.navy-ink}"
    textColor: "{colors.white}"
    rounded: "{rounded.panel}"
    padding: "{spacing.panel-pad}"
  calculator-card:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.panel}"
    padding: "24px 26px"
  calculator-readout:
    backgroundColor: "{colors.sky}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.chip}"
    padding: "8px 12px"
  calculator-result:
    backgroundColor: "{colors.sky}"
    textColor: "{colors.navy-ink}"
    typography: "{typography.stat}"
    rounded: "{rounded.inner}"
    padding: "16px 18px"
  stat-tile:
    backgroundColor: "{colors.sky}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.sm}"
    padding: "14px 16px"
  criteria-chip:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.inner}"
    padding: "16px 18px"
  badge:
    backgroundColor: "{colors.coral-tint}"
    textColor: "{colors.coral-text}"
    typography: "{typography.label-caps}"
    rounded: "{rounded.pill}"
    padding: "4px 10px"
  flag:
    backgroundColor: "{colors.navy-ink}"
    textColor: "{colors.white}"
    typography: "{typography.label}"
    rounded: "{rounded.pill}"
    padding: "7px 12px"
  input:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.field}"
    padding: "13px 16px"
  faq-item:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.inner}"
    padding: "0 22px"
  road-dot:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.pill}"
    size: "70px"
  road-dot-coral:
    backgroundColor: "{colors.coral}"
    textColor: "{colors.white}"
    rounded: "{rounded.pill}"
    size: "70px"
  picker-tab-selected:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    rounded: "{rounded.inner}"
    padding: "14px 16px"
  fab:
    backgroundColor: "{colors.navy-ink}"
    textColor: "{colors.white}"
    typography: "{typography.button}"
    rounded: "{rounded.pill}"
    padding: "14px 22px"
  cookie-banner:
    backgroundColor: "{colors.white}"
    textColor: "{colors.navy-ink}"
    padding: "16px 20px"
  footer:
    backgroundColor: "{colors.navy-deep}"
    textColor: "{colors.white}"
    padding: "72px 0 56px"
---

# Design System: AF Credit

## Overview

**Creative North Star: "The Illustrated High Street"**

AF Credit is a direct, unregulated bridging lender for property investors and brokers, and its site is built to look like a consumer product people are happy to use rather than a private lender's brochure. The visual world is a light, drawn high street: a pale sky ground, white panels, navy line-art houses with flat pastel fills, and a single coral action colour that marks the one thing to do next. The property types the lender funds are literally the buildings on the street, and the first thing a visitor can do is price a loan. The system refuses the category's dark photo hero with a glass card and the "three equal cards then a table" scaffold.

Density is generous but not sparse: 1240px container, sections breathing at roughly 64 to 104px, cards padded 28 to 40px, and a 76px sticky nav. Tone is confident and institutional in brand sections, with an underwriter's plain voice in guides. Headings are set heavy (Manrope 800, tight tracking) and carry their own weight; there are no eyebrow kickers to prop them up. Depth is soft and navy-tinted: every surface sits on a hairline border and a diffuse downward shadow, and interactive surfaces lift 2 to 4px on hover. Numbers are the proof, so they are set large, heavy and tabular.

Confirmed visual rejections: dark navy photo heroes, glassmorphism, stock 3D renders, emoji used as icons, eyebrow labels on new homepage work, review widgets and testimonial carousels.

**Key Characteristics:**
- Light sky ground (`sky`) alternating with white sections; navy (`navy-ink`) is ink, not background, except for deliberate dark bands.
- One action colour: coral. Everything that is clickable-and-primary is a coral pill.
- Flat line-art SVG illustration: 2 to 2.5px navy strokes, round joins, flat fills in pale blue, slate-blue roofs, coral doors and one coral tree, teal bushes, outlined white clouds.
- Manrope only, weights 500 to 800; display at 800 with negative tracking, body at 500.
- Pills for buttons and chips; 22px panels, 16px inner blocks, 14px small tiles, 12px fields.
- Soft offset shadows tinted navy; hover lifts; one easing curve (`cubic-bezier(.2,.8,.2,1)`).
- Figures are the hero: tabular-nums, 800 weight, coral only when the figure is the point.

## Colors

A two-colour brand (navy ink and coral) resting on a sky-blue ground, extended by a short family of illustration blues and a teal that exist only to draw the street.

### Primary
- **Navy Ink** (`navy-ink`): the text colour of the whole site, every heading, every illustration stroke, outline buttons, the "broker door", the no-valuation band, the floating quote button, and dark CTA sections. It is used as a surface only when a section is meant to feel like a decision: the broker door, the no-valuation band, the closing CTA.
- **Deep Navy** (`navy-deep`): the footer ground and the hover state of navy buttons. Nowhere else.

### Secondary
- **Coral** (`coral`): the single action colour. Primary buttons, the selected slider track and thumb ring, the open FAQ icon, the first "road" step, the hover state of footer social dots, selection highlight, and the focus ring. In illustration it is the front door, the sale board stripe and one tree. Coral text on white is reserved for display sizes.
- **Coral Pressed** (`coral-hover`): primary button hover, and the coral used for display-size emphasis (`em` inside `.h1`/`.h2`, the live rate in the calculator, large stat figures).
- **Coral Ink** (`coral-text`): the only coral permitted for small text on white or sky (14px links, "read more", data-row labels, timeline day markers). It passes AA where `coral` does not.
- **Coral Tint** (`coral-tint`): pale pink wash behind badges, the LTV warning inside the calculator, the notice bar and featured table rows.
- **Coral on Navy** (`coral-on-navy`): the lighter coral used for emphasised words and metric figures on navy surfaces, where `coral-text` would be too dark.

### Tertiary
- **Pale Wall Blue** (`fill-light`) and **Mid Wall Blue** (`fill-mid`): flat fills for walls, windows and ground in illustration; `fill-mid` also draws the dashed "road" line, the scrollbar thumb, breadcrumb separators and timeline dots.
- **Roof Slate Blue** (`roof-blue`): roofs in illustration and the scrollbar hover. Never text.
- **Foliage Teal** (`foliage-teal`): bushes and hedges in illustration. Never UI.
- **Tick Green** (`ok-green`) and **Mint on Navy** (`mint-on-navy`): the check marks in benefit lists, the "win" comparison card border, and the green timeline dot; mint is the same tick on navy surfaces.
- **Error Red** (`error-red`): field errors and invalid borders in forms only.

### Neutral
- **Sky Ground** (`sky`): the page ground for the homepage hero, product heroes, article headers, alternating `.soft` sections, hover wash on nav links and table rows, and the inner fill of calculator readouts and stat tiles.
- **Deeper Sky** (`sky-deep`): the unfilled slider track and image placeholders.
- **Panel White** (`white`): every card, panel, calculator, dropdown and the nav bar (at 92% with blur).
- **Body Slate** (`body-slate`): paragraph text under headings, card copy, FAQ answers.
- **Muted Slate** (`muted-slate`): captions, sub-labels, meta rows, table sub-text, breadcrumbs.
- **Hairline Blue** (`line`): every 1px card border, dividers, table rules, the nav's bottom edge.

### Named Rules
**The One Action Colour Rule.** Coral is the only colour that means "do this". It never decorates a section background, never fills an icon tile, and never appears on more than one primary button per viewport. Navy outline and navy solid are the secondary and tertiary actions.

**The Coral Contrast Rule.** Small coral text on white or sky is always `coral-text` (#cc3e3f). Display-size coral (headline emphasis, calculator rate, stat figures) is `coral-hover` (#e85556). White text sits on coral only inside buttons. On navy surfaces, coral becomes `coral-on-navy`.

**The Navy Ink Rule.** Headings, body on dark, illustration strokes and icon strokes are all navy-ink. There is no grey heading, no black, and no second dark.

## Typography

**Display Font:** Manrope (with system-ui, -apple-system, sans-serif)
**Body Font:** Manrope (with system-ui, -apple-system, sans-serif)
**Label/Mono Font:** none; figures use Manrope with tabular numerals.

**Character:** One geometric humanist family carries the whole site. Weight does the work: 800 with tight negative tracking for anything that must be read first, 500 for prose, 600 to 700 for UI. The result reads like a consumer fintech product, clear and warm, rather than a legal document. Loaded from Google Fonts at 500, 600, 700 and 800.

### Hierarchy
- **Display** (800, clamp(36px, 5.4vw, 62px), 1.04, -0.035em): the page `h1`. Balanced wrapping; on the homepage it is capped at 15ch and clamps slightly smaller (34 to 56px). Emphasis via `em` in `coral-hover`.
- **Headline** (800, clamp(28px, 3.8vw, 44px), 1.08, -0.03em): section `h2`. The navy no-valuation band uses the same scale at up to 42px in white.
- **Title** (800, clamp(20px, 2.6vw, 28px), 1.2, -0.02em): card and door `h3`, picker panel titles (to 32px), the calculator heading (22px).
- **Subtitle** (700, 18px, 1.35): `h4`, contact tile values, road-step and FAQ question titles (16 to 18px at 800).
- **Lead** (500, clamp(16px, 1.8vw, 19px), 1.7): the paragraph under a display or headline, in `body-slate`, max 52 to 64ch.
- **Body** (500, 16px, 1.6): default text. Article body runs 17px / 1.8 at max 760px; card copy drops to 14 to 15px / 1.7.
- **UI** (600, 15px, 1.3): nav links, list items with ticks, door bullets, input text (500).
- **Button** (700, 15px, 1): all pills; nav CTA and small pills drop to 13 to 14px.
- **Stat** (800, 24px, 1.1, -0.02em, tabular): calculator results, picker stats (20px), hero facts (20px), tiles (30px), metric cells (32px). Always `font-variant-numeric: tabular-nums` where the number changes.
- **Label** (700, 12px): captions above figures, calculator sub-labels, meta rows, in `muted-slate`.
- **Label Caps** (800, 11px, 0.06em, uppercase): table headers on navy, dropdown column headings, criteria chip labels, footer column headings. Data labelling only, never a section kicker.

### Named Rules
**The No-Kicker Rule.** Headings carry their own weight. New homepage work does not add an eyebrow or kicker above a heading; the `.eyebrow` class exists for legacy product pages only.

**The Heavy Figures Rule.** Any number that is the point (rate, LTV, loan size, days) is set at 800 in the stat scale with tabular numerals, in navy by default and coral-hover only when it is the single figure the viewer came for.

## Layout

The page is a single 1240px column (`container-max`) with fluid gutters of clamp(20px, 5vw, 56px). Sections stack with a vertical rhythm of clamp(64px, 8vw, 104px) (56px below 640px) and alternate between white and the sky ground; dark navy sections are reserved for a deliberate decision moment (closing CTA, no-valuation band) and never run back to back.

The sticky white header is 76px tall with a 1px hairline underneath and a 10px backdrop blur. Logo left (44px tall), pill nav links right, a coral pill CTA last. The products item opens a 720px mega-menu on hover: two link columns separated by a hairline and a navy CTA card on the right.

Grids are plain CSS grid: two-column feature layouts at 1fr 1fr with a gap of clamp(36px, 7vw, 80px); three-up card grids with a 24px gap (18px for small cards); four-up for the "road" and criteria chips. The homepage hero is a 1.15fr / 0.95fr split: copy left, the calculator card right, and beneath both a full-width illustrated street that the card overlaps by 56px. Product pages use a 1fr / 280px sidebar grid with a sticky navy "speak to us" card at 92px from the top.

Breakpoints, by observed behaviour:
- **1100px**: three-up grids become two-up; the road loses its dashed line; the product hero stacks and its media panel caps at 560px.
- **1024px**: the product sidebar hides and the main column goes full width.
- **900px**: the hero, doors, picker and no-valuation band go single column; the calculator caps at 560px; the hamburger replaces the nav and the mega-menu becomes a stacked sky-tinted list; picker tabs become a horizontal scroll-snap strip.
- **767px**: the floating quote button hides and a fixed two-pill mobile action bar appears, with 72px body padding to clear it.
- **640px**: everything single column; buttons stack full width; calculator results and hero facts become two-up; section padding drops to 56px.

Readable measure is enforced by max widths rather than columns: lead 52 to 64ch, picker copy 60ch, no-valuation copy 54ch, article body 760px, FAQ 840px.

## Elevation & Depth

A hybrid: every raised surface combines a 1px hairline border (`line`) with a soft, downward, navy-tinted shadow, so depth reads even on the pale sky ground where a shadow alone would vanish. Shadows are ambient, not structural; the hierarchy comes from surface colour (sky, white, navy) first, with shadow stepping up on hover. Coral buttons carry a coral-tinted glow instead of a navy one. Nothing uses a hard or black drop shadow on a light surface.

### Shadow Vocabulary
- **Resting card** (`box-shadow: 0 12px 32px rgba(27,43,59,.08)`): doors, picker panels, selected picker tab, form cards, the call-us band, tiles on hover.
- **Lifted** (`box-shadow: 0 24px 60px rgba(27,43,59,.12)`): the hero calculator card, the mega-menu, product hero media, article lead images, and every card's hover state.
- **Coral glow** (`box-shadow: 0 8px 20px rgba(255,106,107,.28)`, hover `0 12px 28px rgba(255,106,107,.36)`): primary buttons on light surfaces. On navy surfaces the glow becomes neutral (`0 8px 20px rgba(0,0,0,.28)`).
- **Floating action** (`box-shadow: 0 10px 28px rgba(27,43,59,.3)`): the fixed navy quote button.
- **Edge bars** (`box-shadow: 0 -6px 20px rgba(27,43,59,.08)` and `0 -8px 24px rgba(27,43,59,.10)`): the mobile action bar and cookie banner, shadowed upward.
- **Slider thumb** (`box-shadow: 0 2px 8px rgba(27,43,59,.18)`): the 22px white thumb with a 3px coral ring.
- **Form focus** (`box-shadow: 0 0 0 4px rgba(255,106,107,.15)` with a `coral-text` border): text inputs. Everything else uses the global 3px coral outline offset 3px.
- **Win card** (`box-shadow: 0 10px 28px rgba(31,157,106,.12)`): the green-bordered comparison winner.

Motion is part of depth: one easing curve, `cubic-bezier(.2,.8,.2,1)`, at 0.18s for buttons, 0.25s for cards, 0.15s for colour-only changes. Hover lifts are `translateY(-2px)` for buttons and `-3px` to `-4px` for cards, always paired with the shadow stepping from resting to lifted. Clouds drift across the street at 90, 110 and 130 seconds; picker panels enter with a 0.35s fade-up; case images zoom to 1.04 over 0.6s. `prefers-reduced-motion` collapses all of it.

### Named Rules
**The Border-Plus-Shadow Rule.** A raised white surface always has both the 1px hairline and the resting shadow. A border alone is a flat tile; a shadow alone is not used.

**The Lift-on-Hover Rule.** Interactive cards and buttons move up 2 to 4px and step one shadow level on hover, with the same easing curve, and return on active. Nothing changes scale except the case-study photo.

## Shapes

The form language is round and friendly. Buttons, chips, flags, nav links and badges are full pills (999px). Panels and cards are gently rounded at 22px (`panel`); blocks inside a panel step down to 16px (`inner`), small tiles and tables to 14px (`sm`), fields and mobile nav items to 12px (`field`), and the smallest readouts and icon tiles to 10px (`chip`). The focus ring rounds to 6px. Circles are used for process dots (70px), step numerals (56px), avatars (48px), social dots (38px), FAQ toggles (28px) and timeline markers (18px).

Borders are always 1px in `line` on white; 1.5px for outline buttons and inputs; 2px navy for the road dots and feature numerals. On navy surfaces borders become `rgba(255,255,255,.12 to .14)` and inner blocks `rgba(255,255,255,.07)`. A selected or featured card switches its hairline to navy rather than adding a second colour.

Illustration geometry follows the same rules: shapes are closed paths with round joins and caps, 2 to 2.5px navy strokes that do not scale (`vector-effect: non-scaling-stroke`), flat fills with no gradients, small 2 to 3px corner radii on doors and signs, and a 3px navy ground line the buildings sit on. Clouds are white outlined blobs. Icons are 24-grid line icons at 2px stroke in `currentColor`, round caps, no fills.

## Components

### Buttons
Pills that feel like a consumer app: heavy label, generous height, a lift on hover.
- **Shape:** full pill (999px), minimum height 52px, padding 14px 28px, label 700 / 15px, inline-flex with an 8px gap for the arrow glyph, which slides 3px right on hover.
- **Primary:** coral on white text with the coral glow; hover darkens to `coral-hover`, lifts 2px and deepens the glow; active returns to rest. In the nav it shrinks to 12px 22px with no minimum height.
- **Hover / Focus:** 0.18s on the shared easing; focus-visible shows the global 3px coral outline offset 3px.
- **Outline:** 1.5px navy border, navy text, transparent; hover fills navy with white text. The secondary action beside a primary ("Place a case as a broker").
- **Navy:** solid navy, white text; hover `navy-deep` and lift. Used where coral is already spent (sidebar card, floating button, mobile bar secondary is sky with a hairline).
- **Ghost:** transparent with a 50% white border on navy sections; hover white border and 10% white wash. On the light product hero it borrows the outline look.
- **Soft:** white with a hairline, navy text; hover border turns navy. For tertiary actions in groups.
- Button groups wrap with a 12px gap; below 640px they stack and centre.

### Chips
- **Badge** (`badge`): coral tint wash with coral-ink uppercase 11px text, pill, 4px 10px. Marks a featured card.
- **Flag** (`flag`): solid navy pill with white 12px / 800 text, pinned bottom-left over a case photo ("8 days", "AVM").
- **Criteria chip** (`criteria-chip`): white 16px-radius tile with hairline, 11px caps label in muted slate over a 20px / 800 navy value. Four-up on product heroes, two-up on mobile.
- **Stat tile** (`stat-tile`): sky fill, 14px radius, 12px label over a 20px / 800 figure. Four-up inside picker panels.
- **Pill nav links**: white pill, hairline, 13px / 700 navy; hover border turns navy.
- **Audience and hero facts**: a row of `20px / 800` figures with 14px muted captions, separated above by a 12% navy hairline.

### Cards / Containers
- **Corner Style:** 22px (`panel`); inner blocks 16px.
- **Background:** white on sky sections, white on white sections (the hairline keeps them legible), navy for the broker door and no-valuation band.
- **Shadow Strategy:** resting shadow on doors and picker panels; plain hairline on generic cards and case cards until hover, when they lift 3 to 4px and take the lifted shadow.
- **Border:** 1px `line`; featured cards and the selected picker tab swap it for navy.
- **Internal Padding:** 28px for generic cards; clamp(28px, 3.5vw, 40px) for doors and picker panels; case cards use a 4:3 photo then 22 to 24px of padding with a hairline-ruled data list (86px label column, 14px text).
- **Door** (homepage): a 120px-tall illustration at the top, title, copy, a tick list in `ok-green`, buttons pinned to the bottom. The broker door inverts to navy with mint ticks.
- **No-valuation band**: a navy 22px panel split 1.1fr / 0.9fr, white headline, two "route" rows (7% white fill, 14% white border, 16px radius) with a 26px / 800 figure and a tiny caps caption, and a line-art illustration on the right that hides below 900px.

### Inputs / Fields
- **Style:** white, 1.5px hairline, 12px radius, 13px 16px padding, 15px / 500 navy text, placeholder in a mid slate; labels 14px / 700 navy above, 7px gap; two-up rows collapse at 640px.
- **Focus:** border turns coral-ink with a 4px coral wash ring; no outline.
- **Error / Disabled:** border and ring go `error-red`; a 13px / 600 error line with a warning glyph sits 6px below; a pale red summary card (12px radius) sits above the form.
- **Range sliders** (calculator): 6px track, coral fill to the left of the thumb and `sky-deep` to the right; 22px white thumb with a 3px coral ring and a soft shadow; the live value sits in a sky readout chip (10px radius, 800 / 16px, right-aligned, tabular) beside the label.

### Navigation
- Sticky 76px white bar at 92% opacity with a 10px blur and a hairline bottom edge. Logo left; pill links (15px / 600 navy, 10px 14px) that wash sky on hover; a phone link at 700 with a 16px line icon; a coral pill CTA last.
- Products opens a 720px mega-menu 10px below: white, 22px radius, 24px padding, lifted shadow. Columns have an 11px caps heading in muted slate, rows of 34px sky icon tiles (10px radius) with a 14px / 700 title and 12px muted description, hover washing sky. The right column is a navy 16px-radius CTA card with a coral pill.
- Mobile (900px and below): a 22px three-bar hamburger that crosses into an X; links drop into a white sheet under the bar with the lifted shadow; the dropdown becomes a sky-tinted stacked list without icons or the CTA card; the phone link hides and the CTA pill goes full width.
- Breadcrumbs are 13px / 600 muted slate with `fill-mid` chevrons; the current page is navy.
- Footer: deep navy ground, 72px top padding, a 1.5fr 1fr 1fr 1fr grid (two-up at 1100px, one at 640px), 12px caps column headings at 50% white, 14px links at 65% white turning white on hover, 38px circular social dots that fill coral on hover, a group line with a monochrome partner logo, and a 12px / 35% legal block ending with the risk warning.
- Floating quote button: fixed bottom-right navy pill with a coral lightning glyph, hidden below 767px where the two-pill mobile bar (coral primary, sky secondary) takes over. Cookie banner: a white bottom sheet with an upward shadow, 14px copy, a coral "Accept" pill and a hairline "Decline" pill.

### Calculator Card (signature)
The first thing a visitor can do. A white 22px panel with the lifted shadow, 24px 26px padding, overlapping the street's roofline by 56px. A 22px / 800 title, a 14px muted sub-line, three slider rows, then a sky 16px-radius result block split in two: "Illustrative rate" in `coral-hover` and "Interest over the term" in navy, both 24px / 800 tabular, re-counting as sliders move. A full-width coral pill carries the figures to the full quote; a 12px muted note closes it. The LTV warning is a coral-tint 10px-radius strip in a darker coral that appears only above 75%.

### Illustrated Street (signature)
A full-width inline SVG (viewBox 1440 x 330) beneath the hero: a terrace, an auction lot with a sale board, a shop with a flat above, a scaffolded refurb and a cottage, standing on a 3px navy ground line that continues as a 6px navy strip. Strokes 2.5px navy (3px for the ground), round joins and caps, non-scaling. Fills: white and pale wall blue for walls, mid wall blue for ground and chimneys, roof slate blue for roofs, coral for doors, the sale-board stripe and one tree, teal for bushes; three white outlined clouds drift continuously. The same vocabulary at 220 x 120 draws the door illustrations and the no-valuation panel art.

### Product Picker
A 320px / 1fr grid. Tabs are 16px-radius rows with a 28px line icon, a 15px / 800 name and a 12px muted caption; hover gives white with a hairline, selected gives white, a navy border and the resting shadow. The panel is a white 22px card with a 24 to 32px title, 16px copy, a four-up stat-tile row, a tick list and a button group; it fades up 8px over 0.35s on change. Below 900px the tabs become a scroll-snap strip and captions hide.

### Road (how it works)
Four steps on a dashed `fill-mid` line (14px dash, 12px gap) at 34px from the top. Each step has a 70px white circle with a 2px navy ring and a 30px line icon; the first circle is solid coral with a white icon. A 12px / 800 coral-ink "when" line, an 18px / 800 title, 15px body-slate copy. Two-up at 1100px (line hidden), one-up at 640px.

### FAQ Accordion
840px max, white 16px-radius items with a hairline, 10px apart, 22px horizontal padding. The question is a 16px / 800 navy button with a 28px sky circle "+" on the right; open state turns the border navy and the circle coral with a 45-degree rotation; answers are 15px / 1.8 body slate with coral-ink links.

### Tables
Comparison and value tables are white with a hairline and 14 to 22px radius; header row solid navy with 12px caps white text; 14 to 15px cells ruled by hairlines; row hover and highlighted rows wash sky; featured rows wash coral tint; the rate column is 16px / 800 coral-ink; row actions are small coral pills. Tables scroll horizontally inside a rounded wrapper below 780px with a muted hint beneath.

## Do's and Don'ts

### Do:
- **Do** keep the palette to navy `#1b2b3b` ink and coral `#ff6a6b` action on the sky ground `#f3f7fb`; the illustration blues and teal exist only to draw buildings and foliage.
- **Do** set every button as a pill (999px) at minimum height 52px, 700 / 15px, with the lift and shadow step on hover.
- **Do** use `coral-text` (#cc3e3f) for any coral text at small sizes on white or sky, `coral-hover` (#e85556) for display-size coral, and white-on-coral only inside buttons.
- **Do** use 22px for panels and cards, 16px for blocks inside them, 14px for small tiles and 12px for fields, with a 1px `line` hairline on every white surface.
- **Do** draw every icon and illustration as inline SVG: navy 2 to 2.5px strokes, round joins and caps, flat fills from the illustration palette, outlined clouds.
- **Do** set figures that matter at 800 in the stat scale with tabular numerals, and let them re-count when inputs change.
- **Do** give every interactive surface the one easing curve `cubic-bezier(.2,.8,.2,1)`, a 2 to 4px lift, and nothing under `prefers-reduced-motion`.
- **Do** alternate white and sky sections, and spend navy surfaces on one decision moment per page.
- **Do** serve investors and brokers as equals in the same viewport: two doors, same size, same weight, one inverted to navy.
- **Do** end every page with the risk warning in the footer legal block.

### Don't:
- **Don't** use emoji as icons anywhere; draw the SVG.
- **Don't** add eyebrow or kicker labels above headings on new homepage work; headings stand alone.
- **Don't** put white text on coral outside a button, and don't use raw `coral` (#ff6a6b) for small text on white or sky.
- **Don't** use stock photography heroes with dark overlays, 3D renders, glassmorphism or gradients; the world is flat, light and drawn.
- **Don't** introduce a second display face, a serif, or Manrope weights outside 500 to 800.
- **Don't** use grey, black or hard-edged shadows on light surfaces; shadows are navy-tinted and diffuse, coral-tinted under primary buttons.
- **Don't** claim or imply FCA regulation; the lender is unregulated and the copy says so where it matters.
- **Don't** frame brokers negatively, in copy or in visual hierarchy; the broker door is never smaller, dimmer or lower than the investor door.
- **Don't** add self-counting stat blocks (deal counts, "hundreds of cases", rescue tallies, review scores); proof is a real case with real figures.
- **Don't** add review widgets, testimonial carousels or named third-party logos beyond the group company in the footer.

## Illustration system: isometric models

All new illustration on the site is **isometric low-poly 3D** (2:1 projection, viewer front-left), generated from `tools/iso.pl` (street buildings) and `tools/scenes.pl` (standalone scenes). Do not mix it with the earlier line-art or clay styles.

- **Geometry.** `iso(u,v,h)`: `x = (u − v)·0.866`, `y = (u + v)·0.5 − h`. Visible faces are the right face (u = max, lit), the left face (v = max, shaded) and the top. Every model sits on a green plinth (`green` material, 8–9 units thick) with a soft radial shadow beneath.
- **Materials** (top / right / left): yellow `#ffe68a #fbd04f #e2ad2b`, blue `#9ad6ff #47a9f1 #2a7cc2`, cream `#fffaf0 #f7eedb #dccaa9`, sage `#dcf0cf #aed79f #7fb272`, slate `#e6edf6 #c9d7e7 #97adc7`, brick `#f6bfa3 #e6967a #bf6c54`, teal `#b2e6da #67c1ae #3f9583`, glass `#d7efff #86c6f3 #4f96c9`, navy `#4a5f78 #2f4458 #1b2b3b`, coral `#ff9a94 #ff6a6b #d64c4e`, green plinth `#8fe06a #67c84a #4aa636`. Roofs (front / back): red `#ef5b70 #c1324a`, orange `#f6953f #cf6f22`, teal `#58b7a8 #397f73`, brown `#b2774e #7e5032`, slate `#7a8ea8 #55667c`.
- **Details.** White fascia strips on eaves, 28 % white gloss band below the ridge, white window frames with a two-pane cross, coral or navy doors, white chimneys with a grey cap, cone trees in terracotta pots. Text on a face uses `matrix(0.866,±0.5,0,1,x,y)` so it sits in the plane.
- **Where it is used.** Homepage street (one building per product, each a link with a pill button beneath), the investor/broker door cards, the no-valuation band. Product pages and guides should reuse the same scenes (export from the generator) rather than photos where an illustration is wanted.
- **Icons** in the picker and nav stay 2 px stroked line icons; product metaphors are house, gavel (auction), monitor-with-tick (no valuation), saw (refurbishment), two-storey shop (semi-commercial), office block (commercial), shield-tick (adverse credit).
- **Rendering (v2).** Every face is a gradient (`g-<material>-r/-l/-t`), walls carry an ambient-occlusion strip at the base (`g-ao`), windows are proud white frame boxes with gradient glass, a reflection and a sill, roofs have tile courses, a gloss band, white fascia/bargeboards and a ridge cap, doors get a canopy and a step. Street furniture: cone trees in pots, hedges, lamp posts, a parked car. The `<defs>` block emitted by `tools/iso.pl` must be present once on any page that uses these scenes. The homepage street sits on one continuous verge → pavement → road band drawn in CSS (`.plot::before/::after`), so the seven buildings read as a single street; the per-building green plinth is only used for standalone scenes (door cards, no-valuation band).
- Regenerate: `perl tools/iso.pl out.html && perl tools/splice-street.pl index.html out.html`; scenes: `perl tools/scenes.pl <dir>` then paste the `ill-investor` / `ill-broker` / `ill-noval` SVGs into place.
