---
name: personal-os-preserve
description: Save permanent learnings, preferences, and rules to the memory system. Use when user says "remember this", "preserve", "save permanently", "add this as a rule", or runs /personal-os-preserve.
---

# Preserve — Permanent Learnings

USE WHEN the user runs `/personal-os-preserve` or says "remember this", "preserve", "save permanently", "add this as a rule", "never forget this".

Unlike `/personal-os-compress` (which saves session-specific context), `/personal-os-preserve` saves durable knowledge that should persist indefinitely.

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here

## What Gets Preserved

Things like:
- Project conventions and standards
- Architecture decisions
- Key file paths and workflows
- User preferences that were explicitly stated
- Recurring patterns or rules
- "Always do X" or "Never do Y" instructions
- Tool configurations and setups
- Lessons learned from mistakes

## Workflow

### Step 1: Identify What to Preserve

Ask the user: "What should I remember permanently?"

Or, if the user already stated something (e.g., "remember that I always want..."), proceed directly.

### Step 2: Write to the Right File

| Type of Knowledge | Where to Write |
|-------------------|---------------|
| User preferences, style, habits | `Reference/about-me.md` |
| Project info, deadlines, details | `Projects/{name}/README.md` |
| General insights, patterns | `Thinking/learnings.md` |
| Rules about how the assistant should behave | Root `CLAUDE.md` (under Rules section) |

### Step 3: Auto-Archive Check

After writing, check the file size:

- If **`Thinking/learnings.md`** exceeds 150 lines: Archive older entries to `Archive/learnings-archive-YYYY-MM.md`
- If **`Reference/about-me.md`** exceeds 100 lines: Consider consolidating
- If a **`Projects/*/README.md`** has completed projects: Move them to `Archive/`

Archive location: `Archive/[filename]-archive-YYYY-MM.md`

**Protected content** (never archive):
- Current active projects in `Projects/*/README.md`
- Core preferences in `Reference/about-me.md`
- The most recent 20 learnings in `Thinking/learnings.md`

### Step 4: Confirm

Tell the user exactly what was saved and where. Quote the text that was added so they can verify accuracy.

## Teaching Loop

If the user corrected you during this session, ask:
"Should I also add a rule to CLAUDE.md so I don't make this mistake again?"

If yes, add the correction as a rule under the Rules section of root `CLAUDE.md`.

This is how the system learns from you over time -- every correction becomes a permanent rule.

## Guidelines

- Be precise about where things are saved -- always tell the user the exact file path
- When adding to `Thinking/learnings.md`, prefix each entry with a date: `- [YYYY-MM-DD] Learning text here`
- When adding rules to `CLAUDE.md`, add them at the bottom of the Rules section with a numbered entry
- Don't duplicate -- check if the knowledge already exists before adding
