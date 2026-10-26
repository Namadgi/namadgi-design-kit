---
name: namadgi-design-to-motion
description: Transforms static Figma frames or product screenshots into live looping HTML/CSS/JS showcase animations, interactive website bento animations, and deterministic 60fps MP4/GIF exports. Use when asked to bring a static design to life, create a product launch video/GIF from UI frames, or animate hero/bento product visuals.
---

# Namadgi Design-to-Motion (Static UI to Live Looping Showcase)

This skill turns a static Figma frame or UI composition into a living, self-playing HTML showcase or website bento animation—preserving pixel-accurate fidelity on the static chrome while driving realistic, semantic product stories inside the interface.

---

## 1. Classify the Target Context & Structural Mode

Before exporting layers or writing animation timelines, classify two axes:

### Axis A: Delivery Context
1. **Standalone Showcase / Social Video (`16:9` or `4:3` frame):** Includes a soft entrance (`0.0s -> 2.4s`), a rich semantic story loop (`2.4s -> 11.0s`), and a clean reset or seamless loop for MP4/GIF capture.
2. **Embedded Website Bento / Hero Visual:** Skips the full-frame fade-in so the page does not feel blank on load; runs a continuous ambient or scroll-triggered semantic story loop inside the card frame.

### Axis B: Structural Geometry
1. **App Frame Mode (Joined Chrome):** Sidebar, top bar, and split panes share `1px` borders inside a single window shell. **Keep the outer shell and joined panes static**—never float or separate joined panes, or internal seams will tear. Animate the content *inside* the panes.
2. **Separate Cards Mode (Floating Stack):** Independent floating cards, popovers, or notifications layered over a backdrop. Cards may rise in sequentially with subtle depth parallax.

---

## 2. Sacred Background & Layer Export Protocol

1. **Sacred Background Rule:** The background canvas/wallpaper from the source design must remain **100% untouched** (`> 45 dB` PSNR match against the original frame). Never recreate a complex photographic or shader background with approximate CSS gradients; export the exact background layer at `3x` PNG/WebP.
2. **Layer Separation & Z-Order:**
   - Keep static structural chrome as crisp HTML/CSS or `3x` PNG layers in their exact Figma z-order.
   - Rebuild the **dynamic story elements** (live cursor, typing prompt bar, streaming response, chart scrubbers, status badges, incoming list rows) in native DOM/SVG so they animate with infinite sharpness.
3. **The `?still` Fidelity Gate:**
   - Support a `?still` URL query parameter that freezes the scene at its canonical settled state (`t = 2.4s`).
   - Compare `?still` against the original static design screenshot. Layout positions, typography, and colours must achieve `> 35 dB` PSNR (visual parity) before adding loop choreography.

---

## 3. Timeline Choreography & Semantic Story Loops

Drive all animations from a **single deterministic clock** (`window.__tick(dt)` or a master timeline hooked to `performance.now()`) so headless browser video capture runs at a locked `60fps` with zero dropped frames.

### Phase 1: Soft Rise-and-Blur Intro (`0.0s -> 2.4s`, Showcase Mode Only)
- Frame or floating cards rise `16px -> 0px`, scale `0.97 -> 1.0`, opacity `0 -> 1`, and unblur `filter: blur(8px) -> blur(0px)` using `cubic-bezier(0.22, 1, 0.36, 1)`.
- Stagger overlapping floating cards by `120ms-180ms`.

### Phase 2: Semantic Product Story (`2.4s -> 11.0s`)
Never just bounce cards up and down. Choreograph a **causal user story**:
- **Prompt / Input:** A cursor moves naturally along a curved bezier path, clicks the input, and types a realistic domain query glyph-by-glyph (`35ms-55ms` per character with slight human variance).
- **Processing & Connectors:** Submit button compresses (`scale(0.95)`), status pill shifts from `Pending` -> `Running` -> `Verified` with a `blur(2px)` crossfade, and SVG connector paths pulse with `stroke-dashoffset`.
- **Live Data Response:**
  - Charts scrub smoothly with a vertical crosshair and live `tabular-nums` tooltip readout.
  - Tables/lists insert a new row using smooth height + `clip-path` expansion while existing rows shift down without layout jump.
- **Rest Beat (`9.5s -> 11.0s`):** Hold the completed state for `1.5s` so the viewer can read the outcome before the loop resets.

---

## 4. Pre-Export Quality Gates & Deterministic Capture

Before exporting deliverables, verify all 4 gates:
1. **No Text Overflow or Reflow:** Dynamic typing or number updates never wrap unexpectedly or push sibling buttons off-frame.
2. **No Seam Tearing:** Joined `1px` borders in App Frame mode never separate or double up during transitions.
3. **No Dead Beats:** Something purposeful is either moving or holding a readable focal beat at every second of the timeline.
4. **Export Artefacts (When Video/GIF Requested):**
   Capture via headless Chromium stepping `window.__tick(1000 / 60)` per frame and encode with `ffmpeg`:
   - `<name>-x.mp4` (`1920x1080` or native `2x`, `60fps`, `libx264`, `-crf 18`, `-pix_fmt yuv420p`)
   - `<name>-loop.gif` (`960px` wide, `30fps`, two-pass `palettegen` / `paletteuse`)
   - `<name>-800x500.gif` (`800x500` thumbnail loop)
