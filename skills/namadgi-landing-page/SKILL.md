---
name: namadgi-landing-page
description: Designs and builds high-converting product landing pages combining conversion strategy, a 12-section narrative arc, 4 layout archetypes, strict visual discipline, and realistic domain proof. Use whenever creating or redesigning SaaS marketing pages, product launch pages, waitlists, or feature overview pages.
---

# Namadgi High-Converting Landing Page Craft

A landing page is a conversion engine, not a brochure of generic AI cards. This skill enforces **conversion strategy first**, followed by a structured **12-section narrative arc** and strict visual engineering discipline.

---

## 1. Conversion Strategy (Define Before Writing Markup)

Lock down the **Core Conversion Triad** before choosing colours or layouts:
1. **One Offer:** What exact product, workflow, or outcome is being offered?
2. **One Audience:** Who is the specific buyer or technical user, and what expensive pain are they currently living with?
3. **One Primary Action:** What single CTA button text appears in the hero, sticky nav, and final section? (Never mix `Book a demo`, `Start free trial`, `Join waitlist`, and `Read docs` at equal visual weight.)

---

## 2. The 4 Layout Archetypes (Pick One Primary Archetype)

Select the archetype that matches the product's proof mechanism:
1. **Product-Led Interactive Showcase (SaaS / DevTools):** Hero leads immediately into an interactive or high-resolution product frame (`max-width: 1120px`), supported by bento feature cells that show real UI states rather than abstract icons.
2. **Editorial Narrative (Enterprise / High-Trust B2B):** High-contrast typographic thesis, quantified industry problem framing, case-study proof blocks, and structured comparison tables.
3. **Split-Hero Conversion Funnel (Focused Tool / Waitlist / Mobile App):** Left column holds eyebrow + headline + subheadline + single CTA + risk-reversal microcopy + social proof; right column holds a tactile device/interface preview.
4. **Technical Architecture Deep-Dive (Infrastructure / API / Security):** Live code/terminal tabs, latency/compliance benchmarks, architecture flow diagrams, and transparent pricing tiers.

---

## 3. The 12-Section Narrative Sequence

Do not dump random 3-column feature grids onto the page. Build the narrative in this order (omitting only sections that do not apply to the offer):

### Above the Fold (Hero — Max 5 Elements)
1. **Navigation Header:** Brand mark, `3-5` anchor links max, and 1 compact CTA button.
2. **Hero Block (`max-width: 680px` for text container):**
   - Eyebrow badge (specific announcement or category anchor, never `"✨ Introducing Next-Gen AI"`).
   - **Headline (`h1`):** Concrete outcome or sharp positioning statement (`text-wrap: balance`, `line-height: 1.08`, `-0.025em` tracking).
   - **Subheadline:** 1-2 sentences explaining *how* it works and *who* it is for (`max-width: 58ch`, `line-height: 1.55`).
   - **Primary CTA + Risk Reversal:** High-contrast button (`Start 14-day trial`) + concrete micro-proof (`No credit card required · SOC 2 Type II certified`).
   - **Hero Visual / Interactive Artifact:** Real product UI frame, interactive demo widget, or high-craft visual with concentric border padding (`R_outer = R_inner + gap`).

### Mid-Page Proof & Mechanism
3. **Credibility Bar / Quantified Proof:** Real customer metrics or verified partner logos (never invent fake company names like `"AcmeCorp"` or `"Globex"`).
4. **Problem -> Solution Contrast:** Show the old manual/broken workflow alongside the new structured workflow (`Before` vs `After` comparison).
5. **Core Outcome Benefits (3-5 Bento or Editorial Blocks):** Group by user outcome, not internal database features. Vary card spans (`col-span-7` + `col-span-5`) so every row does not look like an identical 3-card stamp.
6. **How It Works (3-Step Mechanism):** Numbered `01 / 02 / 03` progression showing input -> transformation -> result.
7. **Optional Signature Editorial Pause:** A scroll-revealed typographic statement or interactive architecture callout that resets visual rhythm between dense sections.
8. **Deep Proof / Case Study / Live Benchmark:** Specific numbers with realistic precision (`99.94% uptime across 14.2M monthly events`, `4.2 hours saved per fortnightly pay run` — avoid fake round numbers like `100% faster!`).

### Bottom-of-Page Conversion Closure
9. **Pricing / Packaging Table:** Clear tier differentiation with **one** highlighted recommended tier and transparent unit economics.
10. **FAQ Accordion (6-12 Real Buyer Objections):** Address security, migration effort, billing, cancellation, and compliance directly.
11. **Final Conversion Section:** Restate the core value proposition and repeat the single Primary CTA.
12. **Structured Footer:** Product links, legal/compliance links, status indicator, and Australian entity attribution.

---

## 4. Strict Visual & Copy Discipline (Namadgi Calibrated Rules)

- **Typography & Punctuation:**
  - Use Australian English (`organisation`, `standardised`, `colour`, `authorised`).
  - **Ban em-dashes (`—`).** Standard hyphens in compound adjectives (`real-time`, `role-based`, `end-to-end`) and sparing italics for genuine editorial emphasis are permitted.
- **Spacing & Radius Scale:**
  - Section vertical padding: `py-20` to `py-32` (`80px-128px`) on desktop, `py-14` (`56px`) on mobile.
  - Card grid gaps: `16px` (`gap-4`) or `24px` (`gap-6`).
  - Nested frames: Outer shell `rounded-2xl` (`16px`) with `p-2` (`8px`) padding -> inner screen `rounded-xl` (`8px`).
- **Icons & Scroll Reveals:**
  - Use a single consistent icon family (`Phosphor`, `Solar`, or `Iconamoon`). Never use emojis as feature icons.
  - Scroll entrances must use lightweight `IntersectionObserver` + CSS transitions (`opacity` + `translateY(12px)`, `400ms cubic-bezier(0.23, 1, 0.32, 1)`), triggering once (`observer.unobserve(el)`) and respecting `prefers-reduced-motion`.
