# Memory System

This is your persistent memory. Files here are your long-term storage.

## Core Memory Files

| File | What to Store | Update Frequency |
|------|--------------|-----------------|
| `learnings.md` | Insights, patterns, things that worked or failed | When you learn something new |
| `user_preferences.md` | How the user likes things done, their style, pet peeves | When preferences are revealed |
| `user_projects.md` | Active projects, deadlines, key details | When project info changes |
| `work_status.md` | What you did this session, pending items, next steps | Every conversation turn |

## Memory Policy

1. Use filesystem tools (Read/Edit/Write) to manage these files
2. Keep entries concise and scannable — use bullet points and headers
3. Avoid duplicates — check existing content before adding
4. Create topic-specific files as needed (e.g., `youtube-strategy.md`, `fitness-goals.md`)
5. Never delete memories unless the user explicitly asks
6. Safety: Only operate within `context/memory/` — no path traversal

## Work Status Format

The `work_status.md` file should follow this format:

```markdown
# Work Status

## Current Session
- **Date**: YYYY-MM-DD
- **Focus**: What we're working on
- **Completed**: List of things done
- **Pending**: List of things still to do
- **Next Steps**: What to do next session

## Recent Sessions
(Keep last 5 sessions, archive older ones)
```

## When to Create New Memory Files

If a topic keeps coming up across multiple conversations and the entries in `learnings.md` are getting long, create a dedicated file:

- `youtube-strategy.md` — If the user frequently works on YouTube content
- `fitness-goals.md` — If they track health/fitness
- `meeting-patterns.md` — If recurring meeting themes emerge
- `family.md` — If they share family-related context

Name files descriptively. Use kebab-case.
