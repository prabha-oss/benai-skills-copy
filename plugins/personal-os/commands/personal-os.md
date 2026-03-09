---
description: See all Personal Assistant OS skills and get started
---

# Personal Assistant OS

You have the following Personal Assistant OS skills available. These skills turn any folder into a personal AI assistant with persistent memory, task management, meeting intelligence, daily routines, and multiple output styles. Present them to the user in a clean table and ask what they'd like to work on:

| Skill | Command | What it does |
|-------|---------|-------------|
| Setup | `/personal-os-setup` | Bootstrap vault structure + personalized onboarding interview |
| Resume | `/personal-os-resume` | Load memory, session logs, and tasks — start a session |
| Compress | `/personal-os-compress` | Save session context before ending |
| Preserve | `/personal-os-preserve` | Save permanent learnings to memory |
| Daily Review | `/personal-os-daily-review` | Morning check-in, evening reflection, or weekly review |
| Meetings | `/personal-os-meetings` | Process meeting transcripts, extract action items |
| TaskNotes | `/personal-os-tasknotes` | Manage tasks via TaskNotes HTTP API |
| Fireflies | `/personal-os-fireflies` | Sync transcripts from Fireflies.ai |
| Output Styles | `/personal-os-output-styles` | List, switch, or create output styles |

**Getting started:** If the vault hasn't been set up yet (no CLAUDE.md in the root), start with `/personal-os-setup` to bootstrap the folder structure and run the onboarding interview.

**Typical workflow:** Setup → Resume (start session) → work with tasks, meetings, reviews → Compress (end session)

Ask the user which skill they want to use, then invoke that skill's slash command.
