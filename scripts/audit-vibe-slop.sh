#!/usr/bin/env bash
# ==============================================================================
# Namadgi Anti-Vibe-Slop Static Scanner (audit-vibe-slop.sh)
# Scans UI source files (.tsx, .ts, .jsx, .js, .vue, .svelte, .astro, .html, .css, .scss)
# for banned AI "vibe-coded" visual patterns, accessibility anti-patterns,
# AI marketing clichés, and em-dashes.
#
# Usage:
#   ./namadgi-design-kit/scripts/audit-vibe-slop.sh [target-dir-or-file ...]
# ==============================================================================

set -euo pipefail

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

TARGETS=("$@")
if [ ${#TARGETS[@]} -eq 0 ]; then
  TARGETS=(".")
fi

ERRORS=0
WARNINGS=0

echo -e "${BOLD}${CYAN}=== Namadgi UI/UX Anti-Vibe-Slop Audit ===${RESET}"
echo -e "Scanning targets: ${TARGETS[*]}\n"

# Build file list (excluding node_modules, .git, dist, build, .next, coverage, namadgi-design-kit)
FILES=()
while IFS= read -r file; do
  [ -n "$file" ] && FILES+=("$file")
done < <(find "${TARGETS[@]}" \
  \( -name "node_modules" -o -name ".git" -o -name "dist" -o -name "build" -o -name ".next" -o -name "coverage" -o -name "namadgi-design-kit" \) -prune \
  -o -type f \( -name "*.tsx" -o -name "*.ts" -o -name "*.jsx" -o -name "*.js" -o -name "*.vue" -o -name "*.svelte" -o -name "*.astro" -o -name "*.html" -o -name "*.css" -o -name "*.scss" \) -print 2>/dev/null)

if [ ${#FILES[@]} -eq 0 ]; then
  echo -e "${GREEN}No matching UI source files found in target path(s). Audit clean (0 errors).${RESET}"
  exit 0
fi

echo -e "Found ${BOLD}${#FILES[@]}${RESET} UI source file(s) to inspect.\n"

check_pattern() {
  local severity="$1"
  local rule_id="$2"
  local description="$3"
  local regex="$4"

  local matches
  matches=$(grep -Eni "$regex" "${FILES[@]}" 2>/dev/null || true)
  if [ -n "$matches" ]; then
    if [ "$severity" = "ERROR" ]; then
      echo -e "${RED}${BOLD}[ERROR] ${rule_id}:${RESET} ${description}"
      ERRORS=$((ERRORS + 1))
    else
      echo -e "${YELLOW}${BOLD}[WARN]  ${rule_id}:${RESET} ${description}"
      WARNINGS=$((WARNINGS + 1))
    fi
    echo "$matches" | head -n 10 | sed 's/^/  -> /'
    local count
    count=$(echo "$matches" | wc -l | tr -d ' ')
    if [ "$count" -gt 10 ]; then
      echo "  ... and $((count - 10)) more occurrence(s)"
    fi
    echo ""
  fi
}

# 1. Banned Vibe Font Families
check_pattern "ERROR" "VIBE-FONT-01" \
  "Banned AI vibe-coded display font detected (Syne, Cinzel, Plus Jakarta Sans, Outfit)" \
  "font-family:.*(Syne|Cinzel|Plus Jakarta Sans|Outfit)|from ['\"]next/font/google['\"].*(Syne|Cinzel|Plus_Jakarta_Sans|Outfit)|family=(Syne|Cinzel|Plus\+Jakarta\+Sans|Outfit)"

# 2. Purple / Neon Text Gradient Slop
check_pattern "ERROR" "VIBE-GRADIENT-01" \
  "Banned indigo/violet/purple/pink text gradient detected" \
  "bg-clip-text.*(from-(indigo|violet|purple|fuchsia|pink)|via-(indigo|violet|purple|fuchsia|pink)|to-(indigo|violet|purple|fuchsia|pink))|background-clip:\s*text.*(#6366f1|#8b5cf6|#a855f7|#7c3aed|#ec4899)"

# 3. Left-border accent card strip
check_pattern "WARN" "VIBE-CARD-01" \
  "Left-border accent card trope detected (border-l-4 / border-left: 4px solid). Prefer spacing or subtle 1px full border." \
  "border-l-4|border-left:\s*[3456]px\s+solid"

# 4. Transition: all anti-pattern
check_pattern "ERROR" "MOTION-01" \
  "Banned 'transition: all' or 'transition-all' detected. Specify exact compositor properties (transform, opacity, background-color)." \
  "transition:\s*all\b|\btransition-all\b"

# 5. Viewport zoom locking (WCAG 2.2 AA violation)
check_pattern "ERROR" "A11Y-VIEWPORT-01" \
  "Banned viewport zoom lock (maximum-scale=1 or user-scalable=no) detected." \
  "maximum-scale\s*=\s*1(\.0)?|user-scalable\s*=\s*(no|0)"

# 6. Dead links
check_pattern "ERROR" "MARKUP-DEADLINK-01" \
  "Dead anchor link (href=\"#\" or href=\"javascript:void(0)\") detected. Use a <button type=\"button\"> or real route." \
  "href=['\"]#['\"]|href=['\"]javascript:void\(0\)['\"]"

# 7. AI Marketing Copy Clichés
check_pattern "ERROR" "COPY-CLICHE-01" \
  "Banned AI marketing cliché detected (Unleash, Supercharge, Seamlessly, Next-Gen, Revolutionize/Revolutionise, Transform your workflow, Harness the power)." \
  "\b(Unleash|Supercharge|Seamlessly|Next-Gen|Revolutioni[sz]e|Transform your workflow|Harness the power)\b"

# 8. Em-dashes in source copy
check_pattern "ERROR" "COPY-EMDASH-01" \
  "Banned em-dash character (—) detected in UI source. Use commas, colons, parentheses, or separate sentences." \
  "—"

# 9. LLM Meta-comments
check_pattern "WARN" "CODE-METACOMMENT-01" \
  "LLM meta-commentary detected (e.g. 'modern aesthetic', 'glassmorphic')." \
  "(//|/\*).*(\bmodern aesthetic\b|\bglassmorphic\b|\bsleek design\b|\bvibe\b)"

echo -e "${BOLD}----------------------------------------${RESET}"
if [ "$ERRORS" -gt 0 ]; then
  echo -e "${RED}${BOLD}Audit FAILED:${RESET} ${ERRORS} error category(s), ${WARNINGS} warning category(s)."
  exit 1
else
  echo -e "${GREEN}${BOLD}Audit PASSED:${RESET} 0 errors, ${WARNINGS} warning category(s)."
  exit 0
fi
