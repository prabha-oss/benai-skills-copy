---
name: setup
description: Bootstrap the Personal OS vault structure and run personalized onboarding. Creates all directories, system files, Obsidian config, memory system, hooks, and output styles, then interviews the user to personalize everything. Use when user says "set up", "bootstrap", "initialize", "onboarding", or runs /setup.
---

# Personal OS Setup -- Bootstrap + Onboarding

USE WHEN the user runs `/setup` or asks to set up their vault, bootstrap the personal assistant, initialize the system, or configure the Personal OS.

This is a two-phase process:
- **Phase A**: Bootstrap -- Create the entire directory structure and system files
- **Phase B**: Onboarding -- Interview the user and personalize everything

## Pre-flight Check

Before starting, check if `./claude.md` or `./CLAUDE.md` already exists in the current working directory.

- **If it exists**: The vault is already set up. Ask the user:
  - "This vault is already set up. Would you like to:"
  - **Re-run the interview** -- Keep existing structure, update memory files based on new answers
  - **Full reset** -- Delete everything and start fresh (confirm twice before proceeding)
  - **Cancel** -- Do nothing
- **If it does NOT exist**: Proceed with full setup (Phase A + Phase B)

---

## Phase A: Bootstrap

Create the entire directory structure and write all system files from references.

### Step A.1: Create Directory Structure

Create all of these directories:

```bash
mkdir -p .claude/hooks
mkdir -p .claude/output-styles
mkdir -p Context
mkdir -p Projects
mkdir -p Intelligence/meetings/team-standups
mkdir -p Intelligence/meetings/client-calls
mkdir -p Intelligence/meetings/one-on-ones
mkdir -p Intelligence/meetings/general
mkdir -p Intelligence/competitors
mkdir -p Intelligence/market
mkdir -p Intelligence/decisions
mkdir -p Intelligence/archive
mkdir -p Daily
mkdir -p Skills
```

### Step A.2: Write System Files from References

Read each reference file and write it to the corresponding local path. The reference files contain the complete content for each system file.

| Reference File | Creates at Local Path |
|---|---|
| `references/claude-md-template.md` | `./claude.md` |
| `references/settings-json-template.md` | `./.claude/settings.json` |
| Glob `**/personal-os/hooks/load-context.sh` | `./.claude/hooks/load-context.sh` |
| Glob `**/personal-os/hooks/memory-reminder.sh` | `./.claude/hooks/memory-reminder.sh` |
| Glob `**/personal-os/hooks/verify-memory-stop.sh` | `./.claude/hooks/verify-memory-stop.sh` |
| `references/output-styles-claude-md.md` | `./.claude/output-styles/CLAUDE.md` |
| `references/style-conversation.md` | `./.claude/output-styles/conversation.md` |
| `references/style-youtube-script.md` | `./.claude/output-styles/youtube-script.md` |
| `references/style-blog-post.md` | `./.claude/output-styles/blog-post.md` |
| `references/style-email.md` | `./.claude/output-styles/email.md` |
| `references/style-quick-reply.md` | `./.claude/output-styles/quick-reply.md` |
| `references/style-meeting-summary.md` | `./.claude/output-styles/meeting-summary.md` |
| `references/guide-projects.md` | `./Projects/_guide.md` |
| `references/guide-daily.md` | `./Daily/_guide.md` |
| `references/guide-intelligence.md` | `./Intelligence/_guide.md` |
| `references/guide-skills.md` | `./Skills/_guide.md` |
| `references/claudeignore-template.md` | `./.claudeignore` |
| `references/gitignore-template.md` | `./.gitignore` |

For each row: read the reference file, then write its content to the local path.

### Step A.3: Initialize Starter Files

Create these files with minimal starter content:

**`Context/me.md`** — Read `references/context-me.md` and write to `./Context/me.md`.

**`Intelligence/learnings.md`**:
```markdown
---
type: intelligence
subtype: learning
tags: [learnings]
---
# Learnings

Insights and patterns captured during usage.

## Entries
```

### Step A.4: Make Hooks Executable

```bash
chmod +x .claude/hooks/*.sh
```

### Step A.5: Confirm Bootstrap

Tell the user:
- "Vault structure created successfully."
- List the 5 main folders: `Context/`, `Projects/`, `Intelligence/`, `Daily/`, `Skills/`
- Recommend opening this folder as a vault in Obsidian
- Recommend installing **TaskNotes** community plugin if they want task management features
- Note that **Bases** (native database views) are built into Obsidian — no plugin needed for queries
- Mention `Skills/` for creating custom skills later
- "Now let's personalize it for you."

Then proceed to Phase B.

---

## Phase B: Onboarding

Two questions. That's it. The user can paste text, upload files, or skip entirely.

### Question 1: Context

Ask:

> **Tell me about yourself (and your business, if you have one).**
> Paste anything — bio, LinkedIn, company about page, team info, whatever you have. You can also upload files. Or skip this.

The user might give you:
- A short sentence ("I'm a marketing manager at Acme")
- A wall of text (company wiki, about page, LinkedIn profile)
- Uploaded files (PDFs, docs, screenshots)
- Nothing ("skip")

**Accept whatever they give.** Don't ask follow-ups. Extract what you can.

### Question 2: Projects

Ask:

> **What are you currently working on?**
> List your active projects, or paste project briefs, docs, whatever. Skip if you'd rather add these later.

Same rules — accept anything from a one-liner to uploaded docs. Don't ask follow-ups.

**If the user says "skip" to both** -- proceed to build with defaults only.

---

## Phase B Build: Personalize the Vault

After the two questions (or skips), build everything you can from what the user gave you. Work silently — don't narrate each step.

### Build Step 1: Create Context Files

From Question 1, extract and distribute into the right files:

**`Context/me.md`** — Always created. Fill with whatever identity info you got:
```markdown
---
type: context
tags: [profile, identity]
---
# About Me

## Identity
- Name: [extracted or "unknown"]
- Role: [extracted or blank]
- Industry: [extracted or blank]

## Communication Style
- [extracted or blank]

## Work Preferences
- [extracted or blank]

## Tools & Integrations
- [extracted or blank]
```

**`Context/business.md`** — Only if user mentioned a company, product, or business:
- Read `references/context-business.md` as template
- Fill with extracted company/product/audience info

**`Context/team.md`** — Only if user mentioned team members:
- Read `references/context-team.md` as template
- Fill with extracted names, roles

**`Context/brand.md`** — Only if user mentioned voice, tone, or brand guidelines:
- Read `references/context-brand.md` as template
- Fill with extracted style info

**`Context/strategy.md`** — Only if user mentioned goals, vision, or priorities:
- Read `references/context-strategy.md` as template
- Fill with extracted goals/vision

### Build Step 2: Create Project Folders

From Question 2, create one folder per project mentioned:

- `Projects/{project-name}/README.md` with:
  ```markdown
  ---
  type: project
  status: active
  created: YYYY-MM-DD
  ---
  # [Project Name]

  [Everything you extracted about this project]
  ```

If the user gave rich project info (briefs, docs), include it all in the README. Don't summarize away details.

### Build Step 3: Create First Daily Note

Create `Daily/YYYY-MM-DD.md` (today's date):
```markdown
---
type: daily-note
date: YYYY-MM-DD
---
# YYYY-MM-DD

## Session
- **Focus**: Initial vault setup and onboarding
- **Completed**: Full vault bootstrap + personalized onboarding
- **Next Steps**: [based on what was discussed]
```

### Build Step 4: Confirm Completion

Tell the user:
- Quick summary of what was created (which context files, how many projects)
- "Open this folder in Obsidian to see your vault"
- Key commands: `/assistant` (sessions, daily reviews, tasks) and `/meetings` (transcripts)
- "You can add more context anytime — just tell me and I'll update the right files."
- Suggest a next action based on what they told you

## Guidelines

- Phase A is fully automated -- no user input needed
- Phase B is exactly 2 questions -- no follow-ups, no drilling deeper
- Accept any format: text, pasted docs, uploaded files, or nothing
- Extract as much as you can from whatever the user provides
- Only create context files that have real content -- don't create empty `team.md` or `brand.md`
- Use the user's actual project names, not generic placeholders
- Don't narrate every file you're creating -- just build it and summarize at the end
