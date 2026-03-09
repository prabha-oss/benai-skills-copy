#!/bin/bash
# load-context.sh
# Fires on every UserPromptSubmit to inject context from Obsidian vault into Claude's context.
# This ensures Claude always has awareness of user identity and current session state.

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

if [ -z "$CWD" ]; then
  CWD="$CLAUDE_PROJECT_DIR"
fi

ABOUT_ME="$CWD/Reference/about-me.md"
LATEST_DAILY=$(ls -t "$CWD"/Daily/*.md 2>/dev/null | head -1)

# Build context injection
echo "=== CONTEXT SYSTEM LOADED ==="

# Load user identity & preferences
if [ -f "$ABOUT_ME" ]; then
  echo ""
  echo "--- User Identity & Preferences ---"
  cat "$ABOUT_ME"
  echo "--- End User Identity & Preferences ---"
fi

# Load most recent daily note (current session state)
if [ -n "$LATEST_DAILY" ] && [ -f "$LATEST_DAILY" ]; then
  echo ""
  echo "--- Current Session State ($(basename "$LATEST_DAILY")) ---"
  cat "$LATEST_DAILY"
  echo "--- End Current Session State ---"
fi

echo ""
echo "=== END CONTEXT SYSTEM ==="

exit 0
