#!/usr/bin/env bash
# Lord of the Code — Install skill, agents, and /lotc alias
# Works on Linux, macOS, and Windows (Git Bash / MSYS2 / WSL).

set -euo pipefail

AGENTS_DIR="${HOME}/.claude/agents"
SKILL_DIR="${HOME}/.claude/skills/lord-of-the-code"
ALIAS_DIR="${HOME}/.claude/skills/lotc"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${SCRIPT_DIR}/agents"
SKILL_SRC="${SCRIPT_DIR}/SKILL.md"

echo "=== Lord of the Code — Install ==="
echo ""

# Validate source
if [ ! -f "$SKILL_SRC" ]; then
    echo "ERROR: SKILL.md not found in ${SCRIPT_DIR}/"
    echo "Make sure you're running this from the lord-of-the-code directory."
    exit 1
fi
if [ ! -d "$SRC_DIR" ] || [ -z "$(ls "$SRC_DIR"/*.md 2>/dev/null)" ]; then
    echo "ERROR: No agent files found in ${SRC_DIR}/"
    exit 1
fi

# Create target directories
mkdir -p "$AGENTS_DIR"
mkdir -p "$SKILL_DIR"
mkdir -p "$ALIAS_DIR"

INSTALLED=0
UNCHANGED=0

# --- Install agents ---
echo "Agents:"
for src in "$SRC_DIR"/*.md; do
    name=$(basename "$src")
    dest="${AGENTS_DIR}/${name}"
    if [ -f "$dest" ] && diff -q "$src" "$dest" >/dev/null 2>&1; then
        UNCHANGED=$((UNCHANGED + 1))
        continue
    fi
    if [ -f "$dest" ]; then
        echo "  Updated: $name"
    else
        echo "  Installed: $name"
    fi
    cp "$src" "$dest"
    INSTALLED=$((INSTALLED + 1))
done
echo "  ($UNCHANGED unchanged)"

# --- Install skill ---
echo ""
echo "Skill:"
dest="${SKILL_DIR}/SKILL.md"
if [ -f "$dest" ] && diff -q "$SKILL_SRC" "$dest" >/dev/null 2>&1; then
    echo "  SKILL.md (unchanged)"
else
    cp "$SKILL_SRC" "$dest"
    echo "  Installed: ~/.claude/skills/lord-of-the-code/SKILL.md"
    INSTALLED=$((INSTALLED + 1))
fi

# --- Install /lotc alias ---
# Same SKILL.md with the name field patched to "lotc"
echo ""
echo "Alias (/lotc):"
alias_dest="${ALIAS_DIR}/SKILL.md"
sed 's/^name: lord-of-the-code$/name: lotc/' "$SKILL_SRC" > "${alias_dest}.tmp"
if [ -f "$alias_dest" ] && diff -q "${alias_dest}.tmp" "$alias_dest" >/dev/null 2>&1; then
    echo "  SKILL.md (unchanged)"
    rm "${alias_dest}.tmp"
else
    mv "${alias_dest}.tmp" "$alias_dest"
    echo "  Installed: ~/.claude/skills/lotc/SKILL.md"
    INSTALLED=$((INSTALLED + 1))
fi

echo ""
echo "=== Done ==="
echo "  Installed/updated: $INSTALLED file(s)"
echo "  Agents:  $AGENTS_DIR/"
echo "  Skill:   $SKILL_DIR/"
echo "  Alias:   $ALIAS_DIR/"
echo ""
echo "Restart Claude Code to load the changes."
echo ""
echo "Usage:"
echo "  /lord-of-the-code [formation]    Full name"
echo "  /lotc [formation]                Shorthand"
echo "  /lotc scribe-merge               Review → fix → merge workflow"
