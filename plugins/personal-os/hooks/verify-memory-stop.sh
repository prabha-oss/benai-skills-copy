#!/bin/bash
# verify-memory-stop.sh
# Fires on Stop event. Reminds Claude to update Daily notes if it hasn't recently.
# Uses a soft reminder (stdout) instead of blocking to avoid infinite loops.

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

if [ -z "$CWD" ]; then
  exit 0
fi

# Check if any Daily note was modified in the last 30 minutes
RECENT_DAILY=$(find "$CWD/Daily" -name "*.md" -mmin -30 2>/dev/null | head -1)

if [ -n "$RECENT_DAILY" ]; then
  # A Daily note was recently updated, nothing to do
  exit 0
fi

# No recent Daily note update — soft reminder only (no block)
echo "[MEMORY REMINDER] Consider updating Daily/$(date +%Y-%m-%d).md with what was accomplished this session."

exit 0
