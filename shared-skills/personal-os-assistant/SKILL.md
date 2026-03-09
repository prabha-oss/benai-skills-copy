---
name: personal-os-assistant
description: Personal OS assistant — manages sessions, daily routines, tasks, memory, and output styles. Handles resume, compress, preserve, daily review, task management, and style switching.
---

# Personal OS Assistant

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If missing: tell the user "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS." -- then stop
3. If present: continue

## Routing

Match the user's intent to the right section:

| User says... | Go to |
|---|---|
| "resume", "start session", "pick up where I left off" | [Resume Session](#resume-session) |
| "save", "compress", "end session", "wrap up session" | [Compress / Save Session](#compress--save-session) |
| "remember this", "preserve", "save permanently" | [Preserve Learnings](#preserve-learnings) |
| "morning", "evening", "daily review", "weekly review" | [Daily Review](#daily-review) |
| "task", "to-do", "create task", "check tasks" | [Task Management](#task-management) |
| "output style", "writing style", "switch style" | [Output Styles](#output-styles) |

If unclear, show this table and ask what they need.

## Vault Structure

```
CLAUDE.md                  -- Root config (operating instructions)
.claude/output-styles/     -- Output style definitions
Reference/about-me.md      -- Who the user is
Thinking/learnings.md      -- Key insights and patterns
Projects/*/README.md       -- Active project contexts
Daily/                     -- Daily journals and session logs
Goals/                     -- Vision, yearly, monthly goals
Meetings/                  -- Meeting transcripts and insights
Archive/                   -- Completed/old entries
TaskNotes/Tasks/           -- Task files (managed by TaskNotes plugin)
```

---

## Resume Session

Reconstruct full context so the user picks up where they left off.

### Steps

1. **Load core memory** -- Read `Reference/about-me.md`, glob `Projects/*/README.md`, read `Thinking/learnings.md`
2. **Load recent daily notes** -- Default: last 3 from `Daily/` (sorted by filename date). With a number arg: last N notes. With a keyword arg: last 3 + search all daily notes for keyword. Read Quick Reference sections first (low token cost); dig deeper only if needed.
3. **Check active tasks** -- Query TaskNotes API for open/in-progress tasks. Note overdue items. Skip if API unavailable.
   ```bash
   curl -s "http://127.0.0.1:8080/api/tasks?status=open"
   curl -s "http://127.0.0.1:8080/api/tasks?status=in-progress"
   ```
4. **Check goals** -- If `Goals/` has content, scan for active goals and approaching milestones.
5. **Present briefing** -- Concise standup format:
   ```
   Welcome back, [name].

   **Last session** (date): [Brief summary]
   **In Progress**: [Active tasks]
   **Pending**: [Items left over]
   **Upcoming**: [Deadlines, milestones]

   What would you like to focus on today?
   ```
6. **Update daily note** -- Create/append to `Daily/YYYY-MM-DD.md` with a "Current Session" section noting the resume.

### Guidelines
- Keep the briefing short -- like a quick standup, not a data dump
- Prioritize actionable items: overdue tasks, deadlines this week, unfinished work
- If memory files are empty (new vault): "This is your first session. What would you like to work on?"
- Use the user's name from `Reference/about-me.md` if available

---

## Compress / Save Session

Save everything valuable from the current session so future sessions can pick up seamlessly.

### Steps

1. **Ask what to preserve** -- Present options: key learnings, decisions, solutions/fixes, files modified, pending tasks, errors/workarounds, or "all of the above" (recommended). If the user says "all" or wants speed, save everything.
2. **Create session log** -- Append to `Daily/YYYY-MM-DD.md`:
   ```markdown
   ## Session Log: HH:MM -- [Topic Summary]

   ### Quick Reference
   **Topics:** [comma-separated]
   **Projects:** [related projects]
   **Outcome:** [what was accomplished]
   **Duration:** [approximate]

   ### Decisions Made
   - [Decision -- reasoning]

   ### Key Learnings
   - [Learning]

   ### Solutions & Fixes
   - [Problem -> Solution]

   ### Files Modified
   - [file path -- what changed]

   ### Pending Tasks
   - [ ] [Task]

   ### Raw Session Summary
   [Condensed summary -- enough context to reconstruct what happened]
   ```
   Only include YAML frontmatter if creating a new file. Keep Quick Reference to 5-6 lines max (it's designed for fast AI scanning on resume).
3. **Update memory files**:
   - Learnings -> append to `Thinking/learnings.md`
   - User preferences -> update `Reference/about-me.md`
   - Project updates -> update `Projects/{name}/README.md`
   - Pending tasks -> create via TaskNotes API
4. **Auto-archive** -- If `Thinking/learnings.md` exceeds 150 lines, archive older entries to `Archive/learnings-archive-YYYY-MM.md`. Always keep the 20 most recent entries. Never archive active projects or core preferences.
5. **Confirm** -- Tell the user what was saved and where. "You're safe to close. I'll remember everything next time."

### Guidelines
- If the session was short/trivial, create a minimal log (Quick Reference only)
- Be thorough with the Raw Session Summary -- future sessions depend on it

---

## Preserve Learnings

Save durable knowledge that persists indefinitely (unlike compress, which saves session context).

### Steps

1. **Identify what to preserve** -- Ask "What should I remember permanently?" or proceed if the user already stated it.
2. **Write to the right file**:
   | Type | File |
   |------|------|
   | User preferences, style, habits | `Reference/about-me.md` |
   | Project info, deadlines | `Projects/{name}/README.md` |
   | General insights, patterns | `Thinking/learnings.md` |
   | Rules for assistant behavior | Root `CLAUDE.md` (Rules section) |
3. **Auto-archive check** -- Same thresholds: `Thinking/learnings.md` > 150 lines, `Reference/about-me.md` > 100 lines. Archive to `Archive/`.
4. **Confirm** -- Show exactly what was saved and where. Quote the added text.

### Teaching Loop

If the user corrected you during this session, ask: "Should I add a rule to CLAUDE.md so I don't make this mistake again?" If yes, add it under the Rules section.

### Guidelines
- Prefix learnings with date: `- [YYYY-MM-DD] Learning text`
- Check for duplicates before adding
- Be precise about file paths in confirmations

---

## Daily Review

Morning check-in, evening reflection, and weekly review routines.

### Routing

1. Check time: before noon -> suggest morning; after 5pm -> suggest evening
2. If user explicitly requests a type, use that
3. If unclear, ask

Templates live in `references/template-morning.md`, `references/template-evening.md`, `references/template-weekly.md`. Read the appropriate template before generating the review.

### Morning Routine

1. Read most recent daily note from `Daily/`
2. Query TaskNotes for open/in-progress tasks (note overdue items)
3. Check `Projects/` for approaching deadlines
4. Ask: mood/energy (1-10), main focus, blockers
5. Save to `Daily/YYYY-MM-DD Morning.md` with frontmatter (`type: daily-note`, `subtype: morning`, `date`, `mood`, `energy`, `focus`)
6. Suggest 1-3 tasks based on energy and deadlines; offer to create in TaskNotes

### Evening Routine

1. Read today's morning note
2. Compare task progress vs morning intentions
3. Ask: accomplishments, one thing learned, top priority for tomorrow
4. Save to `Daily/YYYY-MM-DD Evening.md` with frontmatter (`subtype: evening`, `productivity: 1-10`)
5. Mark completed tasks as done via API; write new learnings to `Thinking/learnings.md`

### Weekly Review

1. Read all daily notes for the current week
2. Scan `Projects/` for movement
3. Query TaskNotes for done tasks -- celebrate wins
4. Check `Goals/` -- flag goals with no active project
5. Ask: biggest win, what to do differently, focus for next week
6. Save to `Daily/YYYY-MM-DD Weekly Review.md` with frontmatter (`subtype: weekly-review`, `week_number`)
7. Plan top 3 priorities for next week; offer to create tasks
8. Archive completed items if appropriate

### Guidelines
- Be conversational, not robotic -- this is a personal check-in
- If TaskNotes API is unavailable, continue without task data
- After every review: update tasks, update daily note, add learnings to `Thinking/learnings.md`

---

## Task Management

TaskNotes runs as an Obsidian plugin with an HTTP API on `localhost:8080`. Tasks are stored as markdown files in `TaskNotes/Tasks/`.

### Check API Availability

```bash
curl -s --max-time 2 "http://127.0.0.1:8080/api/tasks" > /dev/null 2>&1 && echo "API running" || echo "API not available -- is Obsidian open?"
```

If unavailable: "TaskNotes API isn't responding. Make sure Obsidian is open with the TaskNotes plugin enabled." Do NOT fall back to file-based task creation.

### API Reference

Base URL: `http://127.0.0.1:8080/api`

| Operation | Method | Endpoint | Body |
|-----------|--------|----------|------|
| List all | GET | `/tasks` | -- |
| List by status | GET | `/tasks?status=open` | -- |
| Create | POST | `/tasks` | `{"title", "status", "priority", "due", "scheduled", "projects", "contexts", "tags"}` |
| Update | PUT | `/tasks/Tasks/task-name.md` | `{"status": "in-progress"}` |
| Complete | PUT | `/tasks/Tasks/task-name.md` | `{"status": "done"}` |
| Delete | DELETE | `/tasks/Tasks/task-name.md` | -- |
| Options | GET | `/options` | -- |

### Task Properties

- **Statuses**: `open` (default), `in-progress`, `done`
- **Priorities**: `none`, `low`, `normal` (default), `high`
- **Optional fields**: `due` (YYYY-MM-DD), `scheduled` (YYYY-MM-DD), `projects` (array), `contexts` (array), `tags` (array), `timeEstimate` (minutes), `blockedBy` (array of task paths)

### Guidelines
- Always check API availability before operations
- Minimum fields for creation: `title` and `status`
- Add `due` dates when user mentions a deadline
- Add `projects` when clearly related to a known project
- Present task lists as clean markdown tables
- For bulk operations, confirm with user before executing

---

## Output Styles

Output styles define how the assistant communicates. Each style is a markdown file in `.claude/output-styles/`.

### Available Styles

| Style | File | Use When |
|-------|------|----------|
| Conversation | `conversation.md` | Default -- chat, brainstorming, Q&A |
| YouTube Script | `youtube-script.md` | Video scripts |
| Blog Post | `blog-post.md` | Long-form articles |
| Quick Reply | `quick-reply.md` | DMs, short messages |
| Email | `email.md` | Professional emails |
| Meeting Summary | `meeting-summary.md` | Meeting transcripts |

### Switching

- **Default**: Always use `conversation.md` unless told otherwise
- **Explicit**: "write a YouTube script" -> load `youtube-script.md`
- **Context clues**: Working on meeting transcript -> auto-switch to `meeting-summary.md`
- **"Go back to normal"** -> revert to `conversation.md`
- Always read the full style file before producing styled output

### Creating Custom Styles

1. Ask about content type, tone, format, and rules
2. Create at `.claude/output-styles/[style-name].md` with sections: Identity, Tone, Format, Rules, Examples
3. Test with a sample, iterate until the user is happy

### Personalization

User voice from `Reference/about-me.md` is applied ON TOP of the active style. Style files define structure; preferences define personality.

### Guidelines
- Always read the style file before producing styled output -- don't rely on memory
- If a style file doesn't exist, tell the user and offer to create it
- When listing styles, check which files actually exist in `.claude/output-styles/`

---

## General Guidelines

- **Memory protocol**: Before responding, load `Reference/about-me.md`, `Projects/*/README.md`, and `Thinking/learnings.md`. After responding, update relevant vault files with new learnings or status changes.
- **Teaching loop**: When corrected, offer to save the correction as a permanent rule in `CLAUDE.md`.
- **File paths**: All paths are relative to the Obsidian vault root (the working directory).
- **Daily notes**: `Daily/YYYY-MM-DD.md` is the most-read memory file -- always keep it current.
- **Auto-archive thresholds**: `Thinking/learnings.md` > 150 lines, `Reference/about-me.md` > 100 lines. Archive to `Archive/[filename]-archive-YYYY-MM.md`. Never archive active projects, core preferences, or the 20 most recent learnings.
- **TaskNotes API**: Always on `http://127.0.0.1:8080`. If unavailable, note it and continue without task data.
