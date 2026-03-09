---
name: personal-os-daily-review
description: Morning check-in, evening reflection, and weekly review routines. Use when user says "morning routine", "evening routine", "daily review", "weekly review", "start my day", "end of day", or runs /personal-os-daily-review.
---

# Daily Review System

USE WHEN the user runs `/personal-os-daily-review` or mentions:
- "morning routine", "start my day", "morning check-in"
- "evening routine", "end of day", "wrap up", "evening reflection"
- "weekly review", "week in review", "how was my week"

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here

## Routing

Determine which routine to run:

1. **Check current time** -- if before noon, suggest morning; after 5pm, suggest evening
2. **User explicitly requests a type** -- use that
3. **Weekly is requested** -- run the weekly review
4. **Unclear** -- ask the user which one they want

| User says... | Run |
|---|---|
| "morning", "start my day", "check in" | Morning Routine |
| "evening", "end of day", "wrap up", "reflect" | Evening Routine |
| "weekly review", "week in review" | Weekly Review |

## Templates

Templates for each routine type are in `references/`:
- `references/template-morning.md` -- Morning check-in template
- `references/template-evening.md` -- Evening reflection template
- `references/template-weekly.md` -- Weekly review template

Read the appropriate template before generating the review note.

## File Naming Convention

- Morning: `Daily/YYYY-MM-DD Morning.md`
- Evening: `Daily/YYYY-MM-DD Evening.md`
- Weekly: `Daily/YYYY-MM-DD Weekly Review.md`

---

## Morning Routine

### Step 1: Review Yesterday

Read the most recent daily note from `Daily/` to see what was planned.

### Step 2: Check Tasks

Query TaskNotes API for active tasks:
```bash
curl -s "http://127.0.0.1:8080/api/tasks?status=open"
curl -s "http://127.0.0.1:8080/api/tasks?status=in-progress"
```

What's in progress? What's overdue?

### Step 3: Check Projects

Scan `Projects/` for any deadlines approaching this week.

### Step 4: Check-in with the User

Ask:
- How are you feeling today? (mood, energy level 1-10)
- What's your main focus for today?
- Anything blocking you?

### Step 5: Create Daily Note

Save to `Daily/YYYY-MM-DD Morning.md`:

```yaml
---
type: daily-note
subtype: morning
date: YYYY-MM-DD
mood: [user's answer]
energy: [1-10]
focus: [main focus]
---
```

```markdown
# Morning Check-in -- YYYY-MM-DD

## How I'm Feeling
[User's mood and energy]

## Today's Focus
[Main priority]

## Tasks for Today
- [ ] [Pulled from TaskNotes or user input]

## Blockers
[Anything blocking progress]
```

### Step 6: Suggest Tasks

Based on energy level and project deadlines, suggest 1-3 tasks. Offer to create them in TaskNotes:
```bash
curl -s -X POST "http://127.0.0.1:8080/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "Task name", "status": "open", "priority": "normal", "scheduled": "YYYY-MM-DD"}'
```

### Step 7: Wrap Up

Brief encouragement. Keep it real, not cheesy.

---

## Evening Routine

### Step 1: Review Today

Read today's morning note from `Daily/`.

### Step 2: Check Task Progress

Query TaskNotes API to compare current state vs morning intentions.

### Step 3: Ask the User

- What did you accomplish today?
- One thing you learned?
- What's your top priority for tomorrow?

### Step 4: Create Evening Note

Save to `Daily/YYYY-MM-DD Evening.md`:

```yaml
---
type: daily-note
subtype: evening
date: YYYY-MM-DD
productivity: [1-10]
---
```

```markdown
# Evening Reflection -- YYYY-MM-DD

## Accomplished
[What got done]

## Learned
[Key insight from today]

## Tomorrow's Priority
[Top focus for next day]
```

### Step 5: Update TaskNotes

Mark completed tasks as done via API, carry over in-progress items:
```bash
curl -s -X PUT "http://127.0.0.1:8080/api/tasks/Tasks/task-name.md" \
  -H "Content-Type: application/json" \
  -d '{"status": "done"}'
```

### Step 6: Update Memory

Write any new learnings to `.claude/context/memory/learnings.md`.

---

## Weekly Review

### Step 1: Read All Daily Notes

Read all daily notes from `Daily/` for the current week.

### Step 2: Scan Project Progress

Check all projects in `Projects/` for movement.

### Step 3: Review Completed Tasks

Query TaskNotes for done tasks -- celebrate wins:
```bash
curl -s "http://127.0.0.1:8080/api/tasks?status=done"
```

### Step 4: Check Goals

If `Goals/` has content:
- Check active goals and their status
- Flag goals that have no active project (they're drifting)

### Step 5: Ask the User

- What was your biggest win this week?
- What would you do differently?
- What's your focus for next week?

### Step 6: Create Weekly Note

Save to `Daily/YYYY-MM-DD Weekly Review.md`:

```yaml
---
type: daily-note
subtype: weekly-review
date: YYYY-MM-DD
week_number: [W##]
---
```

```markdown
# Weekly Review -- YYYY-MM-DD (W##)

## Wins
[Biggest accomplishments]

## Lessons
[What was learned]

## Next Week's Focus
1. [Priority 1]
2. [Priority 2]
3. [Priority 3]

## Goal Check
[Status of active goals -- any drifting?]
```

### Step 7: Plan Next Week

Identify top 3 priorities. Offer to create tasks in TaskNotes.

### Step 8: Archive

Move completed items to `Archive/` if appropriate.

### Step 9: Update Memory

Summarize the week in `.claude/context/memory/work_status.md`.

---

## Cross-References

After every review type:
- Update TaskNotes with any new or completed tasks via the API
- Update `.claude/context/memory/work_status.md` with session summary
- Add any new learnings to `.claude/context/memory/learnings.md`
- Link to relevant projects using [[wiki links]] in the daily note

## Guidelines

- Be conversational, not robotic -- this is a personal check-in
- If TaskNotes API is unavailable, note it but continue the review without task data
- Keep morning check-ins energizing and focused
- Keep evening reflections honest and concise
- Weekly reviews should be comprehensive but not exhausting
