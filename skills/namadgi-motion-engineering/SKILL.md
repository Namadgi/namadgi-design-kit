---
name: namadgi-motion-engineering
description: Designs, audits, and refactors UI animations and micro-interactions using Emil Kowalski's frequency matrix, custom cubic-bezier easings, origin-aware popovers, clip-path reveals, and 60fps GPU composition rules. Use when adding transitions, polishing hover/popover/drawer states, fixing sluggish or janky animations, or reviewing motion in web and React Native / Expo apps.
---

# Namadgi Motion Engineering (Micro-Interactions & 60fps Polish)

Motion in software exists to explain spatial relationships and state changes—never to slow down an experienced user. This skill encodes Emil Kowalski's animation decision methodology and 60fps web/mobile recipes.

## Reference Library (Load On-Demand Only)
- `references/animation-standards.md` — Core timing, easing, and frequency architecture
- `references/web-animation-recipes.md` — Copy-ready CSS/React recipes (popovers, drawers, tooltips, hold-to-delete, `@starting-style`)
- `references/expo-animation-recipes.md` — React Native Reanimated / Gesture Handler recipes
- `references/animation-audit.md` — Step-by-step audit checklist and `| Before | After | Why |` reporting format

---

## 1. The Frequency Decision Matrix (Should This Animate?)

Before writing a single `transition` or `animate` prop, classify how often a user triggers the interaction:

| Interaction Frequency | Examples | Rule & Duration Budget |
| :--- | :--- | :--- |
| **High (`100+ / day`)** | Command palette (`Cmd+K`), arrow-key list/table navigation, keyboard shortcuts, tab switching via keyboard | **0ms — DO NOT ANIMATE.** Even a `120ms` fade makes power users feel like the app is lagging behind their fingers. |
| **Medium (`10 - 50 / day`)** | Dropdown menus, popovers, tooltips, button hover/press, copy-to-clipboard icon swap | **100ms - 150ms** with `--ease-out`. Snappy, interruptible, zero delay on warm groups. |
| **Occasional (`1 - 10 / day`)** | Drawers, slide-over panels, modals, accordion expansion, toast enter/exit | **180ms - 250ms** with `--ease-out` or `--ease-drawer` (or critically damped spring). |
| **Rare (Onboarding / Milestone)** | First-run setup completion, empty-to-populated celebration, marketing showcase | **300ms - 500ms** choreographed sequence; must still respect `prefers-reduced-motion`. |

---

## 2. Easing Curves & Timing Laws

Browser built-in `ease`, `linear`, and `ease-in` look robotic on UI elements. Define these custom curves in your root CSS tokens:

```css
:root {
  /* Primary UI curve: fast initial response, gentle deceleration */
  --ease-out: cubic-bezier(0.23, 1, 0.32, 1);
  /* On-screen morphing or position transfer between two visible states */
  --ease-in-out: cubic-bezier(0.77, 0, 0.175, 1);
  /* iOS-grade sheet and drawer curve */
  --ease-drawer: cubic-bezier(0.32, 0.72, 0, 1);
}
```

### Hard Easing & Timing Rules
1. **Never use `ease-in` on UI entrances or exits:** `ease-in` starts slowly, making the interface feel broken for the first `80ms` after a click.
2. **Asymmetric Enter / Exit Timing:** Exit transitions should be **20% to 30% faster** than entrance transitions (e.g. `180ms` enter, `130ms` exit) so dismissed UI gets out of the user's way immediately.
3. **Never Animate From `scale(0)`:** Things in the real world do not materialise from a mathematical point. Start popovers, modals, and icons from `scale(0.95)` or `scale(0.92)` paired with `opacity: 0`.

---

## 3. High-Craft Micro-Interaction Patterns

### 3.1 Origin-Aware Popovers & Menus
Never scale a dropdown from its dead centre (`transform-origin: center`). Bind `transform-origin` to the placement anchor (`var(--radix-popover-content-transform-origin)` or `var(--transform-origin)`):
```css
.popover-content {
  transform-origin: var(--transform-origin, top center);
  transition: transform 140ms var(--ease-out), opacity 140ms var(--ease-out);
   starting-style {
    opacity: 0;
    transform: scale(0.96) translateY(-4px);
  }
}
```

### 3.2 Warm Tooltip Groups (`data-instant`)
- The **first** tooltip hovered requires a `300ms-400ms` open delay so casual cursor movement does not trigger visual noise.
- Once one tooltip is open, adjacent tooltips hovered within `300ms` must open at **`0ms` delay** with `0ms` duration (`[data-instant] { transition-duration: 0ms; }`).

### 3.3 Icon & State Crossfades (`blur(2px)` Bridge)
When morphing between two unrelated icons (e.g. `Copy` -> `Check` or `Send` -> `Spinner`), animate `opacity: 0 -> 1`, `scale(0.85 -> 1)`, and `filter: blur(2px) -> blur(0px)` over `150ms var(--ease-out)`. The `2px` motion blur masks the discrete SVG swap so the eye perceives a continuous transformation.

### 3.4 Hardware-Accelerated `clip-path: inset()` Reveals
Use `clip-path: inset(...)` instead of animating `width` or `height` for:
- **Sliding Active Tab Pills:** Render a duplicate high-contrast label layer clipped to the active tab pill bounds (`clip-path: inset(0 66% 0 0 round 8px)`) so text colour inverts cleanly mid-slide without z-index flicker.
- **Hold-to-Delete Buttons:** Fill a destructive overlay across the button via `clip-path: inset(0 100% 0 0)` -> `inset(0 0% 0 0)` over `1200ms linear` on press, snapping back over `160ms var(--ease-out)` if released early.

---

## 4. 60fps GPU Performance & Review Protocol

1. **Compositor-Only Properties:** Animate only `transform`, `opacity`, `filter`, and `clip-path`. Never write `transition: all`.
2. **Framer Motion Under Load:** When animating many items simultaneously during heavy main-thread work, prefer CSS transitions or pass a unified `transform` string so WebAnimations API can offload to the compositor thread.
3. **Mandatory Audit Table:** Whenever auditing or refactoring animations in an existing codebase (see `references/animation-audit.md`), present a summary table:
   `| Component / Interaction | Before | After | Why |`
