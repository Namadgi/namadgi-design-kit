---
name: namadgi-awwwards-showcase
description: Builds Awwwards-grade interactive marketing sites, brand showcases, and launch experiences with original art direction, honest asset provenance, accessible split-text choreography, GSAP + single smooth-scroll engine (Lenis), and lifecycle-safe Three.js/WebGL. Use when the user explicitly wants an expressive, award-calibre showcase, scrollytelling experience, or flagship launch site.
---

# Namadgi Awwwards-Quality Interactive Showcase

Use this skill when building flagship brand experiences, interactive product launches, or scrollytelling showcases where `motion-intensity` and `visual-variance` dials are intentionally set to `7-10`. High-craft showcase design requires **strict engineering discipline** so expressive visuals never degrade into laggy, inaccessible AI slop.

---

## 1. Original Art Direction (Declare Before Coding)

Every showcase page requires a 3-part **Art Direction Charter**:
1. **Visual Thesis:** One sentence defining the physical metaphor or editorial tension (e.g. *"Precision Swiss horology meets live telemetry: warm brushed titanium surfaces, hairline coordinate grids, and tactile mechanical detents"*).
2. **Hero Focal Artifact:** What is the centrepiece above the fold? (e.g. a layered interactive DOM instrument, a cutout photographic composition with depth parallax, or a shader/WebGL canvas with a static poster fallback).
3. **Motion Narrative:** How does scrolling progress the story? Define the exact scroll chapters (Pin 1 -> Horizontal/Layered Reveal -> Editorial Contrast -> Conversion).

---

## 2. Honest Asset Provenance (Zero Fake AI Drawings)

Award-winning sites fail immediately when populated with crude LLM-generated SVG illustrations or fake social proof:
- **Never Draw Faces, Hands, or Complex Objects in Raw SVG/CSS:** If the layout calls for photography, product hardware, or cutout objects, use real project assets, generate/source verified high-resolution images with clean alpha channels (`.png` / `.webp`), or build authentic interactive DOM UI components.
- **No Fake Logo Walls or Invented Testimonials:** Never invent fake company names or stock-photo quotes. If real logos/quotes are not yet provided, use quantified architectural benchmarks, live interactive calculators, or clearly labelled placeholder slots with explicit dimensions.
- **Icon Consistency:** Use `Solar`, `Phosphor`, or bespoke geometric hairlines (`1.25px-1.5px` stroke). Never use emojis.

---

## 3. Static-First Accessible Hero Architecture

A showcase hero must render a complete, legible, conversion-ready composition **before** JavaScript hydration, WebGL compilation, or pointer movement:
- Build the semantic HTML/CSS layout first (`<h1>`, primary CTA, static fallback visual).
- Pointer-tracking spotlights, magnetic buttons, and tilt parallax must be **strictly additive** (`@media (hover: hover) and (pointer: fine)`), gracefully disabled on touch devices and when `prefers-reduced-motion: reduce` is active.

---

## 4. Scroll Choreography & Split-Text Accessibility

### 4.1 Single Smooth-Scroll Engine Rule
- When smooth scrolling is desired, pair **GSAP + ScrollTrigger** with **Lenis** (`lenis.on('scroll', ScrollTrigger.update)`).
- **Never** combine two smooth-scroll libraries (e.g. Lenis + Locomotive Scroll + CSS `scroll-behavior: smooth`). When using Lenis, ensure `html { scroll-behavior: auto; }` so native smooth scroll does not fight the virtual scroll loop.
- Bypass smooth scroll completely when `window.matchMedia('(prefers-reduced-motion: reduce)').matches` is true.

### 4.2 Screen-Reader-Safe Split Text
When splitting headings into words or characters (`<span class="char">`) for staggered GSAP/CSS reveals, screen readers will spell out individual letters unless guarded:
```html
<h1 aria-label="Precision financial telemetry for modern engineering squads">
  <span aria-hidden="true" class="split-line">
    <span class="word">Precision</span>
    <span class="word">financial</span>
    ...
  </span>
</h1>
```
Always place the full sentence in `aria-label` on the heading element (or a `.sr-only` child) and set `aria-hidden="true"` on all split wrapper spans.

---

## 5. Lifecycle-Safe WebGL / Three.js Discipline

If the experience includes a Three.js, React Three Fiber, or custom WebGL shader canvas:
1. **Purposeful Integration:** The 3D/shader element must reinforce the product thesis—never drop a generic spinning wireframe sphere in the background.
2. **Device Pixel Ratio Cap:** Always cap renderer pixel ratio (`renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))`) so 3x/4x mobile screens do not melt GPU fill-rate.
3. **Offscreen Pause (`IntersectionObserver`):** Pause the `requestAnimationFrame` render loop whenever the canvas scrolls out of the viewport or `document.hidden` is true.
4. **Full Memory Disposal:** On component unmount, cancel the animation frame, dispose of all geometries, materials, textures, and render targets, and call `renderer.dispose()`.
5. **Static Poster Fallback:** Always render a CSS/image fallback behind the canvas for low-power devices, WebGL context loss, or `prefers-reduced-motion: reduce`.
