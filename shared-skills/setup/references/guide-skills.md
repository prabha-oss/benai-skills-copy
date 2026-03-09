---
type: guide
folder: Skills
---

# Custom Skills

Create your own reusable skills that your assistant can discover and run.

## How It Works

1. Create a folder in `Skills/` with your skill name
2. Add a `skill.md` file with trigger words and steps
3. Your assistant auto-discovers skills and matches them to your requests

## Skill Template

```markdown
---
name: skill-name
trigger: ["keyword1", "keyword2", "phrase"]
---
# Skill Name

## What This Does
[1-2 sentences]

## Steps
1. [Step 1 — what to read, check, or do]
2. [Step 2]
3. [Step 3]

## Output
[What the result looks like]
```

## Example: Morning Brief

```
Skills/morning-brief/skill.md
```

```markdown
---
name: morning-brief
trigger: ["morning brief", "morning", "standup"]
---
# Morning Brief

## What This Does
Quick morning overview of priorities, tasks, and schedule.

## Steps
1. Read `Context/strategy.md` — current monthly focus
2. Check open tasks via TaskNotes or Obsidian CLI
3. Check today's meetings in `Intelligence/meetings/`
4. Scan recent daily notes for carry-over items

## Output
Concise briefing: top priorities, open tasks, today's meetings, blockers.
```

## Tips
- Keep skills focused — one skill, one job
- Use `trigger` keywords that feel natural to how you'd ask for it
- Reference vault paths in steps so the assistant knows where to look
- Skills can reference other skills (e.g., "run morning-brief then create tasks")
