---
type: guide
folder: Meetings
---

# Meetings

Meeting transcripts, summaries, and insights. Organized by meeting type.

## Subfolders

| Folder | Type | What Goes Here |
|--------|------|----------------|
| `team-standups/` | Team standup | Daily/weekly team sync notes |
| `client-calls/` | Client call | External client meeting notes |
| `one-on-ones/` | 1:1 meeting | One-on-one meeting notes |
| `general/` | General | Any other meeting type |

## How to Add Meeting Notes

### Option 1: Manual (Free)
1. Copy the transcript from your meeting tool (Fireflies, Otter, Zoom, etc.)
2. Paste it into the chat with Claude
3. Claude will process it, extract action items, and save it in the right subfolder

### Option 2: Fireflies MCP (Requires Business Plan — $19/mo)
1. Configure the Fireflies MCP server (see `.claude/skills/fireflies/SKILL.md`)
2. Tell Claude to "sync my meetings"
3. Claude pulls and processes transcripts automatically

## Naming Convention
`YYYY-MM-DD Meeting Title.md`

Example: `2026-02-23 Q1 Planning Kickoff.md`

## Frontmatter Template
```yaml
---
type: meeting
subtype: team-standup | client-call | one-on-one | general
date: YYYY-MM-DD
participants: [Person A, Person B]
duration: 30
source: manual | fireflies
status: raw | processed
---
```
