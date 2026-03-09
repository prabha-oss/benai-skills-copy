---
name: personal-os-meetings
description: Process meeting transcripts and sync from Fireflies.ai — extract decisions, action items, create summaries, and file in the right folder. Use when user pastes a transcript, mentions meetings, wants to sync Fireflies, or runs /personal-os-meetings.
---

# Meeting Intelligence

USE WHEN the user:
- Pastes a meeting transcript or drops a transcript file
- Asks to summarize a meeting or extract action items
- Asks about past meetings or meeting patterns
- Mentions Fireflies, asks to sync or pull transcripts
- Shares a URL to a recorded meeting or transcript
- Runs `/personal-os-meetings`

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here

## Processing a Transcript

### Step 1: Identify Meeting Type

Ask or infer from context:

| Meeting Type | Save to | Focus |
|---|---|---|
| Team standup | `Meetings/team-standups/` | What each person did, doing today, blockers. Keep brief. |
| Client call | `Meetings/client-calls/` | Client requests, decisions, next steps. Check folder for history. |
| One-on-one | `Meetings/one-on-ones/` | Development, feedback, goals. More personal tone. |
| General | `Meetings/general/` | Full meeting summary structure. |
| Custom type | `Meetings/[custom-folder]/` | As appropriate. |

### Step 2: Load Output Style

Read `.claude/output-styles/meeting-summary.md` and follow its format exactly. If the file doesn't exist, use the template at `references/template-meeting-note.md`. Read the template before creating any meeting note.

### Step 3: Extract from Transcript

1. **Key decisions** -- What was agreed upon?
2. **Action items** -- Who is doing what, by when?
3. **Discussion summary** -- Brief recap of each topic
4. **Open questions** -- What was left unresolved?
5. **Follow-up** -- Next meeting, items to prepare

### Step 4: Create the Meeting Note

Save as `Meetings/[type]/YYYY-MM-DD Meeting Title.md` with frontmatter:

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

Body structure (uses Obsidian callouts for visual structure):

```markdown
# Meeting: [Title] -- YYYY-MM-DD

## Participants
- [[Person A]]
- [[Person B]]

## Summary
[2-3 sentence overview]

> [!important] Key Decisions
> - [Decision 1]
> - [Decision 2]

> [!todo] Action Items
> - [ ] [[Person A]] — [Task] (by [date])
> - [ ] [[Person B]] — [Task] (by [date])

## Discussion Notes
### [Topic 1]
[Summary of discussion]

> [!question] Open Questions
> - [Unresolved item 1]

> [!info] Follow-up
> - Next meeting: [date/time if mentioned]
> - Prepare: [items to prepare]
```

Use `[[wikilinks]]` for participants and project references — this creates automatic backlinks in Obsidian.

### Step 5: Create Tasks from Action Items

For each action item extracted:
1. Ask the user if they want to create tasks in TaskNotes
2. If yes, use the TaskNotes API:
   ```bash
   curl -s -X POST "http://127.0.0.1:8080/api/tasks" \
     -H "Content-Type: application/json" \
     -d '{"title": "Action item", "status": "open", "due": "YYYY-MM-DD", "tags": ["meeting"]}'
   ```
3. If the API is unavailable, list action items and suggest creating them later.

### Step 6: Link to Projects

If the meeting relates to a known project (check `Projects/*/README.md`):
- Add `project: [Project Name]` to frontmatter
- Add a [[wiki link]] to the project in the meeting note

## Fireflies Sync

### Approach 1: MCP Server (Business Plan)

Check `.claude/settings.json` for a `fireflies` entry under `mcpServers`. If configured:

1. **List recent transcripts** using `fireflies_list_transcripts`
2. **For each unsynced transcript:**
   - Check if a file already exists in `Meetings/` with the same date and title
   - Fetch full transcript via `fireflies_get_transcript`
   - Process through Steps 1-6 above
3. **Report:** how many synced, new action items found, offer to create tasks

MCP setup (for reference):
```json
{
  "mcpServers": {
    "fireflies": {
      "command": "npx",
      "args": ["-y", "fireflies-mcp-server"],
      "env": { "FIREFLIES_API_KEY": "your-api-key-here" }
    }
  }
}
```

API key from: https://app.fireflies.ai/integrations/custom/fireflies

Also available: `fireflies_search` for keyword search across transcripts.

### Approach 2: Manual Export (Free Plan)

If no API access:
1. Have user export from app.fireflies.ai (Download > JSON or DOCX)
2. Paste content or drop file into `Meetings/`
3. Process through Steps 1-6 above

Free plan limits: no API, no webhooks, 800 min storage, manual export only (DOCX, PDF, SRT, VTT, JSON -- no native Markdown).

### Alternative: Claude Connector

Users with Claude Pro/Max and Fireflies Business can connect via Claude Settings > Connectors, bypassing MCP setup.

## Web Transcript Extraction

If the user shares a URL to a meeting transcript or recording page:

```bash
defuddle parse <url> --md
```

Defuddle extracts clean markdown from web pages, stripping clutter. If `defuddle` is not installed, fall back to standard web fetch. Process the extracted content through Steps 1-6 above.

## Querying Past Meetings

Prefer Obsidian CLI when available, fall back to grep:

```bash
# Obsidian CLI (preferred — uses Obsidian's search index)
obsidian search query="Person Name" limit=10
obsidian search query="topic keyword" limit=10

# Fallback: grep
grep -rl "Person Name" Meetings/
grep -rl "topic keyword" Meetings/
```

Query by frontmatter: `participants`, `project`, `date`, `subtype`, `source`.

## Guidelines

- Always ask for meeting type if not obvious from transcript
- Extract ALL action items -- don't miss any
- Use `[[wikilinks]]` for participants and projects — creates backlinks automatically
- Use callouts (`[!important]`, `[!todo]`, `[!question]`) for visual structure
- For recurring meetings, check previous notes to track patterns
- Keep summaries concise but complete -- someone absent should understand what happened
- Always check MCP availability before falling back to manual export
- Tag all Fireflies-sourced notes with `source: fireflies` in frontmatter
- When syncing multiple meetings, process one at a time and confirm with user

## Anti-Patterns

- Do NOT use `[markdown](links)` for internal notes — always `[[wikilinks]]`
- Do NOT list participants as plain text if they have notes in the vault — use `[[Person Name]]`
- Do NOT skip frontmatter on meeting notes — it enables Bases queries and filtering
- Do NOT create action items as plain text — use TaskNotes API or Obsidian CLI so they're trackable
