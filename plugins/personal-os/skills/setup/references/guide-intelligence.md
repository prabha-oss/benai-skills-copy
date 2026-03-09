---
type: guide
folder: Intelligence
---

# Intelligence

What you know — synthesized knowledge, meeting history, competitive intel, and decision records.

## What Goes Here

| Subfolder | Contents |
|-----------|----------|
| `meetings/` | Meeting transcripts and summaries (team-standups, client-calls, one-on-ones, general) |
| `competitors/` | Competitor profiles, analysis, positioning notes |
| `market/` | Market research, trends, customer insights |
| `decisions/` | Decision records with reasoning (`YYYY-MM-DD-title.md`) |
| `archive/` | Older entries moved here when thresholds are exceeded |

## Top-Level Files

- `learnings.md` — Durable insights and patterns captured over time

## Naming Conventions

- **Meetings**: `YYYY-MM-DD Meeting Title.md`
- **Decisions**: `YYYY-MM-DD-decision-title.md`
- **Competitors**: `company-name.md`
- **Market**: descriptive title (e.g., `ai-market-landscape.md`)

## Frontmatter

```yaml
---
type: intelligence
subtype: meeting | decision | competitor | market | learning
date: YYYY-MM-DD
tags: [relevant-tags]
---
```

## Tips
- Meetings are auto-filed by `/meetings`
- Write a decision record whenever you make a non-obvious choice — future you will thank present you
- Competitive intel compounds over time — even small observations are worth capturing
- Use [[wikilinks]] to connect intelligence to projects and context files
