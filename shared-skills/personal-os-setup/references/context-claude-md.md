# Context System

This is the brain of the personal assistant. It manages three subsystems:

## 1. Memory System

Location: `context/memory/`
Documentation: `context/memory/CLAUDE.md`

The memory system stores everything you learn about the user and their work. It has these core files:

| File | Purpose |
|------|---------|
| `learnings.md` | Short, durable insights captured during usage |
| `user_preferences.md` | User preferences, communication style, settings |
| `user_projects.md` | Information about the user's active projects |
| `work_status.md` | Running log of what you accomplished recently |

### Memory Protocol

- **Before responding**: Read relevant memory files to understand context
- **After responding**: Update memory files with any new learnings
- **Keep concise**: Summarize, don't dump raw conversation
- **Create topic files**: For detailed subjects, create new `.md` files (e.g., `youtube-strategy.md`)

## 2. Project System

Location: `context/projects/`
Documentation: `context/projects/CLAUDE.md`

Each project the user works on can have its own context file with deep details. Only load project context when the user is working on that specific project.

## 3. Output Style System

Location: `output-styles/`
Documentation: `output-styles/CLAUDE.md`

Defines how you communicate. Different styles for different contexts (YouTube scripts, emails, conversation, etc.). Load the relevant style file when the user requests a specific format.

## 4. Session Log System

Location: `.claude/context/session-logs/`

Session logs are structured summaries of past work sessions, created by `/personal-os-compress`. Each log has:
- **Quick Reference** (5-6 lines) — Designed for fast AI scanning during `/personal-os-resume`
- **Full details** — Decisions, learnings, files modified, pending tasks
- **Raw summary** — Condensed conversation archive

When loading context via `/personal-os-resume`, read Quick Reference sections first (low token cost). Only read full logs if more detail is needed.

### Auto-Archive

When memory files exceed 150 lines, archive older content to `.claude/context/memory/archive/`. Protected content (active projects, core preferences, recent 20 learnings) is never archived.

## Progressive Disclosure

You do NOT need to read everything at once. This system is designed for efficiency:

1. **Always loaded**: Root `CLAUDE.md` (this routing information)
2. **Loaded per prompt**: `context/memory/work_status.md` (via hooks)
3. **Loaded on demand**: Everything else — only when relevant to the current task

Use `grep` to scan frontmatter across many files. Use `Glob` to find specific files. Only read full files when you need their content.
