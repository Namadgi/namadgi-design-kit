# Namadgi Agentic UI/UX Design Standards (`AGENTS.md` / `CLAUDE.md` / `.cursor/rules`)

You are building and reviewing user interfaces for **Namadgi International Pty Ltd** across all web, mobile, and desktop applications. Every interface must look and feel intentionally engineered by a senior design engineer, never "vibe-coded" by an uncalibrated language model.

Follow these standards on every frontend, mobile, and UI PR.

---

## 1. The Anti-Vibe-Slop Blocklist (Hard Rejections)

Never generate, recommend, or leave behind any of the following patterns unless explicitly mandated by an existing brand specification:

### 1.1 Banned "Vibe-Coded" Font Pairings
Do not default to the standard AI-generated font combinations:
- `Syne` + `DM Sans`
- `Plus Jakarta Sans` + `Inter`
- `Space Grotesk` + `Inter`
- `Outfit` + `Poppins`
- `Cinzel` + `Jost`
- `Playfair Display` + `Lato`
- Unstyled default `Inter`, `Roboto`, or `Arial` on marketing or hero displays without intentional typographic hierarchy, optical sizing, and tracking adjustments.

### 1.2 Banned Colour & Surface Slop
- **Purple/Neon Text Gradients:** Never apply `background-clip: text` with indigo/violet/purple/pink gradients (`#6366f1`, `#8b5cf6`, `#a855f7`, `#7c3aed`, `#ec4899`).
- **Default AI Dark Mode:** Never use `#0B0F17` / `#030712` paired with glowing neon violet/cyan borders and blurred gradient blobs (`filter: blur(100px)`).
- **Left-Border Accent Cards:** Never style cards with `border-left: 4px solid <accent>` (the classic AI dashboard/callout trope). Use spacing, surface elevation, or a subtle `1px` full border instead.
- **Zero-Blur Box Shadows:** Never use `box-shadow` with `0` blur where a standard `border` belongs, except for high-contrast focus rings or subtle `1px` inset image outlines.
- **Emoji as UI Icons:** Never use emojis (`🚀`, `⚡`, `✨`, `🔒`, `💡`, `📈`) as feature card icons, navigation markers, or status indicators. Use a consistent vector icon library (`Phosphor`, `Solar`, `Iconamoon`, `Lucide`, or `SF Symbols` / `Material Symbols`) with uniform stroke weight.
- **AI-Drawn Faces & Fake Product Silhouettes:** Never draw human faces, hands, or fake product screenshots out of raw CSS shapes or inline SVG paths. Use real product screenshots, verified transparent PNG cutouts, or code-rendered interactive UI components.

### 1.3 Banned Copy, Markup & Interaction Slop
- **AI Marketing Clichés:** Never write *"Elevate"*, *"Seamlessly"*, *"Unleash"*, *"Next-Gen"*, *"Supercharge"*, *"Revolutionize" / "Revolutionise"*, *"Transform your workflow"*, *"Harness the power"*, *"Empower your team"*, or *"All-in-one platform"*.
- **No Em-Dashes:** Never use the em-dash character (`—`) in UI copy, error messages, empty states, comments, or documentation. Use commas, parentheses, colons, or separate sentences.
- **Australian English Mandatory:** Always use Australian English spelling (`colour`, `organisation`, `standardised`, `authorised`, `prioritised`, `centre`, `behaviour`, `programme`, `licence` as noun / `license` as verb) in all user-facing copy and documentation, while preserving standard US spelling in CSS/JS identifiers (`color`, `textAlign`, `summarize`).
- **LLM Meta-Comments:** Never leave comments like `// Redesigned with a modern aesthetic`, `/* Enhanced glassmorphic card */`, or `// Added smooth animation for better UX`.
- **Dead Links & Fake Controls:** Never ship `href="#"`, `href="javascript:void(0)"`, or unwired `<button>` elements without an explicit disabled state or handler.
- **Animation Slop:** Never use `transition: all`. Never animate layout properties (`width`, `height`, `top`, `left`, `margin`, `padding`). Never animate high-frequency keyboard actions (command palettes, arrow-key list navigation, shortcuts).
- **Viewport Locking:** Never set `maximum-scale=1` or `user-scalable=no` in `<meta name="viewport">`.

---

## 2. Mandatory Pre-Code Design Protocol

Before writing UI markup or styling for any new screen, page, or major component:

1. **Declare or Confirm the Aesthetic Direction:**
   - If the screen belongs to an existing application, inspect and inherit its existing tokens (`--color-*`, spacing scale, radius scale, typography).
   - If starting a new surface or marketing page without a brief, invoke the `namadgi-design-direction` skill and present **3 contrasting aesthetic directions** with calibrated dials (`visual-variance`, `motion-intensity`, `information-density`, `asset-dependence`, `brand-fidelity`) before writing component code.
2. **Establish the Token Layer First:**
   - Separate **primitive tokens** (`--slate-900`, `--blue-600`) from **semantic tokens** (`--color-bg-canvas`, `--color-bg-surface`, `--color-text-primary`, `--color-text-secondary`, `--color-border-subtle`, `--color-accent-primary`).
   - Prefer **OKLCH** (`oklch(L C H)`) for colour ramps so lightness and perceived contrast stay predictable across hues and light/dark modes.
   - Maintain a strict **one primary filled CTA per view** rule. Secondary actions use neutral surface/outline treatments; tertiary actions use text/ghost treatments.

---

## 3. Core Visual & Engineering Invariants

### 3.1 Geometry, Surfaces & Layout (`namadgi-ui-craft`)
- **Concentric Border Radius:** When nesting a rounded child inside a rounded container (with padding `<= 24px`), calculate:
  `R_outer = R_inner + padding` (or `R_inner = max(0, R_outer - padding)`).
- **Optical Alignment:**
  - Buttons with a leading or trailing icon require `2px` less inline padding on the icon side than on the text side.
  - Play triangles and asymmetric icons must be shifted optically (`1px-2px` toward the lighter side) to sit at the visual centre.
- **Layered Elevation & Forced-Colors Safety:**
  - Build shadows from at least two layers: a tight key shadow for crispness and a softer ambient shadow for depth.
  - Every elevated card or popover must include `border: 1px solid transparent` (or a subtle semantic border token) so boundaries survive Windows High Contrast / `forced-colors: active`.
  - Apply a `1px` subtle inset outline (`outline: 1px solid oklch(0 0 0 / 0.08)` in light mode, `oklch(1 0 0 / 0.1)` in dark mode, `outline-offset: -1px`) on user-uploaded avatars and media thumbnails.
- **Space-First Grouping:**
  - Prefer whitespace over divider lines (`<hr>` or `border-bottom`). If more than 25% of list/card boundaries use visible lines, replace them with spacing (`outer gap >= 2x inner gap`).
- **Resilient Flex/Grid Layouts:**
  - Add `min-width: 0` on flex children and use `minmax(0, 1fr)` on CSS Grid tracks containing text so long strings truncate or wrap instead of blowing out the container.
  - Use CSS logical properties (`margin-inline-start`, `padding-inline`, `inset-inline-end`) instead of physical left/right properties.

### 3.2 Typography (`namadgi-ui-craft`)
- **Unitless Line-Height:** Always declare unitless `line-height`: `1.05-1.15` for display headings, `1.2-1.3` for section headings, `1.5-1.6` for body copy, and `>= 1.4` for any text block that wraps to 3 or more lines.
- **Size-Specific Tracking:** Tighten letter-spacing on large display text (`-0.015em` to `-0.03em` at `>= 24px`) and loosen it on small uppercase labels (`+0.05em` to `+0.08em` at `<= 13px`). Never apply negative tracking to body copy.
- **Measure & Wrapping:** Constrain reading columns to `60ch-75ch`. Apply `text-wrap: balance` to headings and short callouts (`<= 4` lines) and `text-wrap: pretty` to body paragraphs.
- **Numeric Discipline:** Apply `font-variant-numeric: tabular-nums` to all tables, KPI counters, timers, currencies, and live-updating numbers so digits never jitter horizontally.

### 3.3 Accessibility & Interface Copy (`namadgi-accessibility-and-copy`)
- **Semantic Primitives First:** Use `<button type="button">` for actions, `<a href="...">` for navigation, and `<dialog>` for modals. Never attach `onClick` to a `<div>` or `<span>`.
- **Keyboard & Focus:**
  - Style focus exclusively with `:focus-visible` (`2px` solid ring with `2px` offset and `>= 3:1` contrast against adjacent surfaces). Never write `outline: none` without a `:focus-visible` replacement.
  - Composite widgets (tabs, menus, segmented controls, radio groups) must implement roving `tabindex` (`0` on active item, `-1` on peers) with arrow-key navigation.
- **Contrast & Hit Targets:**
  - Normal text `< 24px`: `>= 4.5:1` contrast. Large text `>= 24px` (or `>= 18.66px` bold) and interactive borders/icons: `>= 3:1` contrast.
  - Minimum hit area: `24x24px` desktop (`WCAG 2.2 AA`), `44x44px` on touch/mobile (`pointer: coarse`). Use pseudo-element hit-area expansion (`::after { inset: -8px }`) for compact icon buttons.
- **Copy Mechanics:**
  - Buttons use **Verb + Object** (`Save changes`, `Create invoice`, `Remove member`), never `OK`, `Submit`, or `Yes/No`.
  - Destructive confirmations repeat the specific verb and target (`Delete project "Production API"` / `Cancel`). Prefer an immediate action + **Undo toast** (`>= 5s` duration, paused on hover/focus) whenever the action can be reversed.
  - Empty states must answer two questions: *what belongs here* and *what action populates it* (with a direct CTA if the user has permission).

### 3.4 Motion & Mobile Polish (`namadgi-motion-engineering`, `namadgi-apple-fluid-ui`, `namadgi-mobile-native`)
- **Frequency Gates Motion:**
  - `100+ times/day` (command palette, keyboard nav, cell focus): **0ms (no animation)**.
  - `10-50 times/day` (menus, popovers, tooltips, hover): **100ms-150ms** (`--ease-out: cubic-bezier(0.23, 1, 0.32, 1)`), scaling from `0.95` (never `0`). Subsequent tooltips open with `0ms` delay while the group is warm.
  - Occasional transitions (drawers, sheets, modals): **180ms-250ms** or critically damped spring (`damping: 1.0, response: 0.32`). Exit animations run 20%-30% faster than entrance animations.
- **Mobile & Touch Safeguards:**
  - Wrap every `:hover` visual change inside `@media (hover: hover) and (pointer: fine)`.
  - Every `<input>`, `<select>`, and `<textarea>` must maintain `font-size >= 16px` (`1rem`) on mobile viewports to prevent iOS Safari auto-zoom.
  - Use `100dvh` for full-screen app shells and `100svh` for marketing heroes. Account for `env(safe-area-inset-bottom)` on fixed bottom bars and sheets.

---

## 4. Mandatory Pre-PR Verification Workflow

Before marking any UI ticket ready for review or opening a PR:
1. **Run the Static Vibe-Slop Scanner:**
   Execute `./namadgi-design-kit/scripts/audit-vibe-slop.sh <changed-files-or-dir>` and resolve all errors.
2. **Stress-Test with Realistic Worst-Case Data (`namadgi-ui-stress-test`):**
   Verify the layout with `0` items, `1` item, `1,000` items, long hyphenated names (`Władysław-Kowalewski`), unbreakable emails/URLs, missing optional fields, `320px` viewport width, and `200%` browser zoom.
3. **Run the Consolidated Interface Review (`namadgi-interface-review`):**
   Audit the diff across Accessibility, Layout, Copy, Typography, Colour, and UI Craft. Zero `HIGH` severity findings may ship.
