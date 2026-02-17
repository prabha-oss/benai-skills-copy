---
description: Run the full outbound sales pipeline on a lead list
argument-hint: [lead-list-file]
allowed-tools: Read, Write, Edit, Bash, Grep, Glob, Task, WebSearch, WebFetch, TodoWrite, AskUserQuestion
---

Run the complete outbound sales pipeline on the provided lead list. This is a four-phase workflow that takes a raw lead list and produces a fully enriched CSV with qualified leads, deep intelligence, and hyper-personalized email icebreakers.

## Phase 0: Gather Context

Before doing anything, collect two critical inputs from the user using AskUserQuestion:

1. **ICP Definition**: Ask the user to describe their Ideal Customer Profile. What makes a lead qualified? What criteria matter (services, headcount, geography, niche, job title, revenue, etc.)? What are the AND vs OR conditions?

2. **Product/Service Context**: Ask what they're selling and why these leads would care. Understand the product deeply so research and personalization can focus on relevant signals.

Do NOT ask about LinkedIn scraping paths. Default to the native ~~web scraper (Apify) connector. Only fall back to ~~automation platform + ~~web scraper if the native connector is not working.

Do NOT proceed until both ICP and product context are confirmed.

## Phase 1: Lead Qualification

Invoke the `lead-qualification` skill. Follow its full process:

1. Load and inspect the lead list file
2. Map ICP criteria to available columns — but remember that **the company website must be checked** to verify CSV data is accurate
3. Tell the user the sub-agent plan (number of agents, leads per agent, estimated time)
4. Spawn ALL `lead-qualifier` sub-agents in a single message for maximum parallelism (10 leads per agent)
5. Collect results, add `Qualified` and `Qualification Reason` columns to the CSV
6. Report: total leads, qualified count, percentage, time taken

**Critical: Every sub-agent must WebFetch the company website to verify the lead.** Don't use WebSearch or visit multiple sources — just the CSV data + the company's own website. This keeps qualification fast and token-efficient.

Save the updated CSV. The qualified leads are the input for Phase 2.

**Transition**: Extract all qualified leads into a working JSON for the next phases.

## Phase 2: Lead Intelligence

Invoke the `lead-intelligence` skill. Follow its full process:

**Critical: Layer 1 (web research) and Layer 2 (LinkedIn scraping) MUST launch in parallel, not sequentially.**

1. Prepare LinkedIn URLs from qualified leads
2. Spawn ALL sub-agents in a single message:
   - N `lead-researcher` sub-agents for Layer 1 web research (5 leads each)
   - 1 `linkedin-scraper` sub-agent for Layer 2 (handles BOTH ~~web scraper actors: profiles AND posts)
3. The `linkedin-scraper` sub-agent uses the native ~~web scraper connector directly (not ~~automation platform). It sends ALL URLs in a single API call per actor. Handle MCP timeouts gracefully (30-second timeout is expected; poll for completion).
4. After all complete, **persist all fetched data to disk immediately** (JSON files), then run a **Python merge script** to combine results into the CSV:
   - Add `General Lead Intelligence` column
   - Add `LinkedIn Lead Research` column
5. The merge MUST happen via a Python script, not inline in the conversation. This prevents data loss during context compaction.
6. Report: leads enriched, LinkedIn data found, posts scraped, time taken

Save the updated CSV. The enriched leads are the input for Phase 3.

## Phase 3: Email Personalization

Invoke the `email-personalization` skill. Follow its full process:

1. Pick the first 2 leads and write 2-3 icebreaker options for each
2. Present to the user for approval and tone calibration
3. Incorporate ALL feedback before scaling — this is critical. User feedback from test icebreakers often introduces new rules that must be applied to all remaining leads
4. Spawn ALL `icebreaker-writer` sub-agents in a single message (5 leads each) with:
   - Full lead data (all columns including intelligence)
   - All writing rules from the skill PLUS any user-added rules from the feedback session
   - The approved examples plus user-provided reference examples
   - Product/service context
5. Compile all icebreakers and run the programmatic quality check for rule violations
6. Fix any violations
7. Add `Email Personalization` column to the CSV
8. Report: total icebreakers written, leads skipped (with reasons), violations found and fixed, time taken

Save the final CSV.

## Phase 4: Final Report

After all three phases complete, present a summary:

```
Pipeline Complete.
- Total leads processed: [N]
- Qualified: [N] ([%])
- Enriched with web intelligence: [N]
- Enriched with LinkedIn data: [N]
- Icebreakers written: [N]
- Leads skipped during personalization: [N] (person-company mismatches or thin data)
- Total time: [duration]
- Output: [link to final CSV]
```

## Important Rules

- Use TodoWrite throughout to track progress across all phases
- Time each phase separately and report durations
- Never drop columns from the original CSV; only add new ones
- Always use sub-agents for batch processing; the main thread is for orchestration only
- **Spawn ALL sub-agents in a single message for maximum parallelism.** Do not batch sequentially (spawn 5, wait, spawn 5 more). One message, all sub-agents. If that's 100 sub-agents, so be it.
- If any phase fails partway, save progress and report what succeeded vs what needs retry
- The CSV is the single source of truth; each phase adds columns to the same file
- **Never trust CSV data alone.** Always verify via web research during qualification.
- **Default to native ~~web scraper connector** for LinkedIn scraping. Only fall back to ~~automation platform if the native connector fails.
- **Persist all large datasets to disk** immediately after fetching. Use Python scripts for merges, not inline conversation processing.
