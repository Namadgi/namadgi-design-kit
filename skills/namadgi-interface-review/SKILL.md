---
name: namadgi-interface-review
description: Performs structured UI/UX and accessibility reviews on either a full screen/flow (better-interface mode) or a git diff/PR (interface-review mode), auditing across 6 domains (Accessibility, Layout, Writing, Typography, Colours, UI Polish) with a single consolidated Block/Approve table. Use before opening a PR, during code review, or when auditing an existing product surface.
---

# Namadgi Interface Review (Full-Surface & PR Diff Auditor)

Use this skill to audit user interfaces for visual craft, accessibility regressions, copy quality, and anti-vibe-slop compliance. It supports two modes:
1. **Diff / PR Mode (`interface-review`):** Audits uncommitted changes or a branch diff (`$BASE..HEAD`) and its 1-2 hop blast radius.
2. **Full-Surface Mode (`better-interface`):** Audits an entire screen, component directory, or user flow end-to-end.

## Reference Library (Load On-Demand Only)
- `references/scope-resolution.md` — Safe read-only `git diff` resolution and 1-2 hop consumer blast-radius expansion
- `references/removed-signals.md` — Checklist of deleted lines (`-`) that silently introduce regressions
- `references/review-format.md` — Exact consolidated table format and severity definitions

---

## 1. Scope Resolution & Read-Only Safety (`references/scope-resolution.md`)

1. **Never Mutate the Working Tree:** Never run `git checkout`, `git switch`, `git stash`, or `git reset` to inspect another branch. Use read-only commands (`git diff`, `git show`, `git log`).
2. **Expand the Blast Radius (1-2 Hops):** If a diff modifies a shared token, primitive (`Button`, `Dialog`, `Input`), or layout wrapper, grep for direct consumers (1-2 hops) to verify the change does not break sibling views.
3. **Inspect Removed Lines (`-`) First (`references/removed-signals.md`):**
   Specifically scan removed lines in the diff for silent deletions of:
   - `aria-label`, `aria-labelledby`, `aria-describedby`, `aria-live`, `role`, `sr-only`
   - `:focus-visible`, `outline`, `tabIndex`, `onKeyDown` (`Escape` / `Enter` / `Space` handlers)
   - `@media (prefers-reduced-motion)`, `@media (forced-colors)`, `@media (hover: hover)`
   - `min-width: 0`, `minmax(0, 1fr)`, `text-overflow: ellipsis`, `tabular-nums`

---

## 2. The 6 Audit Domains (Evaluated in Strict Priority Order)

Evaluate every file in scope across these 6 domains in order:
1. **Accessibility (`A11y`):** Keyboard reachability, `:focus-visible` contrast (`>= 3:1`), semantic elements, form labels & `aria-invalid`, hit targets (`>= 24px` desktop / `44px` touch), text contrast (`4.5:1`), `prefers-reduced-motion`.
2. **Spatial Layout (`Layout`):** Proximity grouping (`outer gap >= 2x inner gap`), 25% divider limit, shared alignment axes, `min-width: 0` / `minmax(0, 1fr)` overflow safety, `320px` & `200%` zoom reflow, logical CSS properties.
3. **UX Copy & Australian English (`Writing`):** Australian spelling (`colour`, `organisation`, `standardised`, `authorised`), **zero em-dashes (`—`)**, verb+object button labels, actionable error strings, orientation+action empty states, zero AI buzzwords.
4. **Typography (`Type`):** Unitless `line-height`, size-specific tracking, `60-75ch` measure cap, `text-wrap: balance`/`pretty`, `tabular-nums` on dynamic/numeric data, no banned vibe font pairings.
5. **Colour & Tokens (`Colour`):** Semantic tokens over raw hexes, OKLCH consistency, **one primary filled CTA per view**, dark-mode elevation steps, no purple/pink text gradients or left-border accent strips.
6. **UI Craft & Motion (`UI Polish`):** Concentric border radii (`R_outer = R_inner + padding`), optical icon padding, layered shadows + `forced-colors` border fallback, `1px` image outlines, frequency-gated motion (`0ms` on keyboard nav, custom `--ease-out`, never `transition: all`).

---

## 3. The 13 `HIGH`-on-Sight Escalation Triggers

Any occurrence of the following is automatically classified as **`HIGH` severity** (blocks approval):
1. Interactive `<div>`/`<span>` with `onClick` but no keyboard/role semantics (or missing `<button>`/`<a href>`).
2. `outline: none` / `outline: 0` without a visible `:focus-visible` indicator (`>= 3:1` contrast).
3. Icon-only `<button>` or `<a>` missing an accessible name (`aria-label` or `.sr-only`).
4. Form `<input>`/`<select>`/`<textarea>` missing a programmatic `<label>` association.
5. Text contrast `< 4.5:1` (normal) or `< 3:1` (large text / interactive boundaries).
6. Modal/dialog that fails to trap focus, close on `Escape`, or restore focus on close.
7. Viewport meta tag containing `maximum-scale=1` or `user-scalable=no`, or mobile inputs with `font-size < 16px`.
8. Multiple competing primary filled CTAs inside the same viewport/dialog.
9. Flex/Grid layout that overflows horizontally at `320px` width or with a 60-character unbreakable string.
10. Destructive action lacking both an Undo mechanism and a specific `Verb + Object` confirmation.
11. Removal of an existing accessibility attribute, focus style, or `prefers-reduced-motion` media query in a diff (`Regression`).
12. Banned AI vibe-slop pattern (purple/indigo text gradients, banned font pairings, emoji UI icons, `border-left: 4px solid` accent cards, or `href="#"`).
13. US English spelling or em-dashes (`—`) in user-facing copy or documentation.

---

## 4. Fix Hierarchy & Consolidated Output Format (`references/review-format.md`)

Always recommend the **cheapest structural fix** in this order:
`1. Delete unneeded chrome` -> `2. Use native platform element` -> `3. Reuse existing semantic token` -> `4. Correct CSS value` -> `5. Add new code/wrapper`.

Output **one consolidated report** (never separate tables per domain):

```markdown
## Namadgi Interface Review Summary
- **Scope:** `<files or diff range>`
- **Verdict:** `Block` (if any `HIGH` findings exist) | `Approve with notes` (`MEDIUM`/`LOW` only) | `Approve`

| # | Severity (`HIGH`/`MED`/`LOW`) | Origin (`Introduced`/`Regression`/`Pre-existing`) | Domain | File & Line | Finding & User Impact | Recommended Fix |
| :- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | `HIGH` | `Regression` | `A11y` | `src/components/Modal.tsx:42` | Removed `onKeyDown` Escape handler; keyboard users cannot dismiss modal. | Restore `Escape` listener or migrate to native `<dialog>`. |
```
