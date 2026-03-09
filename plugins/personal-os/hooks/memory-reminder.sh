#!/bin/bash
# memory-reminder.sh
# Fires on every UserPromptSubmit to remind Claude about the vault memory system.
# Kept minimal to avoid interfering with normal conversation.

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

exit 0
