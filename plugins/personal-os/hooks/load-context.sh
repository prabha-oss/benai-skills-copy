#!/bin/bash
# load-context.sh
# Fires on every UserPromptSubmit to inject the context system into Claude's context.
# This ensures Claude always has awareness of the memory and project systems.

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

if [ -z "$CWD" ]; then
  CWD="$CLAUDE_PROJECT_DIR"
fi

CONTEXT_FILE="$CWD/.claude/context/CLAUDE.md"
MEMORY_STATUS="$CWD/.claude/context/memory/work_status.md"
MEMORY_PREFS="$CWD/.claude/context/memory/user_preferences.md"

# Build context injection
echo "=== CONTEXT SYSTEM LOADED ==="

# Load context overview
if [ -f "$CONTEXT_FILE" ]; then
  echo ""
  echo "--- Context Overview ---"
  head -30 "$CONTEXT_FILE"
  echo "--- End Context Overview ---"
fi

# Load work status (most recent session info)
if [ -f "$MEMORY_STATUS" ]; then
  echo ""
  echo "--- Current Work Status ---"
  cat "$MEMORY_STATUS"
  echo "--- End Work Status ---"
fi

# Load user preferences (communication style, settings)
if [ -f "$MEMORY_PREFS" ]; then
  echo ""
  echo "--- User Preferences ---"
  cat "$MEMORY_PREFS"
  echo "--- End User Preferences ---"
fi

echo ""
echo "=== END CONTEXT SYSTEM ==="

exit 0
