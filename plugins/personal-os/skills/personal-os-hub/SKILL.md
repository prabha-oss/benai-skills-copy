---
name: personal-os-hub
description: Personal OS hub — orchestrates vault management, memory, task tracking, meeting processing, daily routines, and output styles. Routes to the right sub-skill based on user intent.
---

# Personal OS — Hub / Orchestrator

Your personal AI assistant operating system. This skill routes to all sub-skills that manage your second brain vault.

## Pre-flight Check

Before doing anything, check if the vault is set up:

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here — do not proceed
3. If it DOES exist, continue below

## Available Commands

| Command | What it does |
|---------|-------------|
| `/personal-os-setup` | Bootstrap vault structure + personalized onboarding |
| `/personal-os-resume` | Load context and start a session |
| `/personal-os-compress` | Save session before ending |
| `/personal-os-preserve` | Save permanent learnings |
| `/personal-os-daily-review` | Morning, evening, or weekly routine |
| `/personal-os-meetings` | Process meeting transcripts |
| `/personal-os-tasknotes` | Task management via HTTP API |
| `/personal-os-fireflies` | Sync Fireflies.ai transcripts |
| `/personal-os-output-styles` | Manage output styles |

## Behavior

When the user invokes `/personal-os` (this skill):

1. Run the pre-flight check above
2. If the vault is set up, display the command table
3. Ask: "What would you like to do?"
4. Based on the user's response, route to the appropriate sub-skill

## Routing Logic

Match the user's intent to the right command:

| User says... | Route to |
|---|---|
| "set up", "bootstrap", "initialize", "onboarding" | `/personal-os-setup` |
| "resume", "start session", "pick up where I left off" | `/personal-os-resume` |
| "save", "compress", "end session", "wrap up session" | `/personal-os-compress` |
| "remember this", "preserve", "save permanently" | `/personal-os-preserve` |
| "morning", "evening", "daily review", "weekly review" | `/personal-os-daily-review` |
| "meeting", "transcript", "summarize meeting" | `/personal-os-meetings` |
| "task", "to-do", "create task", "check tasks" | `/personal-os-tasknotes` |
| "fireflies", "sync meetings", "pull transcripts" | `/personal-os-fireflies` |
| "output style", "writing style", "switch style" | `/personal-os-output-styles` |

## System Architecture

The Personal OS vault has this structure:

```
CLAUDE.md               -- Root config (your operating instructions)
.claude/
  hooks/                -- Automation hooks
  output-styles/        -- Output style definitions
Reference/
  about-me.md           -- Who the user is (preferences, style, habits)
Thinking/
  learnings.md          -- Key insights and patterns
Inbox/                  -- Quick capture
Projects/               -- Active project folders (each has README.md)
Meetings/               -- Meeting transcripts and insights
Daily/                  -- Daily journals, check-ins, and session logs
Goals/                  -- Vision, yearly, monthly goals
Archive/                -- Completed content and old entries
TaskNotes/Tasks/        -- Task files (managed by TaskNotes plugin)
```

## Memory Protocol

The Personal OS maintains a persistent memory system stored in Obsidian vault folders:

- **Before responding**: Read `Reference/about-me.md`, `Projects/*/README.md`, and `Thinking/learnings.md` to understand context
- **After responding**: Update the relevant vault files with any new learnings or status changes
- **Session management**: Use `/personal-os-compress` to save sessions (appended to `Daily/` notes), `/personal-os-resume` to restore them
- **Teaching loop**: When corrected, offer to save the correction as a permanent rule
