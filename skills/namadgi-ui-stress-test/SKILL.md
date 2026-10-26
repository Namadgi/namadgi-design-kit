---
name: namadgi-ui-stress-test
description: Stress-tests UI components and screens against realistic adversarial edge-case data (empty, 1 item, 1,000 rows, long hyphenated names, unbreakable URLs/emails, CJK/RTL/diacritics, missing optional fields, 320px width, 200% zoom) and runs an iterative Score-to-Target rubric loop (>= 8.5/10). Use after building a UI screen or when hardening layouts before production.
---

# Namadgi UI Stress-Tester & Score-to-Target Loop

Almost every "vibe-coded" interface looks acceptable when populated with three 12-character English strings (`"John Doe"`, `"$120.00"`, `"Active"`), and shatters the first time a real customer enters a Polish hyphenated surname, an unbreakable webhook URL, `0` records, or `1,284` line items.

## Reference Library (Load On-Demand Only)
- `references/CATALOG.md` — Adversarial edge-case string, number, date, and locale payloads
- `references/scenarios.md` — Multi-field realistic worst-case state scenarios (`Empty`, `Single`, `Worst-Case Text`, `High Volume`, `Missing Optionals`, `Partial Failure`)
- `references/scorecard.md` — 7-category quantitative rubric (`0-10` per category; target `>= 8.5` average, no category `< 7`)
- `references/critic-prompt.md` — Independent adversarial critic prompt for the Score-to-Target iteration loop

---

## Workflow A: The 5-Phase Adversarial UI Stress Test (`break-ui`)

### Phase 1: Map Every Rendered Value & Schema Constraint
Inspect the target component(s) and list every dynamic prop, state value, and API field rendered on screen:
- Identify which fields have hard database/validation caps (e.g. `max 255 chars`) vs unbounded length.
- Identify nullable/optional fields (`avatarUrl: null`, `subtitle: undefined`, `tags: []`).
- Identify numeric counters, currency amounts (`$0.00`, `-$1,482,910.45`), and timestamps.

### Phase 2: Construct Realistic Adversarial Fixtures (`references/CATALOG.md`)
Never test with `aaaaa...` or `Lorem ipsum`. Build domain-authentic stress fixtures from `references/CATALOG.md` and `references/scenarios.md`:
- **Long Personal & Organisation Names:** `"Dr. Małgorzata Brzęczyszczykiewicz-Kowalewska"`, `"Namadgi International Infrastructure & Telemetry Holdings Pty Ltd"`
- **Short Single-Character Inputs:** `"Li"`, `"X"`, `"0"` (verifies badges/avatars do not collapse into narrow slivers)
- **Unbreakable Tokens (Zero Spaces):** `"webhook_signing_secret_live_9f8e7d6c5b4a3f2e1d0c9b8a7f6e5d4c3b2a"`, `"billing-reconciliation-automation@subdomain.organisation-enterprise.com.au"`
- **Diacritics, CJK & Bidirectional Text:** `"Zürich · Łódź · São Paulo · 東京 · القاهرة"`
- **Cardinality Extremes:** `0` items (empty state), `1` item (singular grammar + layout stretch check), and `1,000` items (scroll containment, pagination/virtualisation, `tabular-nums` alignment).
- **Missing Optional Fields:** Strip all optional thumbnails, descriptions, secondary badges, and timestamps simultaneously to verify card grids maintain aligned baselines and actions.

### Phase 3: Wire a Dev-Only Fixture Switcher (Non-Destructive)
When running locally or in a preview branch, wire a compact `NODE_ENV === 'development'` (or URL query `?fixture=worst`) segmented control allowing instant switching between:
`[Demo] · [Worst-Case] · [Empty (0)] · [Single (1)] · [1,000 Rows] · [Missing Optionals]`
*(Remove or gate behind dev flags before final production merge if requested.)*

### Phase 4: Execute the Viewport & Environment Matrix
Inspect each fixture state across:
1. Real container width (`1440px` desktop, `1024px` laptop with sidebar open).
2. **`320px` narrow viewport width** and **`200%` browser zoom**.
3. Both **Light** and **Dark** themes.
4. Keyboard `Tab` traversal when text is truncated (`title` or accessible tooltip disclosure when critical identifiers are ellipsised).

### Phase 5: Fix Defects & Report Findings
Fix CSS/markup defects directly (`min-width: 0`, `minmax(0, 1fr)`, `overflow-wrap: anywhere`, `line-clamp`, singular/plural `Intl.PluralRules`, aligned card footers via `margin-top: auto`), then report:
1. **`Broken` (Fixed):** Overflows, clipped buttons, overlapping text, broken scroll containers.
2. **`Ugly` (Fixed):** Jagged card heights, orphan wrapped badges, raw `NaN`/`undefined` strings, `1 items` grammar bugs.
3. **`Fragile` (Hardened):** Layouts that relied on short strings to stay aligned.
4. **`Decisions for You`:** Product policy questions discovered during testing (e.g. maximum allowed tags per row, pagination vs infinite scroll at 1,000 rows).
5. **`What Held Up`:** Components that passed all stress states cleanly.

---

## Workflow B: Iterative Score-to-Target Loop (`>= 8.5 / 10`)

When polishing a high-visibility screen, run the structured critic loop using `references/scorecard.md` and `references/critic-prompt.md`:
1. Score the rendered interface from `1` to `10` across all 7 scorecard categories:
   - Visual Hierarchy & Focus
   - Typography & Scannability
   - Colour, Contrast & Surface Depth
   - Spatial Layout & Alignment
   - Interaction, Motion & Ergonomics
   - Edge-Case & Responsive Resilience
   - Domain Authenticity & Australian Copy Craft
2. **Pass Criteria:** Overall average **`>= 8.5 / 10`** AND **zero categories `< 7 / 10`** AND **zero Anti-Vibe-Slop violations**.
3. If any category scores `< 7` or the average is `< 8.5`, execute the highest-leverage fixes and re-score (up to 3 iterations) before presenting the final result.
