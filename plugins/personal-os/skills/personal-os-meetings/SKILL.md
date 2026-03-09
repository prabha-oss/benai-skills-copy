---
name: personal-os-meetings
description: Process meeting transcripts — extract action items, create summaries, file in correct meeting type folder. Use when user pastes a transcript, says "summarize meeting", "action items", "meeting notes", or runs /personal-os-meetings.
---

# Meeting Intelligence

USE WHEN the user:
- Pastes a meeting transcript
- Asks to summarize a meeting
- Wants action items from a meeting
- Asks about past meetings or meeting patterns
- Drops a transcript file into `Meetings/`
- Runs `/personal-os-meetings`

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here

## Meeting Note Template

The meeting note template is in `references/template-meeting-note.md`. Read it before creating meeting notes.

## How Meeting Processing Works

### Step 1: Identify Meeting Type

Ask the user or infer from context:

| Meeting Type | Save to |
|---|---|
| Team standup | `Meetings/team-standups/` |
| Client call | `Meetings/client-calls/` |
| One-on-one | `Meetings/one-on-ones/` |
| General | `Meetings/general/` |
| Custom type | `Meetings/[custom-folder]/` |

### Step 2: Load the Meeting Summary Output Style

Read `.claude/output-styles/meeting-summary.md` and follow its format exactly. If the file doesn't exist, use the built-in format below.

### Step 3: Process the Transcript

From the transcript, extract:
1. **Key decisions** -- What was agreed upon?
2. **Action items** -- Who is doing what, by when?
3. **Discussion summary** -- Brief recap of each topic covered
4. **Open questions** -- What was left unresolved?
5. **Follow-up** -- Next meeting, items to prepare

### Step 4: Create the Meeting Note

Save as `Meetings/[type]/YYYY-MM-DD Meeting Title.md` using this frontmatter:

```yaml
---
type: meeting
subtype: team-standup | client-call | one-on-one | general
date: YYYY-MM-DD
time: HH:MM
participants: [Person A, Person B]
duration: X minutes
source: manual | fireflies
status: processed
---
```

Meeting note body structure:

```markdown
# Meeting: [Title] -- YYYY-MM-DD

## Participants
- [List of attendees]

## Summary
[2-3 sentence overview]

## Key Decisions
- [Decision 1]
- [Decision 2]

## Action Items
- [ ] [Person] — [Task] (by [date])
- [ ] [Person] — [Task] (by [date])

## Discussion Notes
### [Topic 1]
[Summary of discussion]

### [Topic 2]
[Summary of discussion]

## Open Questions
- [Unresolved item 1]
- [Unresolved item 2]

## Follow-up
- Next meeting: [date/time if mentioned]
- Prepare: [items to prepare]
```

### Step 5: Create Tasks from Action Items

For each action item extracted:
1. Ask the user if they want to create tasks in TaskNotes
2. If yes, use the TaskNotes API:
   ```bash
   curl -s -X POST "http://127.0.0.1:8080/api/tasks" \
     -H "Content-Type: application/json" \
     -d '{"title": "Action item", "status": "open", "due": "YYYY-MM-DD", "tags": ["meeting"]}'
   ```
3. Include the due date and tag it with the meeting type

If the TaskNotes API is unavailable, list the action items and suggest creating them later.

### Step 6: Link to Projects

If the meeting relates to a known project (check `Projects/*/README.md` files):
- Add `project: [Project Name]` to the frontmatter
- Add a [[wiki link]] to the project in the meeting note
- Update the project file with a reference to this meeting

## Meeting Type Focus Areas

### Team Standup
Focus on: what each person did yesterday, what they're doing today, blockers.
Keep summary very brief -- standups are short.

### Client Call
Focus on: client requests, decisions made, next steps, relationship notes.
Check if client exists in `Meetings/client-calls/` for historical context.

### One-on-One
Focus on: personal development, feedback, goals, action items.
More personal tone -- capture the spirit, not just the facts.

### General
Default format. Full meeting summary structure.

## Querying Past Meetings

When the user asks about past meetings, search the vault:

```bash
# Find meetings with a specific person
grep -rl "Person Name" Meetings/

# Find meetings about a topic
grep -rl "topic keyword" Meetings/

# List recent meetings
ls -lt Meetings/*/
```

You can also query by frontmatter fields:
- `participants` -- who was in the meeting
- `project` -- which project it relates to
- `date` -- when it happened
- `subtype` -- what kind of meeting

## Guidelines

- Always ask for meeting type if it's not obvious from the transcript
- Extract ALL action items -- don't miss any
- Use the user's name for action items assigned to them
- For recurring meetings, check for previous notes to track patterns
- Keep summaries concise but complete -- someone who wasn't in the meeting should understand what happened
