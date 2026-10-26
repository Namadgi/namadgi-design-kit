---
name: namadgi-accessibility-and-copy
description: Enforces WCAG 2.2 AA accessibility (keyboard navigation, focus rings, ARIA semantics, contrast, hit areas, zoom) and Australian English UX microcopy standards (verb-first labels, actionable errors, undo patterns, empty states, zero em-dashes). Use whenever building or reviewing interactive components, forms, dialogs, navigation, or user-facing strings.
---

# Namadgi Accessibility & UX Copy Standards

This skill pairs **WCAG 2.2 AA accessibility engineering** with **Namadgi UX Writing & Australian English microcopy**. Every interactive component must be keyboard-complete, screen-reader accurate, and written with clear, human-centred Australian English.

## Reference Library (Load On-Demand Only)
- **Accessibility:** `references/semantics-and-aria.md`, `references/focus-and-keyboard.md`, `references/forms.md`, `references/hit-areas.md`, `references/screen-readers.md`, `references/motion-and-zoom.md`
- **UX Writing:** `references/writing-patterns.md`

---

## Part 1: WCAG 2.2 AA Accessibility Engineering

### 1.1 Native Semantics First (First Rule of ARIA)
- Use `<button type="button">` for actions, `<a href="...">` for navigation (supporting Cmd/Ctrl-click), `<input>`/`<select>`/`<textarea>` for data entry, and `<dialog>` for modals.
- **Never** attach `onClick` to a `<div>`, `<span>`, or `<svg>` without `role="button"`, `tabIndex={0}`, and `onKeyDown` handling both `Enter` and `Space`. Replacing the `<div>` with a `<button>` is always preferred.
- Every icon-only button **must** have an explicit accessible name (`aria-label="Close panel"` or a `.sr-only` label) while the inner `<svg>` has `aria-hidden="true"`.

### 1.2 Focus Management & Keyboard Navigation
- **`:focus-visible` Only:** Never write `outline: none` or `outline: 0` unless accompanied by a high-contrast `:focus-visible` style:
  ```css
  :focus-visible {
    outline: 2px solid var(--color-accent-primary);
    outline-offset: 2px;
  }
  ```
- **Focus Ring Contrast:** The focus indicator must achieve `>= 3:1` contrast against adjacent colours. On dark or Coloured buttons, use a dual-ring (`box-shadow: 0 0 0 2px var(--color-bg-canvas), 0 0 0 4px var(--color-accent-primary)`).
- **Roving `tabindex`:** Composite widgets (tab lists, segmented controls, menus, toolbars, radio groups) take a **single** Tab stop (`tabindex="0"` on the active item, `tabindex="-1"` on all siblings). Arrow keys move focus between items; `Tab` moves to the next widget.
- **Modals & Drawers:** Opening a modal (`<dialog>` or `role="dialog" aria-modal="true"`) must move focus inside the dialog, trap `Tab` / `Shift+Tab` within it, close on `Escape`, and restore focus to the exact trigger element on close.

### 1.3 Forms, Labels & Validation
- Every input requires a persistent visible `<label for="...">` (placeholder text is **not** a label).
- Associate helper text and error messages via `aria-describedby="hint-id error-id"`.
- When validation fails:
  1. Set `aria-invalid="true"` on the offending field.
  2. Render the specific error message inline directly below the field.
  3. On submit failure, move focus to the first invalid field (or an error summary linked to the fields).
- Never disable the submit button solely to hide validation errors if the user cannot tell why it is disabled; allow submission or validate on blur with a clear inline message.

### 1.4 Hit Areas, Contrast, Live Regions & Reflow
- **Hit Targets:** Minimum `24x24px` CSS pixels on desktop (`WCAG 2.2 AA 2.5.8`), and `44x44px` on touch/mobile (`@media (pointer: coarse)`). For small `16px` icon buttons, expand the tap area with an invisible pseudo-element (`::after { content: ""; position: absolute; inset: -10px; }`).
- **Contrast Thresholds:**
  - Normal text (`< 24px` regular or `< 18.66px` bold): `>= 4.5:1`
  - Large text (`>= 24px` regular or `>= 18.66px` bold): `>= 3.0:1`
  - Essential UI boundaries (input borders, checkboxes, icons, focus rings): `>= 3.0:1`
- **Live Regions:** Use `role="status"` (`aria-live="polite"`) for non-blocking updates (saved toasts, filter counts) and `role="alert"` (`aria-live="assertive"`) only for urgent errors requiring immediate attention.
- **Zoom & Reflow:** Layouts must survive `320px` viewport width and `200%` browser zoom without horizontal scrolling or clipped text (never lock line containers to fixed `height: 40px` in `px`; use `min-height` and `rem`).

---

## Part 2: UX Microcopy & Namadgi Australian English Standards

### 2.1 Mandatory Language & Punctuation Rules
1. **Australian English Spelling:** Always write `colour`, `organisation`, `standardised`, `authorised`, `prioritised`, `customise`, `synchronise`, `centre`, `behaviour`, `programme` (for schedule/initiative; `program` for software code), `cancelled`, `labelled`, `licence` (noun) / `license` (verb).
2. **Zero Em-Dashes (`—`):** Never output `—` in UI copy, tooltips, onboarding modals, documentation, or error states. Rewrite with a colon, comma, parentheses, or two crisp sentences.
3. **Zero AI Hyperbole:** Ban *"Seamlessly"*, *"Elevate"*, *"Supercharge"*, *"Unleash"*, *"Next-gen"*, and exclamation marks in routine UI notifications (`Changes saved.` not `Awesome! Your changes were seamlessly saved!`).

### 2.2 Component Copy Rules
- **Buttons & CTAs (Verb + Specific Object):**
  - Write `Create invoice`, `Invite team member`, `Export CSV`, `Save changes`.
  - Never write vague labels like `Submit`, `OK`, `Yes`, `No`, or `Confirm`.
- **Destructive Confirmations:**
  - Title states the exact action: `Delete "Q3 Billing Report"?`
  - Body states the consequence concisely: `This permanently removes the report and its 14 line items. You cannot undo this action.`
  - Buttons pair the specific destructive verb against `Cancel`: `[Cancel]` `[Delete report]`. Never pair `[Yes]` / `[No]` or `[Cancel]` / `[OK]`.
- **Prefer Undo Over Confirmation:**
  - If an action can be soft-deleted or reversed (archiving an item, removing a row, dismissing a notification), execute it immediately without a modal and show a polite toast with an explicit `Undo` button (`>= 5 seconds` timeout, paused on `:hover` and `:focus-within`).
- **Toggles & Checkboxes:**
  - Label the setting by what happens when it is **ON** (`Send weekly summary email`), never as a double negative (`Disable email notifications`).
- **Actionable Error Messages:**
  - Never show raw HTTP/system codes (`Error 500: NullPointerException`, `Invalid input`).
  - State **what went wrong** and **how to fix it**: `Enter a valid ABN with 11 digits (for example, 51 824 753 556).`
- **Empty States:**
  - Never leave a blank box or just `No data`.
  - Provide: (1) clear orientation (`No invoices for October 2026 yet`), (2) one-sentence explanation of value/next step, and (3) a direct primary action (`Create October invoice`) if the user is authorised to create one.
- **Pluralisation & Localisation Safety:**
  - Never concatenate strings like `` `${count} item(s)` `` or `count + " " + (count === 1 ? "file" : "files")` across fragments. Use full-sentence templates or `Intl.PluralRules('en-AU')`.
