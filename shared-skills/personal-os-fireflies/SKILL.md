---
name: personal-os-fireflies
description: Sync meeting transcripts from Fireflies.ai via MCP server or manual export. Use when user mentions Fireflies, asks to sync meetings, pull transcripts, or runs /personal-os-fireflies.
---

# Fireflies.ai Integration

USE WHEN the user mentions Fireflies, asks to sync meetings, or wants to pull transcripts from Fireflies. Also triggered by `/personal-os-fireflies`.

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here

## Two Approaches

### Approach 1: Manual Export (Free Plan)

If the user doesn't have API access:

1. Tell them to export the transcript from Fireflies web dashboard:
   - Log into app.fireflies.ai
   - Open the meeting transcript
   - Click Download > choose JSON or DOCX format
2. Have them paste the content or drop the file into `Meetings/`
3. Process using the `/personal-os-meetings` skill (same 6-step workflow)

### Approach 2: MCP Server (Business Plan -- $19/mo)

If the Fireflies MCP server is configured:

#### Check if Available

The MCP server should be configured in `.claude/settings.json` under the `mcpServers` key. Check for a `fireflies` entry. If not configured, fall back to Approach 1.

#### Available MCP Tools

- `fireflies_list_transcripts` -- List all transcripts
- `fireflies_get_transcript` -- Get full transcript by ID
- `fireflies_search` -- Search across all transcripts by keyword

#### Sync Workflow

1. **List recent transcripts:**
   Use `fireflies_list_transcripts` to get recent meetings

2. **For each unsynced transcript:**
   - Check if a file already exists in `Meetings/` with the same date and title
   - If not, fetch the full transcript using `fireflies_get_transcript`
   - Process using the `/personal-os-meetings` skill
   - Save to the appropriate `Meetings/` subfolder

3. **After sync, report:**
   - How many meetings were synced
   - Any new action items found
   - Offer to create tasks in TaskNotes via the API:
     ```bash
     curl -s -X POST "http://127.0.0.1:8080/api/tasks" \
       -H "Content-Type: application/json" \
       -d '{"title": "Action item from meeting", "status": "open", "tags": ["meeting", "fireflies"]}'
     ```

#### MCP Configuration (for setup)

To enable Fireflies MCP, add to `.claude/settings.json`:

```json
{
  "mcpServers": {
    "fireflies": {
      "command": "npx",
      "args": ["-y", "fireflies-mcp-server"],
      "env": {
        "FIREFLIES_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

Get your API key from: https://app.fireflies.ai/integrations/custom/fireflies

## Alternative: Fireflies Claude Connector

If the user has Claude Pro/Max and Fireflies Business:
- They can connect Fireflies directly in Claude Settings > Connectors
- This gives Claude direct access to meeting data without MCP setup
- Useful for users who can't run MCP servers locally

## Free Plan Limitations

- No API access
- No webhooks
- Manual export only (DOCX, PDF, SRT, VTT, JSON)
- 800 minutes storage limit
- Markdown is NOT a native export format -- conversion needed

## Guidelines

- Always check MCP availability first before falling back to manual
- When syncing multiple meetings, process them one at a time and confirm with the user
- Tag all Fireflies-sourced meeting notes with `source: fireflies` in frontmatter
- After syncing, always offer to create tasks from action items
- If the user asks about Fireflies pricing or setup, explain both free and paid options
