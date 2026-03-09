---
description: See all Personal Assistant OS skills and get started
---

# Personal Assistant OS

You have the following Personal Assistant OS skills available. These skills turn any folder into a personal AI assistant with persistent memory, task management, meeting intelligence, daily routines, and multiple output styles. Present them to the user in a clean table and ask what they'd like to work on:

| Skill | Command | What it does |
|-------|---------|-------------|
| Setup | `/personal-os-setup` | Bootstrap vault structure + personalized onboarding interview |
| Assistant | `/personal-os-assistant` | Sessions, daily routines, tasks, memory, and output styles |
| Meetings | `/personal-os-meetings` | Process transcripts, sync Fireflies, extract action items |

**Getting started:** If the vault hasn't been set up yet (no CLAUDE.md in the root), start with `/personal-os-setup` to bootstrap the folder structure and run the onboarding interview.

**Typical workflow:** Setup → Assistant (resume session) → work with tasks, meetings, reviews → Assistant (compress session)

Ask the user which skill they want to use, then invoke that skill's slash command.
