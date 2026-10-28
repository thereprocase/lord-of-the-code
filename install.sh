#!/usr/bin/env bash
# Lord of the Code — Install skill, agents, and /lotc alias
# Works on Linux, macOS, and Windows (Git Bash / MSYS2 / WSL).
#
# Destinations that differ from the source are backed up beside themselves as
# <file>.bak-<UTC timestamp> before they are replaced: the agent files set the
# tools, model and effort that reviewers run with, so an overwrite is a change
# to what runs with Bash and Write on every later review.

set -euo pipefail

AGENTS_DIR="${HOME}/.claude/agents"
SKILL_DIR="${HOME}/.claude/skills/lord-of-the-code"
ALIAS_DIR="${HOME}/.claude/skills/lotc"
RUNS_DIR="${HOME}/.local/share/lotc/runs"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="${SCRIPT_DIR}/agents"
SKILL_SRC="${SCRIPT_DIR}/SKILL.md"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"

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

# Create target directories. The run directory is created with owner-only
# permissions because review reports quote the code they reviewed.
mkdir -p "$AGENTS_DIR" "$SKILL_DIR/agents" "$ALIAS_DIR" "$(dirname "$RUNS_DIR")"
# On Windows (Git Bash) mkdir -m fails to set the mode after creating the
# directory; the directory then inherits the user profile's permissions.
[ -d "$RUNS_DIR" ] || mkdir -m 700 "$RUNS_DIR" 2>/dev/null || [ -d "$RUNS_DIR" ]

INSTALLED=0
UNCHANGED=0
BACKED_UP=0

# place SRC DEST LABEL — copy SRC to DEST unless identical. Refuses to write
# through a symlink (the target could be a dotfiles checkout) and backs up a
# differing regular file first.
place() {
    local src="$1" dest="$2" label="$3"
    if [ -L "$dest" ]; then
        echo "  Skipped: $label is a symlink ($(readlink "$dest")); update its target instead"
        return
    fi
    if [ -f "$dest" ] && diff -q "$src" "$dest" >/dev/null 2>&1; then
        UNCHANGED=$((UNCHANGED + 1))
        return
    fi
    if [ -f "$dest" ]; then
        cp -p "$dest" "${dest}.bak-${STAMP}"
        BACKED_UP=$((BACKED_UP + 1))
        echo "  Updated: $label (backup: $(basename "$dest").bak-${STAMP})"
    else
        echo "  Installed: $label"
    fi
    install -m 644 "$src" "$dest"
    INSTALLED=$((INSTALLED + 1))
}

# --- Install agents (to ~/.claude/agents and, for the skill's fallback path, next to the skill) ---
echo "Agents:"
for src in "$SRC_DIR"/*.md; do
    name=$(basename "$src")
    place "$src" "${AGENTS_DIR}/${name}" "$name"
    place "$src" "${SKILL_DIR}/agents/${name}" "agents/${name} (skill copy)"
done
echo "  ($UNCHANGED unchanged)"

# --- Install skill ---
echo ""
echo "Skill:"
place "$SKILL_SRC" "${SKILL_DIR}/SKILL.md" "SKILL.md"

# --- Install /lotc alias ---
# Same SKILL.md with the name field patched to "lotc"
echo ""
echo "Alias (/lotc):"
alias_tmp="${ALIAS_DIR}/SKILL.md.tmp"
sed 's/^name: lord-of-the-code$/name: lotc/' "$SKILL_SRC" > "$alias_tmp"
place "$alias_tmp" "${ALIAS_DIR}/SKILL.md" "SKILL.md (alias)"
rm -f "$alias_tmp"

echo ""
echo "=== Done ==="
echo "  Installed/updated: $INSTALLED file(s), backed up: $BACKED_UP"
echo "  Agents:  $AGENTS_DIR/"
echo "  Skill:   $SKILL_DIR/"
echo "  Alias:   $ALIAS_DIR/"
echo "  Runs:    $RUNS_DIR/  (reviewer reports and fix proofs land here)"
echo ""
echo "Permissions: reviewers write their reports under $RUNS_DIR."
echo "If your Claude Code allow rules do not already cover it, add this rule to"
echo "$HOME/.claude/settings.json permissions.allow, or report writes are refused in auto mode:"
echo "  \"Write(${RUNS_DIR}/**)\""
echo ""
echo "Restart Claude Code to load the changes."
echo ""
echo "Usage:"
echo "  /lord-of-the-code [formation]    Full name"
echo "  /lotc [formation]                Shorthand"
echo "  /lotc scribe-merge               Review → fix → merge workflow"
