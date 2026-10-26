---
name: namadgi-mobile-native
description: Eliminates mobile web/PWA touch defects (sticky hover states, iOS input auto-zoom, 100vh browser bar jumps, rubber-band bleed, safe-area clipping) and enforces native iOS HIG vs Android Material 3 platform conventions. Use whenever building responsive mobile web views, PWAs, React Native / Expo screens, or Flutter mobile apps.
---

# Namadgi Mobile Web & Native Platform Craft

Mobile users immediately sense when a web app is a desktop page squeezed into a `375px` frame, or when an iOS/Android app ignores platform ergonomics. Apply Part 1 to all mobile web/PWA surfaces and Part 2 to native/cross-platform mobile screens.

---

## Part 1: Mobile Web & PWA Engineering Checklist

### 1.1 Gate Every Hover Style Behind Pointer Capabilities
On touchscreens, tapping an element triggers `:hover` and leaves it stuck until the user taps elsewhere. Wrap **every** visual `:hover` state in a media query:
```css
@media (hover: hover) and (pointer: fine) {
  .card:hover {
    border-color: var(--color-border-strong);
    background-color: var(--color-bg-elevated);
  }
}
```
And always provide an explicit `:active` state for immediate touch feedback.

### 1.2 Kill Default WebKit Tap Flash & Callouts on Chrome Controls
```css
button, a, [role="button"], .interactive-control {
  -webkit-tap-highlight-color: transparent;
  touch-action: manipulation; /* Eliminates 300ms double-tap delay */
  user-select: none;
  -webkit-user-select: none;
}
```
*(Never apply `user-select: none` to prose, article text, table cells, or values users need to copy.)*

### 1.3 Prevent iOS Safari Auto-Zoom Without Breaking Accessibility
iOS Safari forcefully zooms the page whenever a user focuses an `<input>`, `<select>`, or `<textarea>` with a computed `font-size < 16px`.
- **Correct Fix:** Ensure all form controls have `font-size: 1rem` (`16px`) minimum on mobile viewports (`@media (max-width: 768px)`).
- **Banned Fix:** Never add `maximum-scale=1` or `user-scalable=no` to `<meta name="viewport">`.

### 1.4 Dynamic Viewport Units (`dvh` vs `svh`) & Safe Areas
Classic `100vh` is broken on mobile browsers because it ignores the collapsible address bar:
- **App Shells, Fixed Layouts & Modals:** Use `height: 100dvh` (`min-height: 100dvh`) so the layout adapts smoothly as browser toolbars expand/collapse.
- **Marketing Hero Sections:** Use `min-height: 100svh` (small viewport height) so the hero never jumps or reflows when the user starts scrolling and the URL bar hides.
- **Safe Area Insets & Virtual Keyboard:**
  1. Set `<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover, interactive-widget=resizes-content">`.
  2. Pad fixed bottom bars, sheets, and floating action buttons with `padding-bottom: max(1rem, env(safe-area-inset-bottom))`.

### 1.5 Scroll Containment & Horizontal Carousels
- **Prevent Background Scroll Bleed:** Add `overscroll-behavior: contain` on scrollable modals, drawers, and bottom sheets so swiping past the end of the sheet does not scroll the page behind it.
- **Horizontal Swipe Containers:** Add `touch-action: pan-y pinch-zoom` and `-webkit-overflow-scrolling: touch` on horizontal carousels (`overflow-x: auto; scroll-snap-type: x mandatory; scrollbar-width: none;`) so vertical page scrolling never gets trapped inside the carousel.
- **Dual Theme-Color Meta Tags:**
  ```html
  <meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)">
  <meta name="theme-color" content="#0f1115" media="(prefers-color-scheme: dark)">
  ```

---

## Part 2: Native iOS (HIG) vs Android (Material 3) Conventions

When designing or building React Native, Expo, or Flutter apps, respect platform muscle memory rather than forcing a lowest-common-denominator web layout:

| Surface / Pattern | iOS (Human Interface Guidelines) | Android (Material Design 3) |
| :--- | :--- | :--- |
| **Primary Navigation** | Bottom Tab Bar (`3-5` tabs, translucent blur material) + large-title collapsible navigation bar. Never use a hamburger drawer for primary nav. | Bottom Navigation Bar (`3-5` destinations) with pill active indicator, or Navigation Rail on tablets/foldables. |
| **Back Gesture** | Interactive left-edge swipe (`UINavigationController` pop) + top-left chevron with previous screen title. | Predictive Back gesture from **either** left or right screen edge + top-left back arrow. |
| **Confirmation / Choice Prompts** | Bottom **Action Sheet** for destructive confirmations or 3+ contextual actions; native centered alert for critical 2-button prompts. | Centered **M3 AlertDialog** or modal bottom sheet; primary action on the far right. |
| **Primary Screen Creation CTA** | Top-right navigation bar button (`+` or `New`) or prominent bottom pill button. | **Floating Action Button (FAB)** anchored bottom-right (`16dp` margin above nav bar). |
| **Date / Option Pickers** | Inline compact pill expanding to wheel or calendar popover (`UIDatePicker`). | M3 Modal Date Picker or Segmented Button / Filter Chip group. |
| **Typography & Scaling** | `SF Pro` / `SF Pro Rounded`; must support **Dynamic Type** scaling without clipping fixed-height rows. | `Roboto` / `Google Sans`; scales with system font `sp` units and variable weight axes. |
| **Haptics** | Pair destructive actions, toggle flips, and picker ticks with `UIImpactFeedbackGenerator` / `UISelectionFeedbackGenerator`. | Pair long-press, slider steps, and gesture thresholds with `HapticFeedbackConstants`. |
