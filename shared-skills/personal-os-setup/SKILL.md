---
name: personal-os-setup
description: Bootstrap the Personal OS vault structure and run personalized onboarding. Creates all directories, system files, Obsidian config, memory system, hooks, and output styles, then interviews the user to personalize everything. Use when user says "set up", "bootstrap", "initialize", "onboarding", or runs /personal-os-setup.
---

# Personal OS Setup -- Bootstrap + Onboarding

USE WHEN the user runs `/personal-os-setup` or asks to set up their vault, bootstrap the personal assistant, initialize the system, or configure the Personal OS.

This is a two-phase process:
- **Phase A**: Bootstrap -- Create the entire directory structure and system files
- **Phase B**: Onboarding -- Interview the user and personalize everything

## Pre-flight Check

Before starting, check if `./CLAUDE.md` already exists in the current working directory.

- **If CLAUDE.md exists**: The vault is already set up. Ask the user:
  - "This vault is already set up. Would you like to:"
  - **Re-run the interview** -- Keep existing structure, update memory files based on new answers
  - **Full reset** -- Delete everything and start fresh (confirm twice before proceeding)
  - **Cancel** -- Do nothing
- **If CLAUDE.md does NOT exist**: Proceed with full setup (Phase A + Phase B)

---

## Phase A: Bootstrap

Create the entire directory structure and write all system files from references.

### Step A.1: Create Directory Structure

Create all of these directories:

```bash
mkdir -p .claude/hooks
mkdir -p .claude/output-styles
mkdir -p Inbox
mkdir -p Thinking
mkdir -p Projects
mkdir -p Meetings/team-standups
mkdir -p Meetings/client-calls
mkdir -p Meetings/one-on-ones
mkdir -p Meetings/general
mkdir -p Daily
mkdir -p Reference/attachments
mkdir -p Archive
mkdir -p Goals
mkdir -p TaskNotes/Tasks
mkdir -p TaskNotes/Views
```

### Step A.2: Write System Files from References

Read each reference file and write it to the corresponding local path. The reference files contain the complete content for each system file.

| Reference File | Creates at Local Path |
|---|---|
| `references/claude-md-template.md` | `./CLAUDE.md` |
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
| `references/guide-inbox.md` | `./Inbox/_guide.md` |
| `references/guide-daily.md` | `./Daily/_guide.md` |
| `references/guide-goals.md` | `./Goals/_guide.md` |
| `references/guide-meetings.md` | `./Meetings/_guide.md` |
| `references/guide-projects.md` | `./Projects/_guide.md` |
| `references/guide-reference.md` | `./Reference/_guide.md` |
| `references/guide-thinking.md` | `./Thinking/_guide.md` |
| `references/goals-vision.md` | `./Goals/vision.md` |
| `references/goals-yearly.md` | `./Goals/yearly-goals.md` |
| `references/goals-monthly.md` | `./Goals/monthly-goals.md` |
| `references/claudeignore-template.md` | `./.claudeignore` |
| `references/gitignore-template.md` | `./.gitignore` |

For each row: read the reference file, then write its content to the local path.

### Step A.3: Initialize Starter Files

Create these files with minimal starter content:

**`Reference/about-me.md`**:
```markdown
---
type: reference
tags: [profile]
---
# About Me

## Identity
- Name: [to be filled during onboarding]
- Role: [to be filled during onboarding]

## Communication Style
- [to be filled during onboarding]

## Work Preferences
- [to be filled during onboarding]

## Tools & Integrations
- [to be filled during onboarding]
```

**`Thinking/learnings.md`**:
```markdown
---
type: thinking
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
- List the key directories and files created
- Recommend opening this folder as a vault in Obsidian
- Recommend installing **TaskNotes** community plugin if they want task management features
- Note that **Bases** (native database views) are built into Obsidian — no plugin needed for queries
- "Now let's personalize it for you."

Then proceed to Phase B.

---

## Phase B: Onboarding Interview

You are an intelligent onboarding agent. Your job is to understand the user deeply and build a vault structure that reflects their actual life and work -- not a generic template.

**Rules:**
- Never ask more than 3 questions at a time
- Be conversational, warm, and proactive with recommendations
- Respect "that's enough" or "just build it" -- stop asking and start building immediately
- Create only what's relevant -- don't build empty folders for things they don't need

### Phase B.1: Core Identity

Ask:
- What's your name?
- What do you do for work? (role, industry)
- What are you currently working on? (1-3 main things)

### Phase B.2: Work Style

Ask:
- Do you prefer things concise or detailed?
- How do you like tasks organized? (lists, boards, calendars)
- What tools do you already use? (calendar, notes, communication)
- When do you work? (morning person, night owl, specific hours)

### Phase B.3: What to Track

Based on Phases B.1 and B.2, RECOMMEND what to enable. Don't just list options -- explain why each one fits them:

- **Projects** -- "You mentioned working on X and Y, so I'd set up project folders for those..."
- **Meetings** -- "Do you have regular meetings? I can set up folders for different types..."
  - If yes: What types? (team standups, client calls, 1:1s, etc.)
- **Daily Journaling** -- "This pairs well with your task system -- quick morning intention, evening reflection..."
- **Content Creation** -- "If you create YouTube videos, blog posts, etc., I can set up a content pipeline..."
- **Personal Life** -- "Some people track family, health, hobbies. Only if you want -- totally optional."
- **Client/Contact Management** -- "Do you work with clients or external contacts?"
- **Learning/Reference** -- "Do you take notes from courses, books, conferences?"

### Phase B.4: Go Deeper (Only if the user is engaged)

For each category they said yes to, ask 1-2 follow-up questions:
- **Projects**: "What's the deadline for X? What's the current status?"
- **Meetings**: "How often do standups happen? Who's usually on the client calls?"
- **Content**: "What platforms? YouTube, blog, newsletter? What's your current content schedule?"
- **Goals**: "Do you have a 3-year vision? Yearly goals?"

**If the user says "that's enough" or "just build it"** -- stop interviewing and start building immediately.

---

## Phase B Build: Personalize the Vault

After the interview, execute ALL of the following:

### Build Step 1: Update Identity & Project Files

**`Reference/about-me.md`** — update with onboarding answers:
```markdown
---
type: reference
tags: [profile]
---
# About Me

## Identity
- Name: [name from interview]
- Role: [role from interview]
- Industry: [industry from interview]

## Communication Style
- [concise/detailed/etc. from interview]

## Work Preferences
- Schedule: [work hours / morning or night person]
- Task style: [lists, boards, calendars]

## Tools & Integrations
- [list of tools they use]
```

**`Projects/{project-name}/README.md`** — create one per active project:
```markdown
---
type: project
status: active
created: YYYY-MM-DD
---
# [Project Name]

- Description: [what it is]
- Status: [active/planning/etc.]
- Deadline: [if mentioned]
- Key details: [anything relevant]
```

### Build Step 2: Create Meeting Subfolders (if meetings enabled)

For each meeting type the user mentioned, ensure the subfolder exists under `Meetings/`:
- `Meetings/team-standups/`
- `Meetings/client-calls/`
- `Meetings/one-on-ones/`
- Or custom types they specified (create the folder with a kebab-case name)

### Build Step 3: Create Project Folders (if projects mentioned)

For each active project, create:
- `Projects/[project-name]/` folder
- `Projects/[project-name]/README.md` with project overview including frontmatter:
  ```yaml
  ---
  type: project
  status: active
  created: YYYY-MM-DD
  ---
  ```

### Build Step 4: Create Guide Files

The base guide files were created in Phase A. If the user mentioned custom categories, create additional `_guide.md` files that explain:
- What goes in this folder
- How files should be named
- What frontmatter to use

### Build Step 5: Create Initial Tasks via TaskNotes

If the user mentioned tasks or next steps, create them via the TaskNotes API:
```bash
curl -s -X POST "http://127.0.0.1:8080/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{"title": "Task name", "status": "open", "priority": "normal"}'
```

If the TaskNotes API is unavailable, skip this step and note it for the user.

### Build Step 6: Configure Content Pipeline (if content creation enabled)

Create content-specific folders:
- `Projects/youtube/` (or blog, newsletter, etc.)
- Include a pipeline structure within the README: ideas > research > drafts > published

### Build Step 7: Set Up Goals (if goals discussed)

If the user mentioned goals or vision:
- Update `Goals/vision.md` with their vision
- Update `Goals/yearly-goals.md` with any yearly goals mentioned
- Update `Goals/monthly-goals.md` with current month's goals

### Build Step 8: Create First Daily Note

Create `Daily/YYYY-MM-DD.md` (using today's date):
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

### Build Step 9: Confirm Completion

Tell the user:
- Summary of everything that was created (directories, files, projects, tasks)
- "Open this folder in Obsidian to see your vault"
- Remind them about key commands:
  - `/personal-os-assistant` -- Resume sessions, daily reviews, tasks, memory, output styles
  - `/personal-os-meetings` -- Process meeting transcripts, sync Fireflies
- Mention: "Your notes use Obsidian Flavored Markdown — wikilinks, callouts, and embeds all render beautifully in Obsidian."
- "I'll remember everything from this conversation -- my memory updates automatically"
- Suggest a next action based on what they told you

## Guidelines

- The bootstrap (Phase A) should be fully automated -- no user input needed
- The onboarding (Phase B) is conversational -- adapt to the user's energy
- If the user seems overwhelmed, simplify and offer to expand later
- Use the user's name once you know it
- Go deeper only if the user is engaged -- if they say "keep it simple", respect that
- Every folder created should have a `_guide.md`
- Use the user's actual project names, not generic placeholders
- Don't create empty folders for things they don't need
