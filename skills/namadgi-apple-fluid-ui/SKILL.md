---
name: namadgi-apple-fluid-ui
description: Applies Apple WWDC "Designing Fluid Interfaces" principles to web and mobile UI — instant pointerdown feedback, interruptible spring physics, velocity handoff, momentum projection, rubber-banding, spatial consistency, and translucent materials. Use when building gestures, draggable sheets, popovers, carousels, fluid navigation transitions, or tactile interactive controls.
---

# Namadgi Apple Fluid UI (Tactile & Interruptible Interfaces)

This skill translates Apple's Human Interface Guidelines and WWDC *Designing Fluid Interfaces* engineering principles into concrete web (`PointerEvent`, CSS, Web Animations API, Framer Motion) and mobile primitives.

---

## 1. Responsiveness & Instant Feedback

An interface feels alive when it responds on the **first frame of touch/pointer contact**, not after `click` (`pointerup`).

- **Immediate `pointerdown` / `:active` Response:**
  Every interactive control must acknowledge contact within `16ms`:
  ```css
  .fluid-button {
    transition: transform 160ms cubic-bezier(0.23, 1, 0.32, 1), background-color 120ms ease;
    will-change: transform;
  }
  .fluid-button:active {
    transform: scale(0.97);
  }
  ```
- **1:1 Pointer Tracking & Grab-Offset Preservation:**
  When dragging a sheet, slider, or card, capture the pointer (`element.setPointerCapture(e.pointerId)`) and record the initial offset (`grabOffset = e.clientY - elementRect.top`). Never snap the element's centre to the cursor on the first move frame.

---

## 2. Interruptibility & Redirection

Animations must never lock the user out of changing their mind mid-flight.

- **Never Block Input During Transitions:** Never place a pointer-blocking overlay over navigation transitions or disable buttons while a view is animating open.
- **Animate From Live Presentation State:** If a sheet is closing and the user grabs it at `42%` progress, read its current live transform (`getComputedStyle(el).transform` or motion value) and continue seamlessly from that exact position and velocity—never jump back to `0%` or `100%`.
- **Additive / Spring Retargeting:** When a target state changes mid-animation (e.g. rapid tab switching or repeated clicks), retarget the existing spring while preserving current velocity rather than cancelling and restarting a fixed-duration tween.

---

## 3. Spring Physics, Momentum & Rubber-Banding

### 3.1 Critically Damped Springs by Default
Real-world objects do not move on linear or standard `ease-in-out` curves; they obey harmonic oscillation:
- **Default UI Spring (Zero Bounce):** Use a critically damped spring (`dampingRatio: 1.0`, `response: 0.3s - 0.38s`, or `stiffness: 380, damping: 38, mass: 1`) for modals, drawers, accordions, and layout shifts. It accelerates immediately and settles smoothly without distracting oscillation.
- **Underdamped Spring (Subtle Bounce):** Use `dampingRatio: 0.78 - 0.85` **only** when a user gesture directly imparts physical momentum (e.g. flicking a floating PiP window into a corner or releasing a pulled-down refresh indicator).

### 3.2 Velocity Handoff
When transitioning from a direct drag gesture (`pointermove`) to a release animation (`pointerup`), compute velocity in `px/s` from the last `2-4` pointer samples and pass it directly into the spring solver:
```ts
const relativeVelocity = gestureVelocityPxPerSec / (targetPosition - currentPosition);
```
A fast short flick should complete the dismissal even if the element only crossed `20%` of the distance threshold.

### 3.3 Momentum Projection (Deceleration Endpoint)
To decide which snap point (e.g. sheet detents `collapsed`, `half`, `expanded`, or corner anchors) a flicked element should settle on, project where it *would* stop under natural deceleration (`d = 0.998` per ms):
```ts
export function projectEndpoint(currentPos: number, velocityPxPerSec: number, decelerationRate = 0.998): number {
  const velocityPerMs = velocityPxPerSec / 1000;
  return currentPos + (velocityPerMs * decelerationRate) / (1 - decelerationRate);
}
```
Pick the snap detent closest to `projectEndpoint(current, velocity)`, not closest to `current`.

### 3.4 Rubber-Banding Beyond Bounds
Never hit a dead-stop wall when dragging past scroll/sheet limits. Apply Apple's asymptotic rubber-band resistance (`c = 0.55`):
```ts
export function rubberBand(overshoot: number, dimension: number, constant = 0.55): number {
  const sign = overshoot < 0 ? -1 : 1;
  const abs = Math.abs(overshoot);
  return sign * ((abs * dimension * constant) / (dimension + constant * abs));
}
```

---

## 4. Spatial Consistency & Continuity

Every element on screen exists in a coherent physical space:
- **Symmetric Enter & Exit Paths:** If a sheet slides up from the bottom edge, it must dismiss back down to the bottom edge. If a popover expands out of a trigger button (`transform-origin: top right`), it must collapse back into that same trigger button—never fade out upward while having entered from below.
- **Shared-Element / Morphing Continuity:** When expanding a compact card or thumbnail into a detail view, morph the shared container bounds and border-radius smoothly (`View Transitions API` or FLIP layout projection) rather than flashing an unanchored modal.

---

## 5. Translucent Materials & Optical Depth

When using glass/vibrancy surfaces (navigation headers, floating toolbars, command palettes):
```css
.material-glass {
  background: oklch(0.98 0.005 260 / 0.72);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border: 1px solid oklch(0 0 0 / 0.08);
}
[data-theme="dark"] .material-glass {
  background: oklch(0.18 0.01 260 / 0.72);
  border-color: oklch(1 0 0 / 0.12);
}
```
- **Never Stack Glass on Glass:** Do not place a blurred translucent popover directly inside or over another blurred translucent card without an opaque surface separation.
- **System Preference Fallbacks (Mandatory):**
  ```css
  @media (prefers-reduced-transparency: reduce) {
    .material-glass {
      background: var(--color-bg-elevated);
      backdrop-filter: none;
    }
  }
  @media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
      transition-duration: 0.01ms !important;
      animation-duration: 0.01ms !important;
    }
  }
  ```
