#!/bin/bash
# verify-memory-stop.sh
# Fires on Stop event. Soft reminder if no Daily note was updated recently.

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

if [ -z "$CWD" ]; then
  exit 0
fi

if [ ! -d "$CWD/Daily" ]; then
  exit 0
fi

# Check if any Daily note was modified in the last 30 minutes
RECENT_DAILY=$(find "$CWD/Daily" -name "*.md" -mmin -30 2>/dev/null | head -1)

if [ -n "$RECENT_DAILY" ]; then
  exit 0
fi

echo "[VAULT] Consider updating Daily/$(date +%Y-%m-%d).md with session progress before ending."

exit 0
