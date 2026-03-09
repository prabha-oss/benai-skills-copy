#!/bin/bash
# verify-memory-stop.sh
# Fires on Stop event. Checks if memory was updated this session.
# If not, blocks Claude from finishing until memory is updated.

set -euo pipefail

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

if [ -z "$CWD" ]; then
  exit 0
fi

MEMORY_STATUS="$CWD/.claude/context/memory/work_status.md"

# Check if work_status.md was modified in the last 5 minutes (300 seconds)
if [ -f "$MEMORY_STATUS" ]; then
  if [ "$(uname)" = "Darwin" ]; then
    LAST_MODIFIED=$(stat -f %m "$MEMORY_STATUS")
  else
    LAST_MODIFIED=$(stat -c %Y "$MEMORY_STATUS")
  fi
  NOW=$(date +%s)
  DIFF=$((NOW - LAST_MODIFIED))

  if [ "$DIFF" -lt 300 ]; then
    # Memory was recently updated, allow stop
    exit 0
  fi
fi

# Memory was NOT updated — block the stop
cat <<'EOF'
{
  "decision": "block",
  "reason": "MEMORY UPDATE REQUIRED: You must update context/memory/work_status.md before stopping. Review this conversation for: what was accomplished, what's pending, and what the next steps are. Also update other memory files (learnings.md, user_preferences.md, user_projects.md) if you learned anything new."
}
EOF

exit 0
