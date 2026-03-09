#!/bin/bash
# memory-reminder.sh
# Fires on every UserPromptSubmit to remind Claude to update memory files.
# For UserPromptSubmit, stdout text is injected directly into Claude's context.

set -euo pipefail

cat <<'REMINDER'

[MEMORY PROTOCOL - ACTIVE]
After completing the user's request, you MUST:

1. REFLECT on what was discussed and what you learned this turn.
2. UPDATE `context/memory/work_status.md` with current session progress.
3. If you learned new user preferences, update `context/memory/user_preferences.md`.
4. If you discovered new project info, update `context/memory/user_projects.md`.
5. If you gained a reusable insight, add it to `context/memory/learnings.md`.
6. Keep all memory files concise and scannable.
7. Do NOT skip this step. Memory updates are mandatory.

[END MEMORY PROTOCOL]

REMINDER

exit 0
