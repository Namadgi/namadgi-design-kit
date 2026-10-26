---
name: namadgi-design-direction
description: Establishes deliberate aesthetic direction, calibrated design dials, and anchored style recipes before writing UI code. Use when starting a new web app, mobile screen, dashboard, or marketing page, redesigning an existing interface, or translating a vague prompt into a concrete design system.
---

# Namadgi Design Direction & Calibration

Use this skill **before** writing component markup or CSS for any new product surface, redesign, or ambiguous feature request. It prevents uncalibrated "vibe-coded" output by forcing an explicit aesthetic commitment, a 5-dial calibration, and an anchored token specification.

## Reference Library (Load On-Demand Only)
Never load all reference files at once. Load only the specific file required for the active step:
- `references/design-directions.md` — 6 aesthetic schools and the Design Direction Advisor protocol
- `references/design-calibration.md` — The 5 calibration dials, Design Read template, and anti-bloat guardrails
- `references/style-recipes/INDEX.md` — Index of 25 brand-anchored style recipes (`linear`, `stripe`, `vercel`, `apple`, `raycast`, `notion`, `claude`, `wise`, `supabase`, `figma`, `pitch`, `framer`, `Arc`, etc.)
- `references/style-recipes/<anchor>.md` — Load **only the single chosen recipe** during Step 3
- `references/block-library.md` & `references/advanced-patterns.md` — Layout composition patterns
- `references/redesign-protocol.md` — Brownfield audit and upgrade workflow
- `references/failure-patterns.md` — Common AI layout/token failure modes
- `references/critique-guide.md` & `references/browser-acceptance.md` — Post-build 5-dimension evaluation

---

## The 7-Step Pre-Code & Delivery Workflow

### Step 0: Verify Domain & Technical Facts
Before proposing visuals, verify:
1. Existing design tokens, Tailwind configuration, or component library in the repository.
2. Real domain entities, statuses, currencies, and actions (never invent placeholder SaaS metrics if real schema fields exist).
3. Target platform constraints (desktop-dense web app, responsive consumer web, iOS/Android native, or marketing showcase).

### Step 1: Understand the Functional Job
Identify the single primary job of the screen:
- **Primary user question:** What must the user understand within 3 seconds of landing?
- **Primary action:** What is the single highest-priority CTA on this view?
- **Information hierarchy:** Rank content into Tier 1 (focal point), Tier 2 (supporting context/controls), and Tier 3 (metadata/secondary actions).

### Step 2: Gather Context or Run the Design Direction Advisor
- **If the project already has a design system:** Inherit its semantic tokens and proceed to Step 2b.
- **If the user's aesthetic intent is underspecified:** Read `references/design-directions.md` and present **3 genuinely contrasting directions** selected from these 6 schools:
  1. **Information Architecture / Swiss Grid** (high density, crisp `1px` hairlines, tabular precision, exposed structure)
  2. **Editorial / Minimalist** (generous whitespace, high-contrast serif/sans pairing, content-first hierarchy)
  3. **Modern Tool / Builder SaaS** (precision dark/light surfaces, keyboard-first ergonomics, subtle layered borders — e.g. Linear, Raycast, Vercel)
  4. **Motion / Experimental Showcase** (choreographed scroll storytelling, bold typography, tactile physics)
  5. **Brutalist / Raw Industrial** (monospaced accents, sharp `0px-2px` corners, high-contrast ink borders, zero decorative blur)
  6. **Warm Humanist** (tinted stone/sand neutrals, approachable rounded geometry, calm contrast — e.g. Claude, Notion)

### Step 2b: Formulate the Design Read & Set the 5 Calibration Dials
Consult `references/design-calibration.md` and declare the 5 dials explicitly (`1` to `10`):
1. `visual-variance` (`1` = strict uniform grid; `10` = asymmetric editorial/bento rhythm)
2. `motion-intensity` (`1` = instant state changes only; `10` = choreographed scroll/spring physics)
3. `information-density` (`1` = spacious single-focus marketing; `10` = compact data-dense pro workbench)
4. `asset-dependence` (`1` = pure typography & UI chrome; `10` = photography/3D/video-led)
5. `brand-fidelity` (`1` = strict adherence to existing tokens; `10` = greenfield exploration)

### Step 3: Declare the Design System & Load One Style Recipe
1. Open `references/style-recipes/INDEX.md` and select the **single closest anchor** for the chosen direction.
2. Read `references/style-recipes/<anchor>.md` and declare the concrete system before writing code:
   - **Colour tokens (OKLCH / Hex):** Canvas background, elevated surface, interactive surface, primary/secondary/muted text, border subtle/strong, and single primary accent.
   - **Typography:** Display font, UI/body font, monospace font, size scale, unitless `line-height` rules, and tracking adjustments.
   - **Geometry & Elevation:** Outer/inner border-radius scale (`R_outer = R_inner + padding`), spacing rhythm (`4px`/`8px` base), and shadow/border recipe.

> **Checkpoint 1:** When starting a greenfield surface or major redesign, present the 1-page Design System declaration (Direction + 5 Dials + Anchor + Token Table) and confirm with the user before building the full screen.

### Step 4: Build the Structural `v0` Draft
Construct the semantic HTML/component skeleton first:
- Establish landmarks (`<header>`, `<main>`, `<nav>`, `<aside>`, `<footer>`).
- Wire CSS custom properties for all semantic tokens at `:root` / `[data-theme="dark"]`.
- Verify responsive grid tracks (`minmax(0, 1fr)`) and single primary CTA hierarchy before adding micro-interactions.

### Step 5: Execute the Full High-Craft Build
Apply the companion craft skills (`namadgi-ui-craft`, `namadgi-accessibility-and-copy`, `namadgi-motion-engineering`, `namadgi-mobile-native`) to finish surfaces, optical alignment, focus states, and realistic domain copy.

### Step 6 & 7: Pre-Delivery Audit & 5-Dimension Critique
Before presenting the finished work, evaluate it against `references/critique-guide.md` and `references/browser-acceptance.md` across 5 dimensions:
1. **Hierarchy & Scannability** (clear focal point, single primary CTA, unambiguous grouping)
2. **Typographic Discipline** (measure `60-75ch`, unitless line-height, `tabular-nums`, no banned fonts)
3. **Surface & Token Coherence** (concentric radii, semantic tokens, no purple neon gradients or left-border accent strips)
4. **Interaction & Accessibility** (`:focus-visible`, keyboard operability, hit targets, reduced-motion guard)
5. **Domain Authenticity** (Australian English copy, zero em-dashes, realistic data, resilient under long/empty values)

---

## 5-Layer Prompt Architecture (For Generating or Refining UI Prompts)

When structuring design specifications for subagents or component generators, always specify all 5 layers:
1. **Layer 1 — Aesthetic Direction & Anchor:** Named school, style recipe anchor, and mood in 1 sentence.
2. **Layer 2 — Layout & Spatial Architecture:** Grid template, container max-width, viewport budget, and section sequence.
3. **Layer 3 — Typography & Colour Tokens:** Exact font families, size/tracking ratios, and semantic background/text/border/accent values.
4. **Layer 4 — Component & Surface Craft:** Concentric radii, border treatments, icon style, and realistic domain content.
5. **Layer 5 — Motion & Ergonomic Constraints:** Easing curves, frequency rules, keyboard/focus behaviour, and mobile viewport rules.
