---
name: personal-os-tasknotes
description: HTTP API-based task management using the TaskNotes Obsidian plugin. Create, update, query, and manage tasks via REST API. Use when user mentions tasks, to-dos, priorities, deadlines, or runs /personal-os-tasknotes.
---

# TaskNotes -- Primary Task System

USE WHEN the user:
- Asks to create, update, or manage tasks
- Wants to check what's due, overdue, or in progress
- Mentions tasks, to-dos, priorities, deadlines
- Asks to track time or start a Pomodoro
- Wants a kanban view, calendar view, or agenda of tasks
- Runs `/personal-os-tasknotes`

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here

## How It Works

TaskNotes is the primary task management system. It runs as an Obsidian plugin with an HTTP API on port 8080. Tasks are stored as individual markdown files in `TaskNotes/Tasks/`.

### Prerequisites
- TaskNotes plugin installed and enabled in Obsidian
- HTTP API enabled (Settings > TaskNotes > API > Enable HTTP API)
- Obsidian must be open for the API to be available

### Check if API is Running
```bash
curl -s --max-time 2 "http://127.0.0.1:8080/api/tasks" > /dev/null 2>&1 && echo "TaskNotes API is running" || echo "TaskNotes API not available -- is Obsidian open?"
```

## API Reference

Base URL: `http://127.0.0.1:8080/api`

### List All Tasks
```bash
curl -s "http://127.0.0.1:8080/api/tasks"
```

### List Tasks by Status
```bash
curl -s "http://127.0.0.1:8080/api/tasks?status=open"
curl -s "http://127.0.0.1:8080/api/tasks?status=in-progress"
curl -s "http://127.0.0.1:8080/api/tasks?status=done"
```

### Create a Task
```bash
curl -s -X POST "http://127.0.0.1:8080/api/tasks" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Task name",
    "status": "open",
    "priority": "normal",
    "due": "2026-03-15",
    "scheduled": "2026-03-10",
    "projects": ["Project Name"],
    "contexts": ["work"],
    "tags": ["tag1"]
  }'
```

### Update a Task
```bash
curl -s -X PUT "http://127.0.0.1:8080/api/tasks/Tasks/task-name.md" \
  -H "Content-Type: application/json" \
  -d '{"status": "in-progress"}'
```

### Complete a Task
```bash
curl -s -X PUT "http://127.0.0.1:8080/api/tasks/Tasks/task-name.md" \
  -H "Content-Type: application/json" \
  -d '{"status": "done"}'
```

### Delete a Task
```bash
curl -s -X DELETE "http://127.0.0.1:8080/api/tasks/Tasks/task-name.md"
```

### Get Available Options (statuses, priorities, projects, etc.)
```bash
curl -s "http://127.0.0.1:8080/api/options"
```

## Task Properties

### Statuses
- `open` -- Not started (default)
- `in-progress` -- Currently working on
- `done` -- Completed

### Priorities
- `none` -- No priority set
- `low` -- Low priority
- `normal` -- Default priority
- `high` -- High priority

### Optional Fields
- `due` -- Due date (YYYY-MM-DD)
- `scheduled` -- Scheduled start date (YYYY-MM-DD)
- `projects` -- Array of project names (links to `Projects/` folders)
- `contexts` -- Array of contexts (e.g., "work", "home", "errands")
- `tags` -- Array of tags
- `timeEstimate` -- Estimated minutes
- `blockedBy` -- Array of task paths this task is blocked by

## Built-in Views in Obsidian

TaskNotes provides 6 views users can open directly in Obsidian:

| View | What It Shows |
|------|---------------|
| **Task List** | All tasks with 6 tabs: All, Not Blocked, Today, Overdue, This Week, Unscheduled |
| **Kanban Board** | Visual columns by status (Open > In Progress > Done) |
| **Calendar** | Weekly time grid with tasks on time slots |
| **Mini Calendar** | Month overview with dots for task dates |
| **Agenda** | Flat list of upcoming 7 days |
| **Relationships** | Task dependencies, subtasks, blocking chains |

## Features

- **Urgency scoring** -- Automatic priority ranking based on priority + deadline proximity
- **Time tracking** -- Track time spent on tasks
- **Pomodoro timer** -- Built-in 25/5 minute focus timer
- **Task dependencies** -- Block tasks until prerequisites are done
- **Recurring tasks** -- Set tasks to repeat on a schedule
- **Natural language input** -- Users can type dates naturally in Obsidian

## When API is Unavailable

If the API doesn't respond (Obsidian closed, plugin disabled), tell the user:
"TaskNotes API isn't responding. Please make sure Obsidian is open with the TaskNotes plugin enabled."

Do NOT fall back to file-based task creation -- TaskNotes manages its own file format.

## Guidelines

- Always check if the API is available before attempting operations
- When creating tasks, include at minimum: title and status
- Add `due` dates whenever the user mentions a deadline
- Add `projects` when the task clearly relates to a known project
- When listing tasks, present them as a clean markdown table
- For bulk operations (e.g., "mark all standup tasks as done"), confirm with the user before executing
