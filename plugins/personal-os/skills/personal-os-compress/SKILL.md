---
name: personal-os-compress
description: Save the current session before ending — creates a session log, updates memory, and archives if needed. Use when user says "compress", "save session", "end session", "wrap up", or runs /personal-os-compress.
---

# Session Compress (Save)

USE WHEN the user runs `/personal-os-compress` or says "compress", "save session", "end session", "wrap up", "I'm done for today".

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here

## Workflow

You are saving the current session before the user ends their work. Your job is to preserve everything valuable so future sessions can pick up seamlessly.

### Step 1: Ask What to Preserve

Present a checklist to the user:

"Before we wrap up, what should I save from this session?"

- [ ] **Key learnings** -- Insights, things that worked or didn't
- [ ] **Decisions made** -- Important choices and reasoning
- [ ] **Solutions & fixes** -- Problems solved, workarounds found
- [ ] **Files modified** -- What was created, edited, or moved
- [ ] **Pending tasks** -- Things still to do
- [ ] **Errors & workarounds** -- Issues encountered and how they were handled
- [ ] **All of the above** (recommended)

If the user says "all" or "everything" or just wants to move fast, save everything.

### Step 2: Create Session Log in Daily Note

Append the session log to today's daily note at `Daily/YYYY-MM-DD.md`. If the file already exists (e.g., from a morning review or earlier session), append a new section. If it doesn't exist, create it.

Use this format for the session log section:

```markdown
---
type: daily-note
date: YYYY-MM-DD
---

## Session Log: HH:MM -- [Topic Summary]

### Quick Reference
**Topics:** [comma-separated list]
**Projects:** [related projects]
**Outcome:** [what was accomplished]
**Duration:** [approximate time spent]

### Decisions Made
- [Decision 1 -- reasoning]
- [Decision 2 -- reasoning]

### Key Learnings
- [Learning 1]
- [Learning 2]

### Solutions & Fixes
- [Problem -> Solution]

### Files Modified
- [file path -- what changed]

### Pending Tasks
- [ ] [Task 1]
- [ ] [Task 2]

### Errors & Workarounds
- [Error -> Workaround]

---

### Raw Session Summary
[Condensed summary of the full conversation -- enough context to understand what happened without reading the raw transcript. Include key exchanges, not verbatim dialogue.]
```

Note: Only include the YAML frontmatter if creating a new daily note. When appending to an existing note, just add the session log section.

### Important: The Quick Reference Section

The Quick Reference is designed for AI scanning. When `/personal-os-resume` runs in a future session, it reads Quick Reference sections first (fast, low token cost). Only if more detail is needed does it dig into the full note.

Keep Quick Reference to 5-6 lines max.

### Step 3: Update Memory Files

Based on what was preserved:

- **Learnings** -> Append to `Thinking/learnings.md`
- **User preferences discovered** -> Update `Reference/about-me.md`
- **Project updates** -> Update `Projects/{name}/README.md`
- **Pending tasks** -> Create in TaskNotes via API:
  ```bash
  curl -s -X POST "http://127.0.0.1:8080/api/tasks" \
    -H "Content-Type: application/json" \
    -d '{"title": "Task", "status": "open"}'
  ```

### Step 4: Update Today's Daily Note

Update today's `Daily/YYYY-MM-DD.md` with the session wrap-up status:

```markdown
## Work Status
- **Date**: YYYY-MM-DD
- **Focus**: [what we worked on]
- **Completed**: [list]
- **Pending**: [list]
- **Next Steps**: [what to do next time]
```

If the daily note already has a Work Status section, update it. Otherwise append it.

### Step 5: Check Memory Size (Auto-Archive)

If `Thinking/learnings.md` exceeds 150 lines:
- Archive older entries to `Archive/learnings-archive-YYYY-MM.md`
- Keep only the most recent and most important entries in the main file

**Protected content** (never archive):
- Current active projects in `Projects/*/README.md`
- Core preferences in `Reference/about-me.md`
- The most recent 20 learnings in `Thinking/learnings.md`

### Step 6: Confirm

Tell the user:
- What was saved and where
- Summary of pending tasks
- "You're safe to close. I'll remember everything next time you run `/personal-os-resume`."

## Guidelines

- Don't skip steps -- every session should leave a clean trail
- If the session was short or trivial, create a minimal log (Quick Reference only, skip empty sections)
- Be thorough with the Raw Session Summary -- future you needs enough context to reconstruct what happened
- Always update today's `Daily/YYYY-MM-DD.md` -- this is the most-read memory file
