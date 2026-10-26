---
name: namadgi-figma-build
description: Implements UI components and screens directly from Figma links with strict source-first fidelity, token mapping, scope restraint, and a structured Match/Deviation report. Use whenever the user provides a Figma URL (`figma.com/design/...` or `figma.com/file/...`) or asks to build a screen from a Figma node.
---

# Namadgi Source-First Figma Implementation

When a Figma link is provided, the Figma file—combined with the repository's existing design system—is the **source of truth**. Do not improvise extra features, invent arbitrary Tailwind values when project tokens exist, or silently alter the layout.

## Reference File
- Read `./figma.md` for the exact Figma URL parser (`fileKey` and `nodeId` conversion from `1234-5678` to `1234:5678`), MCP tool sequence (`get_design_context`, `get_metadata`, `get_variable_defs`, `get_screenshot`), and asset handling rules.

---

## 1. Mandatory 5-Step Figma-to-Code Workflow

### Step 1: Inspect the Repository First
Before querying Figma or writing code, inspect the target repo:
- Locate token definitions (`tailwind.config.*`, CSS variables in `globals.css`/`tokens.css`, theme files).
- Locate existing primitives (`Button`, `Input`, `Badge`, `Card`, `Dialog`, `Table`, icon wrapper).
- Identify how responsive breakpoints, typography classes, and spacing scales are structured.

### Step 2: Fetch Authoritative Figma Context (`./figma.md`)
1. Parse `fileKey` and `nodeId` from the URL.
2. Run `get_design_context` (or `get_metadata` first if the node is a large multi-screen canvas) and `get_variable_defs` to extract bound variables, auto-layout properties, padding, gap, typography styles, and radii.
3. Run `get_screenshot` on the target frame(s) so you have the visual ground truth alongside the node tree.

### Step 3: Map Figma Values to Project Tokens (Never Arbitrary Utilities)
Translate every Figma property into the repo's token layer:
- **Bound Figma Variables:** Map directly to the corresponding CSS variable / Tailwind token (`Color/Surface/Elevated` -> `bg-surface-elevated` or `var(--color-bg-elevated)`).
- **Raw Pixel Values in Figma:** Snap to the nearest existing spacing/radius/font-size token if within **`<= 2px`** tolerance (e.g. `15px` gap in an uncalibrated Figma frame -> `16px` / `gap-4` token, and record it in the `Rounded to token` section of your report).
- **Out-of-Scale Values (`> 2px` delta) or New Colours:** Do not litter the codebase with `w-[343px]`, `p-[19px]`, or `bg-[#6459F5]`. Either map to a semantic token or flag the discrepancy explicitly for the user.

### Step 4: Scope Restraint (Build Only What Is Shown)
- Build **only** the frames, components, and states present in the Figma selection.
- Do **not** invent extra filter bars, search inputs, pagination footers, settings menus, or secondary modals that are not in the design.
- If interactive controls appear in the frame (e.g. a `Filter` button or `Export` menu) without a designed target state or backend handler, render the trigger faithfully and list it under **Unwired Controls** in your delivery report.

### Step 5: Visual Verification & Structured Match Report
Render the implementation at each target frame width shown in Figma (`1440px`, `768px`, `375px`, etc.), compare against the Figma screenshot, and output this exact verification summary:

```markdown
### Figma Implementation Report (`<Frame Name>`)

#### 1. Fidelity Matrix
| Property / Region | Status (`Matches` / `Rounded to token` / `Deviates`) | Details |
| :--- | :--- | :--- |
| Layout & Auto-Layout Gaps | Matches | Flex/Grid structure matches Figma frame hierarchy |
| Typography & Hierarchy | Rounded to token | Figma `15px/22px` mapped to project `text-sm` (`14px/20px`) |
| Colours & Surfaces | Matches | Bound to `--color-bg-surface` and `--color-border-subtle` |

#### 2. Unwired Controls
- `<Control name>`: Rendered visually; awaiting handler/endpoint specification.

#### 3. Missing States in Figma
- Loading, empty, error, or mobile breakpoint states not present in the source frame (built with sensible project defaults / awaiting design).

#### 4. Domain / Accessibility Conflicts
- Any Figma contrast failure (`< 4.5:1`) or touch target (`< 24px`) corrected or flagged.
```
