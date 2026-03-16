#!/bin/bash
# memory-reminder.sh
# Fires on every UserPromptSubmit to remind Claude about the vault memory system.
# Mode-aware: provides routing hints based on os-mode.
# Kept minimal to avoid interfering with normal conversation.

INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null || echo "")

if [ -z "$CWD" ]; then
  CWD="${CLAUDE_PROJECT_DIR:-}"
fi

# Detect os-mode from claude.md frontmatter
OS_MODE="general"
if [ -n "$CWD" ] && [ -f "$CWD/claude.md" ]; then
  DETECTED_MODE=$(grep -m1 'os-mode:' "$CWD/claude.md" 2>/dev/null | sed 's/.*os-mode:\s*//' | tr -d '[:space:]')
  if [ -n "$DETECTED_MODE" ]; then
    OS_MODE="$DETECTED_MODE"
  fi
fi

case "$OS_MODE" in
  business)
    cat <<'REMINDER'

[VAULT MEMORY — business mode]
This project uses an Obsidian vault for persistent memory. When you make meaningful changes or learn something important during this conversation, update the relevant vault files:
- Daily/{date}.md — session progress
- Context/operator.md — operator preferences
- Context/organization.md — org info
- Context/strategy.md — OKRs and goals
- Projects/{name}/ — project info (route to right subdir)
- Departments/{name}/ — department info, SOPs
- Intelligence/processes/ — org-wide SOPs, runbooks
- Intelligence/decisions/ — decisions with reasoning
Only update when there's something worth saving. Normal chat doesn't need updates.
[END VAULT MEMORY]

REMINDER
    ;;
  personal)
    cat <<'REMINDER'

[VAULT MEMORY — personal mode]
This project uses an Obsidian vault for persistent memory. When you make meaningful changes or learn something important during this conversation, update the relevant vault files:
- Daily/{date}.md — session progress
- Context/me.md — preferences, personality, values
- Context/goals.md — goals, intentions, habits
- Projects/{name}/ — project info (route to right subdir)
- Areas/{area}.md — life area updates
- Collections/{type}.md — books, articles, courses
- Intelligence/decisions/ — decisions with reasoning
Only update when there's something worth saving. Normal chat doesn't need updates.
[END VAULT MEMORY]

REMINDER
    ;;
  *)
    cat <<'REMINDER'

[VAULT MEMORY]
This project uses an Obsidian vault for persistent memory. When you make meaningful changes or learn something important during this conversation, update the relevant vault files:
- Daily/{date}.md — session progress
- Context/me.md — user preferences
- Projects/{name}/ — project info (route to right subdir)
- Intelligence/decisions/ — decisions with reasoning
- Intelligence/competitors/ — competitive insights
Only update when there's something worth saving. Normal chat doesn't need updates.
[END VAULT MEMORY]

REMINDER
    ;;
esac

exit 0
