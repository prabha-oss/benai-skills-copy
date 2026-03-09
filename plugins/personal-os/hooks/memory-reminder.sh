#!/bin/bash
# memory-reminder.sh
# Fires on every UserPromptSubmit to remind Claude to update Obsidian vault notes.
# For UserPromptSubmit, stdout text is injected directly into Claude's context.

set -euo pipefail

cat <<'REMINDER'

[MEMORY PROTOCOL - ACTIVE]
After completing the user's request, you MUST:

1. REFLECT on what was discussed and what you learned this turn.
2. UPDATE `Daily/YYYY-MM-DD.md` with current session progress (work status).
3. If you learned new user preferences, update `Reference/about-me.md`.
4. If you discovered new project info, update `Projects/{name}/README.md`.
5. If you gained a reusable insight, add it to `Thinking/learnings.md`.
6. Keep all notes concise and scannable.
7. Do NOT skip this step. Memory updates are mandatory.

[END MEMORY PROTOCOL]

REMINDER

exit 0
