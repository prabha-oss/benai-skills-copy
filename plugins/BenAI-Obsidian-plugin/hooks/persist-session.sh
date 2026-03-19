#!/bin/bash
# persist-session.sh
# Fires on Stop. Reminds Claude to save meaningful session info to the vault.
# Routing rules are already in claude.md — this just triggers the behavior.

# Read hook input from stdin
INPUT=$(cat)

# Prevent infinite loop: if this hook already triggered and Claude is stopping
# again after acting on it, exit silently.
if echo "$INPUT" | grep -q '"stop_hook_active"[[:space:]]*:[[:space:]]*true' 2>/dev/null; then
  exit 0
fi

cat <<'PERSIST'

[VAULT PERSIST]
Before ending: save anything meaningful from this session to the vault.
- Session progress → Daily/{date}.md
- New knowledge → route to the right file (see Knowledge Routing in claude.md)
- Decisions, learnings, project updates, resources, corrections — all have a home.
Skip if this was casual chat with nothing worth saving.
[END VAULT PERSIST]

PERSIST

exit 0
