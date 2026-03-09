#!/bin/bash
# verify-memory-stop.sh
# Fires on Stop event. Reminds Claude to update memory if it hasn't recently.
# Uses a soft reminder (stdout) instead of blocking to avoid infinite loops.

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

if [ -z "$CWD" ]; then
  exit 0
fi

MEMORY_STATUS="$CWD/.claude/context/memory/work_status.md"

# Check if work_status.md was modified in the last 30 minutes (1800 seconds)
if [ -f "$MEMORY_STATUS" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    LAST_MODIFIED=$(stat -f %m "$MEMORY_STATUS")
  else
    LAST_MODIFIED=$(stat -c %Y "$MEMORY_STATUS")
  fi
  NOW=$(date +%s)
  DIFF=$((NOW - LAST_MODIFIED))

  if [ "$DIFF" -lt 1800 ]; then
    # Memory was recently updated, nothing to do
    exit 0
  fi
fi

# Memory was NOT updated recently — soft reminder only (no block)
echo "[MEMORY REMINDER] Consider updating .claude/context/memory/work_status.md with what was accomplished this session."

exit 0
