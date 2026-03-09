---
name: personal-os-resume
description: Resume a work session by loading memory, session logs, tasks, and goals. Use when user says "resume", "start session", "pick up where I left off", "what was I working on", or runs /personal-os-resume.
---

# Session Resume

USE WHEN the user runs `/personal-os-resume` or says "resume", "start session", "pick up where I left off", "what was I working on".

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here

## Workflow

You are resuming a work session. Your job is to reconstruct full context so the user picks up exactly where they left off.

### Step 1: Load Core Memory

Read these files in order:
1. `Reference/about-me.md` -- Who the user is (preferences, style, habits)
2. Glob `Projects/*/README.md` -- Active projects and their context
3. `Thinking/learnings.md` -- Key insights and patterns

### Step 2: Load Recent Daily Notes

Check `Daily/` for recent daily notes (these contain session logs, morning/evening reviews, and work status).

**Default behavior** (no arguments): Load the last 3 daily notes (sorted by filename date).
**With a number** (e.g., `/personal-os-resume 10`): Load the last N daily notes.
**With a keyword** (e.g., `/personal-os-resume auth`): Load last 3 daily notes + search ALL daily notes for the keyword.
**With both** (e.g., `/personal-os-resume 5 meetings`): Load last N daily notes + search for keyword.

Daily notes may contain session logs with a Quick Reference section -- read that first (fast, low token use). Only dig into the full note if more detail is needed.

### Step 3: Check Active Tasks

Query TaskNotes API for active tasks:
```bash
curl -s "http://127.0.0.1:8080/api/tasks?status=open"
curl -s "http://127.0.0.1:8080/api/tasks?status=in-progress"
```

Check:
- What's in progress?
- What's overdue (check due dates)?
- Any open tasks that should be addressed?

If the TaskNotes API is not available (Obsidian closed), note this in the briefing and skip task checks.

### Step 4: Check Goals (if they exist)

If `Goals/` has content, scan for:
- Active goals and their status
- Any quarterly milestones approaching

### Step 5: Present the Briefing

Deliver a concise briefing to the user:

```
Welcome back, [name].

**Last session** (date): [Brief summary of what was done]

**In Progress**: [List of active tasks]

**Pending from last time**: [Items left over]

**Upcoming**: [Deadlines, milestones, scheduled meetings]

**What would you like to focus on today?**
```

Keep it brief. Don't dump every memory -- surface what's relevant right now.

### Step 6: Update Today's Daily Note

After the briefing, create or update today's `Daily/YYYY-MM-DD.md` to reflect the new session start:

```markdown
## Current Session
- **Date**: [today]
- **Focus**: Awaiting user input
- **Resumed from**: [last session date and topic]
```

If today's daily note already exists, append the session start to it rather than overwriting.

## Guidelines

- Be concise -- the briefing should feel like a quick standup, not a data dump
- Prioritize what's actionable: overdue tasks, deadlines this week, unfinished work
- If memory files are empty (new vault), acknowledge it: "This is your first session. What would you like to work on?"
- Use the user's name if available from `Reference/about-me.md`
