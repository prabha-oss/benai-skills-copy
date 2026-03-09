#!/bin/bash
# load-context.sh
# Fires on every UserPromptSubmit to inject context from Obsidian vault into Claude's context.
# Silently exits if vault files don't exist yet (pre-setup state).

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

if [ -z "$CWD" ]; then
  CWD="${CLAUDE_PROJECT_DIR:-}"
fi

if [ -z "$CWD" ]; then
  exit 0
fi

ABOUT_ME="$CWD/Context/me.md"
LATEST_DAILY=""

# Safely find the most recent daily note (no crash if folder is empty/missing)
if [ -d "$CWD/Daily" ]; then
  LATEST_DAILY=$(find "$CWD/Daily" -maxdepth 1 -name "*.md" -type f 2>/dev/null | sort -r | head -1)
fi

# Only output if there's something to inject
HAS_CONTEXT=false

if [ -f "$ABOUT_ME" ]; then
  HAS_CONTEXT=true
fi

if [ -n "$LATEST_DAILY" ] && [ -f "$LATEST_DAILY" ]; then
  HAS_CONTEXT=true
fi

if [ "$HAS_CONTEXT" = false ]; then
  exit 0
fi

echo "=== VAULT CONTEXT ==="

if [ -f "$ABOUT_ME" ]; then
  echo ""
  echo "--- User Identity ---"
  cat "$ABOUT_ME"
  echo ""
  echo "--- End User Identity ---"
fi

if [ -n "$LATEST_DAILY" ] && [ -f "$LATEST_DAILY" ]; then
  echo ""
  echo "--- Latest Daily Note ($(basename "$LATEST_DAILY")) ---"
  cat "$LATEST_DAILY"
  echo ""
  echo "--- End Latest Daily Note ---"
fi

echo "=== END VAULT CONTEXT ==="

exit 0
