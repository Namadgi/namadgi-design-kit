#!/usr/bin/env bash
# ==============================================================================
# Namadgi Design Kit Installer (install.sh)
# Installs the 12 curated Namadgi UI/UX design skills, the AGENTS.md / CLAUDE.md
# design policy rules, and the anti-vibe-slop scanner into any target repository
# and/or global agent configuration directory.
#
# Usage:
#   ./install.sh --global-agy --global-claude --target /path/to/repo
#   ./install.sh --target /path/to/repo
#   ./install.sh --global-agy
#   ./install.sh --global-claude
# ==============================================================================

set -euo pipefail

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DO_GLOBAL_AGY=false
DO_GLOBAL_CLAUDE=false
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

if [[ $# -eq 0 ]]; then
  usage
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target)
      TARGET_DIR="$2"
      shift 2
      ;;
    --global-agy)
      DO_GLOBAL_AGY=true
      shift
      ;;
    --global-claude)
      DO_GLOBAL_CLAUDE=true
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

install_global_skills() {
  local dest_dir="$1"
  local label="$2"
  mkdir -p "$dest_dir"
  echo "Installing 12 Namadgi Design Skills into $dest_dir ($label) ..."
  for skill_path in "$KIT_DIR/skills"/namadgi-*; do
    local skill_name
    skill_name="$(basename "$skill_path")"
    rm -rf "${dest_dir:?}/$skill_name"
    cp -R "$skill_path" "$dest_dir/$skill_name"
    echo "  + Installed $skill_name"
  done
  echo "Done. All 12 skills are now available globally in $dest_dir."
  echo ""
}

if [[ "$DO_GLOBAL_AGY" == true ]]; then
  install_global_skills "$HOME/.gemini/config/skills" "Google Antigravity"
fi

if [[ "$DO_GLOBAL_CLAUDE" == true ]]; then
  install_global_skills "$HOME/.claude/skills" "Claude Code"
fi

if [[ -n "$TARGET_DIR" ]]; then
  if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Target directory '$TARGET_DIR' does not exist." >&2
    exit 1
  fi

  TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"
  echo "Installing Namadgi Design Kit into repository: $TARGET_DIR"

  # 1. Install skills into .agents/skills/ and .claude/skills/
  for skills_subdir in ".agents/skills" ".claude/skills"; do
    mkdir -p "$TARGET_DIR/$skills_subdir"
    for skill_path in "$KIT_DIR/skills"/namadgi-*; do
      skill_name="$(basename "$skill_path")"
      rm -rf "$TARGET_DIR/$skills_subdir/$skill_name"
      cp -R "$skill_path" "$TARGET_DIR/$skills_subdir/$skill_name"
    done
    echo "  + Installed 12 skills into $skills_subdir/"
  done

  # 2. Install Cursor / Windsurf rules file
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
fi
