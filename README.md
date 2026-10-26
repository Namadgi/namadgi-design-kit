# Namadgi Design Kit (`namadgi-design-kit`)

**Standardised Agentic UI/UX Design Rules, 12 Curated Skills, and Static Quality Gates for Namadgi International Pty Ltd.**

**Repository:** `https://github.com/Namadgi/namadgi-design-kit`

---

## Why This Exists

Uncalibrated AI coding agents default to unmistakable "vibe-coded" visual tropes: purple-to-pink text gradients, `Syne`/`Plus Jakarta Sans` font pairings, `border-left: 4px solid` callout cards, emoji icons (`🚀`, `⚡`, `✨`), broken mobile viewports, inaccessible `<div onClick>` controls, and generic US-English marketing filler.

`namadgi-design-kit` distils **325 evaluated skills across 6 industry-leading design-engineering repositories** into a single, conflict-free **12-skill architecture** plus a drop-in `AGENTS.md` / `CLAUDE.md` / `.cursor/rules` policy and a fast static CLI linter.

---

## Set It Up With Your Agent

**Fastest path:** open your AI agent (Google Antigravity, Claude Code, or Cursor) inside the project repository you work in and paste this prompt:

```text
Read https://github.com/Namadgi/namadgi-design-kit (or Confluence page 4224942123 via twg) and set up the Namadgi UI/UX Design Kit globally and in this project for me.
```

### Instructions for the Agent Doing the Setup

If you are an AI agent reading this repository or the Confluence guide, carry out the following steps for the developer:

1. **Clone `namadgi-design-kit` to a temporary directory:**
   ```bash
   rm -rf /tmp/namadgi-design-kit
   git clone https://github.com/Namadgi/namadgi-design-kit.git /tmp/namadgi-design-kit
   ```
2. **Run the installer for both global agent skills and the developer's active project repository:**
   Execute `/tmp/namadgi-design-kit/install.sh` (outside the sandbox if your environment sandboxes writes to `$HOME`):
   ```bash
   /tmp/namadgi-design-kit/install.sh --global-agy --global-claude --target "<CURRENT_PROJECT_ROOT>"
   ```
   - `--global-agy` installs all 12 `namadgi-*` skills into `~/.gemini/config/skills/` (available across every project in Google Antigravity).
   - `--global-claude` installs all 12 `namadgi-*` skills into `~/.claude/skills/` (available across every project in Claude Code).
   - `--target "<CURRENT_PROJECT_ROOT>"` installs project-scoped skills (`.agents/skills/namadgi-*` and `.claude/skills/namadgi-*`), the Cursor rule (`.cursor/rules/namadgi-design-standards.mdc`), the static pre-PR scanner (`scripts/audit-vibe-slop.sh`), and appends the always-on `<!-- NAMADGI-DESIGN-STANDARDS -->` rule block to `AGENTS.md` and `CLAUDE.md` without overwriting existing project instructions.
3. **Verify the installation and clean up:**
   - Confirm that `~/.gemini/config/skills/namadgi-ui-craft/SKILL.md`, `~/.claude/skills/namadgi-ui-craft/SKILL.md`, and `<CURRENT_PROJECT_ROOT>/scripts/audit-vibe-slop.sh` exist.
   - Remove the temporary clone: `rm -rf /tmp/namadgi-design-kit`.
4. **Finish by telling the developer:**
   - Which global skill directories and project files were created or updated.
   - In **Google Antigravity**, restart the IDE once and check **Settings -> Customizations** to confirm the 12 `namadgi-*` skills are listed and `/namadgi-*` slash commands are active.
   - Before raising any UI pull request, run `./scripts/audit-vibe-slop.sh <src-dir>` and invoke `/namadgi-interface-review` on the branch diff.

---

## Repository Structure

```text
namadgi-design-kit/
├── README.md                                  # Quickstart, agent instructions, decision matrix
├── install.sh                                 # Installer for project repos and global AGY/Claude skills
├── rules/
│   └── namadgi-design-standards.md            # Always-on AGENTS.md / CLAUDE.md / .cursor/rules baseline
├── scripts/
│   └── audit-vibe-slop.sh                     # Pre-PR static scanner for banned AI slop & a11y bugs
└── skills/
    ├── namadgi-design-direction/              # Pre-code direction advisor, 5 dials, 25 brand style recipes
    ├── namadgi-ui-craft/                      # Concentric radii, optical alignment, typography, OKLCH, layout
    ├── namadgi-accessibility-and-copy/        # WCAG 2.2 AA compliance + Australian English UX microcopy
    ├── namadgi-apple-fluid-ui/                # WWDC fluid interfaces, spring physics, momentum, rubber-banding
    ├── namadgi-motion-engineering/            # Frequency matrix, custom easings, origin popovers, 60fps rules
    ├── namadgi-mobile-native/                 # Mobile web/PWA fixes + iOS HIG vs Android M3 platform craft
    ├── namadgi-landing-page/                  # Conversion strategy + 12-section narrative + 4 archetypes
    ├── namadgi-awwwards-showcase/             # High-craft interactive showcases, Lenis/GSAP, safe WebGL
    ├── namadgi-figma-build/                   # Source-first Figma MCP implementation + match/deviation report
    ├── namadgi-design-to-motion/              # Static UI to live looping HTML showcase & 60fps MP4/GIF export
    ├── namadgi-interface-review/              # Full-surface & git-diff auditor across 6 domains (Block/Approve)
    └── namadgi-ui-stress-test/                # Adversarial edge-case fixtures (0/1/1000 rows, i18n) + rubric loop
```

---

## Manual Quickstart Installation

If you prefer to run the installer manually in your terminal:

```bash
git clone https://github.com/Namadgi/namadgi-design-kit.git
cd namadgi-design-kit

# Install globally for Antigravity + Claude Code AND wire your project repository in one step:
./install.sh --global-agy --global-claude --target /path/to/product-repo

# Run the pre-PR anti-vibe-slop static scanner:
/path/to/product-repo/scripts/audit-vibe-slop.sh /path/to/product-repo/src
```

---

## Developer Decision Matrix: Which Skill When?

| Task / Scenario | Primary Skill to Invoke | Supporting Skills |
| :--- | :--- | :--- |
| Starting a new app, dashboard, or redesign without a fixed visual spec | `namadgi-design-direction` | `namadgi-ui-craft` |
| Building or styling daily UI components (cards, tables, forms, modals, tokens) | `namadgi-ui-craft` | `namadgi-accessibility-and-copy` |
| Writing form labels, error messages, empty states, destructive modals, or auditing keyboard/ARIA | `namadgi-accessibility-and-copy` | `namadgi-ui-craft` |
| Adding micro-interactions, hover states, tooltips, drawers, or React Native animations | `namadgi-motion-engineering` | `namadgi-apple-fluid-ui` |
| Building gesture-driven sheets, draggable PiP panels, carousels, or spring-physics transitions | `namadgi-apple-fluid-ui` | `namadgi-motion-engineering` |
| Fixing responsive mobile web bugs or building native iOS (HIG) / Android (M3) screens | `namadgi-mobile-native` | `namadgi-accessibility-and-copy` |
| Creating a high-converting SaaS landing page, waitlist, or feature launch page | `namadgi-landing-page` | `namadgi-design-direction`, `namadgi-ui-craft` |
| Building an expressive scrollytelling showcase with GSAP/Lenis or Three.js/WebGL | `namadgi-awwwards-showcase` | `namadgi-motion-engineering` |
| Implementing a screen or component directly from a Figma URL | `namadgi-figma-build` | `namadgi-ui-craft`, `namadgi-accessibility-and-copy` |
| Turning a static Figma frame into a live looping HTML/MP4/GIF product showcase | `namadgi-design-to-motion` | `namadgi-motion-engineering` |
| Stress-testing a screen with worst-case names, `0`/`1`/`1,000` rows, `320px`, and `200%` zoom | `namadgi-ui-stress-test` | `namadgi-interface-review` |
| Reviewing a PR diff or auditing an existing screen before sign-off | `namadgi-interface-review` | `namadgi-ui-stress-test` |

---

## Upstream Attribution & Curated Sources

Curated and adapted for Namadgi International Pty Ltd from:
1. **Emil Kowalski** (`github.com/emilkowalski/skills`): `/design`, `/animations`, `/apple-design`, `/animate`
2. **Jakub Krehel** (`github.com/jakubkrehel/skills`): `better-ui`, `better-typography`, `better-colors`, `better-layout`, `better-a11y`, `better-writing`, `better-mobile`, `better-interface`, `interface-review`, `figma-build`, `break-ui`
3. **Conard Li / Garden Skills** (`github.com/ConardLi/garden-skills`): `web-design-engineer` and the 25 anchored style recipes
4. **Elaya Design** (`github.com/elayadesign/ai-design-skills`): `landing-page-design`
5. **Meng To** (`github.com/MengTo/Skills`): `design-Prompt-Architect`, `design-Mobile-Design-Thinking`, `workflow-Score-To-Target`
6. **Owl-Listener / Designer Skills** (`github.com/Owl-Listener/designer-skills`): `build-awwwards-quality-sites`
