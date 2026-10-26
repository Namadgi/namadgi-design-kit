#!/usr/bin/env bash
# ==============================================================================
# Namadgi Design Kit Installer (install.sh)
# Installs the 12 curated Namadgi UI/UX design skills, the AGENTS.md / CLAUDE.md
# design policy rules, and the anti-vibe-slop scanner into any target repository
# or global agent configuration directory.
#
# Usage:
#   ./namadgi-design-kit/install.sh --target /path/to/repo
#   ./namadgi-design-kit/install.sh --global-agy
#   ./namadgi-design-kit/install.sh --global-claude
# ==============================================================================

set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE=""
TARGET_DIR=""

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --target <path>     Install rules, skills, and audit script into a project repository
  --global-agy        Install skills into ~/.gemini/config/skills/ for Google Antigravity
  --global-claude     Install skills into ~/.claude/skills/ for Claude Code
  -h, --help          Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      MODE="repo"
      TARGET_DIR="$2"
      shift 2
      ;;
    --global-agy)
      MODE="global-agy"
      TARGET_DIR="$HOME/.gemini/config/skills"
      shift
      ;;
    --global-claude)
      MODE="global-claude"
      TARGET_DIR="$HOME/.claude/skills"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$MODE" ]]; then
  usage
  exit 1
fi

if [[ "$MODE" == "global-agy" || "$MODE" == "global-claude" ]]; then
  mkdir -p "$TARGET_DIR"
  echo "Installing 12 Namadgi Design Skills into $TARGET_DIR ..."
  for skill_path in "$KIT_DIR/skills"/namadgi-*; do
    skill_name="$(basename "$skill_path")"
    rm -rf "${TARGET_DIR:?}/$skill_name"
    cp -R "$skill_path" "$TARGET_DIR/$skill_name"
    echo "  + Installed $skill_name"
  done
  echo "Done. All 12 skills are now available globally in $TARGET_DIR."
  exit 0
fi

# Repository installation mode
if [[ ! -d "$TARGET_DIR" ]]; then
  echo "Error: Target directory '$TARGET_DIR' does not exist." >&2
  exit 1
fi

TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
echo "Installing Namadgi Design Kit into repository: $TARGET_DIR"

# 1. Install skills into .agents/skills/ and .claude/skills/
mkdir -p "$TARGET_DIR/.agents/skills"
for skill_path in "$KIT_DIR/skills"/namadgi-*; do
  skill_name="$(basename "$skill_path")"
  rm -rf "$TARGET_DIR/.agents/skills/$skill_name"
  cp -R "$skill_path" "$TARGET_DIR/.agents/skills/$skill_name"
  echo "  + Installed skill: .agents/skills/$skill_name"
done

# 2. Install Cursor / Windsurf / Claude rules file
mkdir -p "$TARGET_DIR/.cursor/rules"
cp "$KIT_DIR/rules/namadgi-design-standards.md" "$TARGET_DIR/.cursor/rules/namadgi-design-standards.mdc"
echo "  + Installed rule:  .cursor/rules/namadgi-design-standards.mdc"

# 3. Append or create AGENTS.md / CLAUDE.md reference if not already present
MARKER="<!-- NAMADGI-DESIGN-STANDARDS -->"
for doc_file in "AGENTS.md" "CLAUDE.md"; do
  target_doc="$TARGET_DIR/$doc_file"
  if [[ -f "$target_doc" ]]; then
    if ! grep -q "$MARKER" "$target_doc"; then
      {
        echo ""
        echo "$MARKER"
        cat "$KIT_DIR/rules/namadgi-design-standards.md"
      } >> "$target_doc"
      echo "  + Appended Namadgi Design Standards to existing $doc_file"
    else
      echo "  = $doc_file already contains Namadgi Design Standards ($MARKER)"
    fi
  else
    {
      echo "$MARKER"
      cat "$KIT_DIR/rules/namadgi-design-standards.md"
    } > "$target_doc"
    echo "  + Created $doc_file with Namadgi Design Standards"
  fi
done

# 4. Install static scanner script
mkdir -p "$TARGET_DIR/scripts"
cp "$KIT_DIR/scripts/audit-vibe-slop.sh" "$TARGET_DIR/scripts/audit-vibe-slop.sh"
chmod +x "$TARGET_DIR/scripts/audit-vibe-slop.sh"
echo "  + Installed scanner: scripts/audit-vibe-slop.sh"

echo ""
echo "Namadgi Design Kit successfully installed in $TARGET_DIR"
