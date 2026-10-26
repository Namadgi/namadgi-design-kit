---
name: namadgi-ui-craft
description: Enforces pixel-level visual engineering across UI polish, typography, OKLCH colour tokens, and spatial layout. Use whenever writing or refactoring CSS, Tailwind, styled components, design tokens, cards, buttons, tables, forms, or page layouts.
---

# Namadgi UI Craft (Surfaces, Typography, Colour & Layout)

This skill consolidates four core visual engineering disciplines into a single operational standard: **UI Surface Polish**, **Typographic Hierarchy**, **OKLCH Colour Architecture**, and **Spatial Layout & Grouping**.

## Reference Library (Load On-Demand Only)
- **UI Polish:** `references/better-ui.md`, `references/surfaces.md`, `references/icons.md`, `references/icon-transitions.md`, `references/animations.md`, `references/enter-exit.md`, `references/performance.md`
- **Typography:** `references/better-typography.md`, `references/choosing-fonts.md`, `references/spacing-and-sizing.md`, `references/wrapping-and-punctuation.md`, `references/variable-fonts-and-opentype.md`, `references/details-and-accessibility.md`, `references/css-cheat-sheet.md`
- **Colour:** `references/better-colors.md`, `references/color-formats.md`, `references/palette-generation.md`, `references/palette-structure.md`, `references/color-usage.md`, `references/contrast.md`, `references/token-naming.md`
- **Layout:** `references/better-layout.md`, `references/grouping-and-alignment.md`, `references/spacing-and-adaptivity.md`

---

## Domain 1: UI Surface Polish & Optical Geometry

### 1.1 Concentric Border Radius
Nested rounded elements must share the same visual centre of curvature:
- Formula: `R_outer = R_inner + padding` (or `R_inner = max(0px, R_outer - padding)`).
- Apply this strictly whenever the gap between outer and inner edges is `<= 24px` (e.g. a card with `padding: 8px` and `border-radius: 16px` must have an inner image/button radius of `8px`).
- Once padding exceeds `24px`, treat the inner element as an independent surface on your standard radius scale.

### 1.2 Optical vs Geometric Alignment
- **Icon + Text Buttons:** Reduce inline padding by `2px-4px` on the side containing an icon (e.g. `padding: 8px 16px 8px 12px` for a leading-icon button) so the visual weight balances.
- **Play Triangles & Chevrons:** Shift triangular icons `1px-2px` toward their point inside circular containers so their centroid aligns with the circle's centre.
- **Cap-Height Vertical Centering:** Ensure badges and single-line buttons use symmetric vertical padding with `line-height: 1` or flexbox alignment that centres the cap height rather than descender space.

### 1.3 Layered Shadows, Hairlines & Image Outlines
- **Multi-Layer Shadows:** Never use a single muddy drop shadow. Combine a crisp contact shadow with a diffuse ambient shadow, tinted toward the surface hue:
  ```css
  --shadow-elevated:
    0 1px 2px -1px oklch(0.15 0.02 260 / 0.08),
    0 4px 12px -2px oklch(0.15 0.02 260 / 0.06);
  ```
- **High-Contrast / Dark Mode Borders:** In dark mode, shadows disappear. Pair elevated surfaces with a subtle top highlight or `1px` border (`oklch(1 0 0 / 0.08)`), and always include `border: 1px solid transparent` on shadow-only light-mode cards so boundaries remain visible in `forced-colors: active`.
- **Media & Avatar Outlines:** Add a `1px` inset outline on images and avatars so light edges do not bleed into light backgrounds (and dark edges into dark backgrounds):
  ```css
  .media-frame {
    outline: 1px solid oklch(0 0 0 / 0.08);
    outline-offset: -1px;
  }
  [data-theme="dark"] .media-frame {
    outline-color: oklch(1 0 0 / 0.1);
  }
  ```

### 1.4 Icon Discipline
- Never mix icon families (e.g. stroke-based `Lucide` next to solid `FontAwesome`) within the same view.
- Match icon stroke width (`1.5px` or `1.75px`) to the font weight of adjacent labels.
- Size icons to the optical cap-height/line-box of their paired text (`16px` or `18px` for `14px` UI text; `20px` for `16px` text).

---

## Domain 2: Typographic Hierarchy & OpenType Craft

### 2.1 Scale, Line-Height & Tracking Rules
| Role | Size Range | Unitless `line-height` | Letter-Spacing (`tracking`) | Wrapping |
| :--- | :--- | :--- | :--- | :--- |
| **Display / Hero** | `clamp(2.25rem, 4vw + 1rem, 4rem)` | `1.05 - 1.15` | `-0.02em` to `-0.03em` | `text-wrap: balance` |
| **Section Heading (`h2`/`h3`)** | `1.25rem - 2rem` (`20px - 32px`) | `1.2 - 1.3` | `-0.01em` to `-0.02em` | `text-wrap: balance` |
| **Body Copy** | `0.9375rem - 1.0625rem` (`15px - 17px`) | `1.5 - 1.65` | `0` (normal) | `text-wrap: pretty` |
| **Compact UI / Multi-line (3+ lines)** | `0.8125rem - 0.875rem` (`13px - 14px`) | `>= 1.4` | `0` | `text-wrap: pretty` |
| **Overline / Eyebrow (Uppercase)** | `0.6875rem - 0.75rem` (`11px - 12px`) | `1.2` | `+0.06em` to `+0.08em` | `white-space: nowrap` |

### 2.2 Measure & Numeric Precision
- **Reading Measure:** Cap prose and documentation columns at `60ch - 75ch` (`max-width: 65ch`). Never let paragraphs span the full width of a `1280px` container.
- **Tabular Numerals:** Apply `font-variant-numeric: tabular-nums` to all tables, financial figures, badges, pagination counts, and timers.
- **Font Smoothing:** Apply `-webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale;` at the root so light-on-dark typography does not bloom.

---

## Domain 3: OKLCH Colour & Token Architecture

### 3.1 Primitive vs Semantic Token Separation
Never reference raw hex values or primitive scale steps directly in component styles. Use a two-tier system:
1. **Primitives:** `--neutral-50` through `--neutral-950`, `--brand-500`, `--danger-600` (defined in `oklch(L C H)` with constant hue and smooth lightness/chroma progression; tint neutrals with a subtle `0.005 - 0.015` chroma of the brand hue rather than dead `#808080` grey).
2. **Semantics:**
   - Surfaces: `--color-bg-canvas`, `--color-bg-surface`, `--color-bg-elevated`, `--color-bg-subtle`
   - Text: `--color-text-primary`, `--color-text-secondary`, `--color-text-muted`, `--color-text-on-accent`
   - Borders: `--color-border-subtle`, `--color-border-default`, `--color-border-strong`
   - Interactive & Status: `--color-accent-primary`, `--color-accent-hover`, `--color-status-success`, `--color-status-warning`, `--color-status-danger`

### 3.2 Action Hierarchy & Restraint
- **60-30-10 Ratio:** 60% canvas/surface neutrals, 30% structural chrome/secondary text, <= 10% brand/accent colour.
- **Single Primary CTA:** Only **one** filled high-contrast primary button per viewport/dialog. Every other action must step down to secondary (subtle surface + border) or tertiary (ghost/text).
- **Dark Mode Adaptation:** Dark mode is not a simple colour inversion. Step surfaces *up* in lightness (`L: 0.14` canvas -> `L: 0.18` card -> `L: 0.22` modal) to communicate elevation, and reduce accent chroma slightly (`10%-15%`) so colours do not vibrate against dark backgrounds.

---

## Domain 4: Spatial Layout, Grouping & Adaptivity

### 4.1 Law of Proximity (Space First, Lines Last)
- Related items share tight internal spacing (`gap: 4px - 8px`); distinct groups are separated by `>= 2x` that distance (`gap: 16px - 32px`).
- **The 25% Divider Rule:** Audit every card, sidebar, and table. If more than 25% of visual groups are separated by `1px` borders or `<hr>` elements, remove the borders and rely on spacing or subtle background surface shifts.

### 4.2 Grid Alignment & Overflow Prevention
- **Shared Alignment Axes:** Align headings, form labels, table columns, and card edges along shared vertical axes. Avoid arbitrary `margin-left` nudges that create jagged scan lines.
- **Flex & Grid Shrink Safety:**
  - Every flex item containing dynamic text must have `min-width: 0`.
  - Every flexible CSS Grid column must use `minmax(0, 1fr)` rather than bare `1fr` when children may contain long strings, code blocks, or URLs.
- **Logical Properties:** Use `margin-inline`, `padding-block`, `inset-inline-end`, and `text-align: start` so layouts adapt cleanly to RTL locales.
