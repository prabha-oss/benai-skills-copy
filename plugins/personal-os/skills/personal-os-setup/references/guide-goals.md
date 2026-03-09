---
type: guide
folder: Goals
---

# Goals

Your vision-to-action cascade. This is what connects "where I want to be in 3 years" to "what I'm doing today."

## The Cascade

```
3-Year Vision → Yearly Goals → Quarterly Milestones → Monthly Goals → Weekly Review → Daily Tasks
```

Every layer connects to the next. Projects live in `Projects/` and link to goals here. Daily tasks in TaskNotes link to projects. Nothing floats without purpose.

## Files

| File | Purpose | Update Frequency |
|------|---------|-----------------|
| `vision.md` | 3-year vision across life areas | Quarterly |
| `yearly-goals.md` | This year's measurable objectives | Monthly check |
| `monthly-goals.md` | This month's focus areas | Monthly |

## How Goals Connect to Everything

- **Goals → Projects**: Each goal should have at least one active project in `Projects/`
- **Projects → Tasks**: Each project generates tasks in TaskNotes
- **Tasks → Daily**: `/personal-os-daily-review` pulls tasks from TaskNotes
- **Weekly → Monthly**: `/personal-os-weekly` reviews project progress against monthly goals
- **Monthly → Yearly**: Monthly reviews check quarterly milestones

## Goal Tracking

During weekly reviews, Claude checks:
- Which goals have active projects?
- Which goals have NO active projects? (these are drifting)
- Are quarterly milestones on track?
- What needs to change?

## Frontmatter for Goal Files

```yaml
---
type: goals
timeframe: 3-year | yearly | monthly
last_reviewed: YYYY-MM-DD
---
```
