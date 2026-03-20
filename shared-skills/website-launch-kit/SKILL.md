---
name: website-launch-kit
description: |
  Clone inspiration sites and customize them for your business.

  USE THIS SKILL WHEN:
  - User says "create landing page", "build website", "landing page"
  - User wants a page for their agency, SaaS, service, or product
  - User needs a conversion-focused single-page site
---

# Website Launch Kit

You are a landing page expert. Your job is to clone an inspiration website, then customize it section-by-section with the user's real content.

**Core philosophy: Clone first, customize later.** The user sees their inspiration site reproduced and deployed before any deep questioning.

---

## RULES

1. **ONE question per message** — use `AskUserQuestion` for every question, never plain text
2. **Read the reference file BEFORE starting each phase** — each phase has specific instructions
3. **Clone the inspiration site EXACTLY before any customization**
4. **Use `agent-browser` for extraction** — take screenshots, extract computed styles, get actual CSS values. Never guess design values from text descriptions.
5. **Build & compare section-by-section** — build one section → screenshot → compare to inspiration screenshot → fix → next. Never build all sections then compare.
6. **In Phase 3, present ONE consolidated discovery form** — list all sections and what info you need in a single `AskUserQuestion`, never ask one question per section
7. **Generate real images with Nano Banana MCP** — never use placeholder images. Use `generate_image` tool to create on-brand visuals matching the inspiration site's style. If MCP unavailable, use CSS-only visuals.
8. **Deploy to Vercel + open Claude Desktop preview** — always give BOTH the Vercel URL (shareable) and the local preview panel. The preview panel supports element selection for precise iteration.

---

## WORKFLOW

```
PHASE 1: INTAKE          → 10 questions: who, what, for whom, CTA, inspiration URL
    ▼
PHASE 2: CLONE & DEPLOY  → Reproduce inspiration site exactly, deploy to Vercel
    ▼
PHASE 3: DEEP DISCOVERY  → ONE consolidated form covering all sections (not per-section questions)
    ▼
PHASE 4: CUSTOMIZE & SHIP → Rewrite sections with real copy, deploy final version
```

---

## PHASE 1: INTAKE

**Goal:** Understand the business basics and get the inspiration URL.

**Reference:** Read `references/01-intake.md` for the 10 questions.

### Starting Message

```
I'll help you create a landing page that actually converts.

Here's how it works:
1. I'll ask 10 quick questions about your business
2. You'll share an inspiration site you love
3. I'll clone it and deploy a preview for you
4. Then we'll customize every section with YOUR content

Let's start.
```

### Flow

1. Ask each of the 10 questions from `01-intake.md`, one at a time via `AskUserQuestion`
2. After Q10, show the intake summary from the reference file
3. Get confirmation
4. Proceed to Phase 2

---

## PHASE 2: CLONE & DEPLOY

**Goal:** Reproduce the inspiration site exactly, deploy to Vercel, get user confirmation.

**Reference:** Read `references/02-clone.md` for the full clone workflow.
**Quality:** Read `references/05-quality-rules.md` for design guardrails.

### Steps

1. **Check `agent-browser` is installed** — install if missing (`npm i -g agent-browser && agent-browser install`)
2. **Deep extraction with `agent-browser`** — open URL, full-page screenshot, per-section screenshots, extract computed styles (colors, fonts, spacing, layout), extract HTML structure, capture mobile view
3. **Catalog every image** on the inspiration site (style, dimensions, visual role)
4. **Set up Next.js + shadcn/ui** project with `.claude/launch.json` for preview panel
5. **Map extracted values** to CSS variables and Tailwind config — use ACTUAL px values from extraction
6. **Build section-by-section with visual compare loop:**
   - For each section: identify layout pattern → build with extracted values → screenshot → compare to inspiration screenshot → fix discrepancies → next section
7. **Generate images** with Nano Banana MCP (`generate_image`) matching the inspiration's visual style
8. Keep the inspiration's copy temporarily (replaced in Phase 4)
9. Apply user's brand colors/logo if provided in Q10
10. **Full-page screenshot comparison** before showing user
11. Deploy to Vercel → give the shareable preview URL
12. Open in Claude Desktop preview panel (element selection enabled for precise feedback)
13. Ask: "Does this match the inspiration site?" — user can click elements directly
14. Iterate on clone fidelity (use `agent-browser` screenshots to verify fixes)

**Important:** Do NOT use the component library during cloning. Build from layout blueprints + extracted values to match the inspiration exactly.

---

## PHASE 3: DEEP DISCOVERY

**Goal:** Gather enough business context to rewrite every section — in ONE consolidated message, not individual questions.

**Reference:** Read `references/03-discovery.md` for the consolidated discovery form.

### Steps

1. Look at each section of the cloned site
2. Generate a **single consolidated discovery form** listing every section and what info is needed
3. Questions must reference the user's own words from Phase 1 — not generic templates
4. Present the entire form in **one `AskUserQuestion`** — the user answers everything at once
5. After their response, show a content summary and get confirmation

**Key rule:** Do NOT ask one question per section. Present ALL section questions together so the user can answer in a single response. This keeps the total interaction to ~12 messages instead of 22+.

---

## PHASE 4: CUSTOMIZE & SHIP

**Goal:** Rewrite every section with real copy, get approval, ship.

**Reference:** Read `references/04-customize.md` for copy formulas and the rewriting process.
**Quality:** Read `references/05-quality-rules.md` for design guardrails.

### Steps

1. For each section on the cloned site:
   a. Write 3 headline options using copy formulas (PAS, FAB, Transformation)
   b. Write body copy using the user's own words from Phase 3
   c. Present options via `AskUserQuestion`
   d. Apply approved copy to the live site (hot-reload)
   e. Get confirmation the section looks good
2. If the user wants to ADD new sections not on the inspiration:
   - Use `components/section-registry.json` as a starting point
   - Adapt to match the cloned site's visual language
3. After all sections are customized:
   - Full-page review
   - Final design tweaks
   - Re-deploy to Vercel with `npx vercel --prod`
   - Post-deploy verification
   - Handover with next steps

---

## REFERENCE FILES

| File | Phase | Purpose |
|------|-------|---------|
| `01-intake.md` | Phase 1 | 10 prefixed intake questions |
| `02-clone.md` | Phase 2 | Clone workflow: analysis, extraction, build, deploy |
| `03-discovery.md` | Phase 3 | Consolidated discovery form (one message, all sections) |
| `04-customize.md` | Phase 4 | Copy formulas, section rewriting, deployment |
| `05-quality-rules.md` | Phase 2+4 | Design guardrails for build quality |
| `components/section-registry.json` | Phase 4 | Used when adding NEW sections only |

## UI/UX PRO MAX (Design Intelligence)

Optional data-driven design system generation. Located in `scripts/` and `data/`.

```bash
# Generate a design system from business type keywords
python3 scripts/search.py "<business_type> <keywords>" --design-system -p "<Name>" --persist
```

Use this in Phase 2 to supplement the inspiration site extraction with data-driven color/typography recommendations. The inspiration site ALWAYS takes priority for "close match" (Q9).
