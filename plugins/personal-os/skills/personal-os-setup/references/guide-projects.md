---
type: guide
folder: Projects
---

# Projects

Active project folders. Each project gets its own subfolder.

## What Goes Here
- A folder per active project
- Each folder has a `README.md` with project overview
- Supporting files: research, notes, drafts, assets

## Folder Structure Per Project
```
Projects/
└── project-name/
    ├── README.md          # Project overview, status, key details
    ├── research/          # Research and reference material
    ├── notes/             # Working notes
    └── drafts/            # Draft content (if applicable)
```

## README.md Template
```yaml
---
type: project
name: Project Name
status: active | planning | on-hold | completed
priority: high | medium | low
deadline: YYYY-MM-DD
---

# Project Name

## Overview
What is this project and why does it matter?

## Current Status
What's happening now?

## Key Resources
- Links, tools, contacts

## Next Steps
What needs to happen next?
```

## Tips
- Move completed projects to `Archive/`
- Link project notes to your TaskNotes tasks
- Reference projects from daily reviews using [[wiki links]]
