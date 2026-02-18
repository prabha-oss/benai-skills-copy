---
name: infographic-v2
description: Generate professional infographics using Nano Banana MCP (Gemini AI image generation). Follows a guided flow - analyze content, suggest visualizable concepts, propose visualization approaches, then generate on-brand images. USE THIS SKILL WHEN user says "create infographic v2", "make a visual v2", "infographic-v2". Modular architecture with lazy-loaded reference files for each phase.
---

# Infographic Generator

Create professional infographics in the BenAI brand style for LinkedIn and newsletters. Uses Gemini AI via the Nano Banana MCP server for image generation.

**Connectors:** Nano Banana MCP (Gemini AI image generation)

**Core philosophy:** The quality of the output is determined by the quality of the thinking BEFORE any prompt is written. Spend 70% of the effort understanding what to visualize and 30% on how to visualize it.

**Meta-narrative:** This skill follows three stages: **Understand** (what to say), **Plan** (how to say it), **Execute** (make it real).

---

## When This Skill Loads

**DO NOT load any reference files yet.** Files load lazily, one phase at a time.

1. Execute Phase 0 (silent config check)
2. If API key is NOT configured: skip to Phase 5 (API Key Setup). Do NOT ask about content.
3. If API key IS configured: begin Phase 1.

---

# UNDERSTAND

## Phase 0: Silent Config Check

Run silently. Do NOT ask questions yet.

### 0.1: Ensure Directory Structure

```bash
mkdir -p .infographic/images
mkdir -p .infographic/prompts
```

### 0.2: Check for API Key

```bash
if [ -n "$GEMINI_API_KEY" ]; then
  echo "API key found in environment"
elif [ -f .env ] && grep -q "^GEMINI_API_KEY=.\+" .env; then
  echo "API key found in .env file"
else
  echo "API key not configured"
fi
```

**Decision:**
- Found (env var OR .env): proceed silently to Phase 1
- NOT found: jump IMMEDIATELY to Phase 5 (API Key Setup)

### 0.3: Check for Brand Config

```bash
if [ -f .infographic/brand.md ]; then
  cat .infographic/brand.md
fi
```

If brand config exists, acknowledge briefly: "I found your saved settings. Ready to create your infographic!"

---

## Phase 1: Content Intake

**No reference files loaded.** Just collect the raw material.

Use `AskUserQuestion`:

```
question: "What content should I turn into an infographic?"
header: "Content"
options:
  - label: "Paste text"
    description: "Paste an article, essay, social post, or notes"
  - label: "From a URL"
    description: "Point me to a web page and I will analyze it"
  - label: "From a file"
    description: "Point me to a file in your project"
```

Wait for content. Acknowledge receipt. Do NOT analyze yet.

---

## Phase 2: Content Analysis + Concept Extraction

```
>>> READ references/content-analysis.md NOW
```

This is where the deep work begins. The reference file teaches the 4-layer analysis framework.

### 2.1: Four-Layer Analysis

Apply the framework from `content-analysis.md`. Extract meaning at all 4 layers:

- Layer 1 (Narrative): What happened?
- Layer 2 (Themes): What is it about?
- Layer 3 (Claims): What does it SAY is true about the world?
- Layer 4 (Information): What concrete data, comparisons, or frameworks exist?

Present the analysis explicitly labeled by layer with honest strength ratings (Weak / Moderate / Strong).

### 2.2: Intent

Use `AskUserQuestion`:

```
question: "What should a viewer GET from this visual in 2 seconds?"
header: "Intent"
options:
  - label: "Feel something"
    description: "An emotional hit - recognition, discomfort, inspiration. They stop scrolling because it resonates."
  - label: "Learn something"
    description: "A concrete fact, comparison, or framework. They save it because it's useful."
  - label: "Both"
    description: "An emotional hook with concrete information backing it up."
```

This answer determines the output mode:
- "Feel something" = Editorial Illustration (visualize Layer 3 claims)
- "Learn something" = Information Graphic (visualize Layer 4 data)
- "Both" = Hybrid

### 2.3: Platform

Use `AskUserQuestion`:

```
question: "Where will this be posted?"
header: "Platform"
options:
  - label: "LinkedIn (Recommended)"
    description: "4:5 portrait, optimized for feed engagement"
  - label: "Instagram"
    description: "1:1 square or 4:5 portrait"
  - label: "Twitter/X"
    description: "16:9 landscape for timeline"
  - label: "Presentation"
    description: "16:9 landscape for slides"
```

### 2.4: Output Mode Lock

Based on the intent answer, declare the output mode (Editorial Illustration / Information Graphic / Hybrid). Confirm with the user:

```
question: "Based on your content, I recommend [mode]. Does this feel right?"
header: "Output"
options:
  - label: "Editorial Illustration"
    description: "Art that embodies a truth. Quiet, cinematic, the scene IS the message."
  - label: "Information Graphic"
    description: "Structured data visual. Scannable, useful, saves-worthy."
  - label: "Hybrid"
    description: "Emotional hook + concrete data. Best of both."
```

### 2.5: Concept Extraction (5+ concepts)

Extract at least 5 concepts at the CORRECT layer:
- For Editorial: extract philosophical claims as truth statements
- For Info Graphic: extract information structures as data shapes

Present all 5+ with `AskUserQuestion`. Use the actual claims or data shapes as labels, not topic names.

```
question: "Which of these should we visualize?"
header: "Concept"
options:
  - label: "[First few words of claim/data shape 1]"
    description: "[Why this is a strong visual candidate]"
  - label: "[First few words of claim/data shape 2]"
    description: "[Why this is a strong visual candidate]"
  - label: "[First few words of claim/data shape 3]"
    description: "[Why this is a strong visual candidate]"
  - label: "[First few words of claim/data shape 4]"
    description: "[Why this is a strong visual candidate]"
```

(Present remaining concepts as additional options. Never fewer than 5.)

**Never proceed without user selection.**

---

# PLAN

## Phase 3: Visualization Design

```
>>> READ references/visualization-patterns.md NOW
```

### 3.1: Style Discovery (Editorial/Hybrid only)

If the user chose Information Graphic, SKIP this step. Info Graphics use the BenAI brand system.

For Editorial/Hybrid, use `AskUserQuestion`:

```
question: "What visual world should this live in?"
header: "Style"
options:
  - label: "European editorial / Adult Swim"
    description: "Moebius linework, quiet existential surrealism. Muted warm tones."
  - label: "Graphic novel / comic panel"
    description: "Bold linework, sequential framing. Clear and deliberate."
  - label: "Risograph / analog print"
    description: "Paper grain, muted palette, slight imperfections. Tactile and warm."
  - label: "Minimalist conceptual"
    description: "Single powerful image. New Yorker cover energy."
```

If the user describes a different style entirely, use their description. These are starting points, not constraints.

### 3.2: Visualization Proposals (5 approaches)

Propose 5 ways to visualize the chosen concept:
- For Editorial: 5 CINEMATIC SCENES (not layout types). Each with: the scene, emotional register, focal composition, 2-second hit.
- For Info Graphic: 5 DATA STRUCTURES (not metaphors). Each with: format, data mapping, 1-second takeaway, why this format fits.

Use `AskUserQuestion` with the 5 proposals.

**Never propose fewer than 5.**

### 3.3: Content Mapping

After the user picks an approach, map their SPECIFIC content to the chosen structure. Show exactly:
- What text appears where (exact words)
- How the visual hierarchy works
- What the focal point is

Confirm with `AskUserQuestion`:

```
question: "Does this content mapping look right?"
header: "Mapping"
options:
  - label: "Yes, looks good"
    description: "Proceed to the validation check"
  - label: "Adjust the mapping"
    description: "I will tell you what to change"
  - label: "Try a different approach"
    description: "Go back and pick another visualization"
```

---

## Phase 4: Validation Gate (The 2-Second Gut Check)

```
>>> READ references/quality-checklist.md NOW
```

**This is a GATE. Do not skip it.**

### 4.1: Write the 2-Second Statement

Before writing any prompt, explicitly answer:

> "A person scrolling LinkedIn sees this image for exactly 2 seconds. What do they GET?"

Write the answer in ONE sentence:
- For Editorial: "They feel [emotion] and stop scrolling because [reason]."
- For Info Graphic: "They learn [fact] and think 'I should save this.'"

### 4.2: Validate

**If the statement is clear and specific:** proceed to Phase 6 (or Phase 5 if API key is needed).

**If the statement is vague or unclear:** the concept is not ready. Go back to Phase 3. Do NOT proceed.

Present the 2-second statement to the user for confirmation.

---

# EXECUTE

## Phase 5: API Key Setup

```
>>> READ references/nano-banana-api.md NOW (Section: API Setup)
```

Only reached if Phase 0 found no API key.

Use `AskUserQuestion`:

```
question: "I need a Gemini API key to generate the image. How do you want to proceed?"
header: "API Key"
options:
  - label: "Set it up now (Recommended)"
    description: "I will guide you through getting a free key from Google AI Studio"
  - label: "I have a key ready"
    description: "Let me paste it"
  - label: "Skip for now"
    description: "Just give me the prompt to use elsewhere"
```

Follow the paths described in `nano-banana-api.md`:
- **Set it up now:** Guide through Google AI Studio, save to .env, instruct restart, EXIT SKILL
- **I have a key:** Save to .env, instruct restart, EXIT SKILL
- **Skip for now:** Complete all phases normally, save prompt to `.infographic/prompts/` instead of generating

**CRITICAL:** After saving a key, the skill MUST EXIT. Tell the user to restart Claude Code and run the skill again.

---

## Phase 6: Prompt Construction + Generation

```
>>> READ references/brand-guidelines.md NOW (for Information Graphics and Hybrid)
>>> READ references/prompt-engineering.md NOW
```

### 6.0: Pre-Prompt Thinking (Required)

Before writing a single word of the prompt, answer these questions explicitly.
The quality of the prompt is determined by the quality of the thinking BEFORE it.

1. **Text inventory:** List every piece of text that must appear in the image.
   Will use TEXT LINE N: format with CRITICAL exact spelling instruction.

2. **Element control:** Should icons appear? If NO, will use the nuclear NO formula
   (listing every synonym: icons, illustrations, pictograms, emojis, visual symbols).
   If YES, which icon library reference? (Phosphor, Feather, etc.)

3. **Style anchor:** What single brand/product reference captures the target aesthetic?
   (e.g., "Stripe.com", "Linear.app", "Notion.so")
   This controls style more reliably than any amount of CSS specifications.

4. **Layout structure:** How many sections? Will use === SECTION === markers
   with [LARGE GAP] between them for clear visual separation.

5. **Aspect ratio:** Confirm ratio appears in BOTH the prompt text AND the
   generate_image parameter.

Document these answers, then proceed to 6.1 using them as the foundation for
the prompt. The prompt-engineering.md reference file teaches the exact formats
and assembly order.

### 6.1: Craft the Prompt

Use the correct architecture from `prompt-engineering.md`:

**For Editorial Illustration:** 9-part structure
Style anchor, emotional register, the scene, spatial composition, texture/materiality, color palette, text elements, what not to do, technical specs.

**For Information Graphic:** 8-part structure
Format declaration, information hierarchy, data visualization, exact text, brand system (from `brand-guidelines.md`), density control, scanability, technical specs.

### 6.2: Show Prompt for Approval

```
Here's the prompt I will use:

---
[Full prompt text]
---
```

Use `AskUserQuestion`:

```
question: "Ready to generate with this prompt?"
header: "Prompt"
options:
  - label: "Yes, generate"
    description: "Looks good, go ahead"
  - label: "Tweak the prompt"
    description: "I want to adjust something before generating"
  - label: "Start over"
    description: "Go back to concept selection"
```

### 6.3: Generate

For the selected platform, use the matching aspect ratio:

| Platform | aspectRatio param |
|----------|------------------|
| LinkedIn | "4:5" |
| Instagram (square) | "1:1" |
| Twitter/Presentation | "16:9" |

```
Call tool: generate_image
Parameters: { "prompt": "[approved prompt]", "aspectRatio": "[ratio]" }
```

### 6.4: Copy and Display

```bash
mkdir -p .infographic/images
cp "./generated_imgs/[returned-filename]" ".infographic/images/[topic-slug]-v1.png"
```

**IMMEDIATELY display to user using Read tool:**
```
Read file: .infographic/images/[topic-slug]-v1.png
```

The user MUST see the image to give feedback.

### If No API Key (Skip Path)

Save the prompt to `.infographic/prompts/[topic]-prompt.md` with manual instructions for Google AI Studio.

---

## Phase 7: Review + Iterate

```
>>> RE-READ references/quality-checklist.md NOW
```

### 7.1: The Diagnostic Question

Use `AskUserQuestion`:

```
question: "Looking at this for 2 seconds as a stranger - what do you GET?"
header: "Reaction"
options:
  - label: "The right thing - it hits"
    description: "The message lands. Maybe small tweaks but the core is right."
  - label: "Right direction, wrong execution"
    description: "I get the concept but something about the image isn't working."
  - label: "The wrong thing"
    description: "The concept isn't transmitting. Need to rethink the visual."
  - label: "Nothing - it's not clear"
    description: "Can't tell what this is saying in 2 seconds."
```

### 7.2: Branch

**"The right thing"** - Ask about specific tweaks, then apply edits.

**"Right direction, wrong execution"** - Drill into WHAT isn't working:

```
question: "What specifically isn't working?"
header: "Changes"
multiSelect: true
options:
  - label: "Emotional register is off"
    description: "Doesn't look like pain/joy/etc - the image doesn't FEEL right"
  - label: "Too cramped / needs whitespace"
    description: "Elements are too close together, not enough breathing room"
  - label: "Text issues"
    description: "Wording, size, placement, readability, typos"
  - label: "Style is off"
    description: "The visual language doesn't match what I described"
```

Get specifics on each selection before editing.

**"The wrong thing" or "Nothing"** - The concept is broken. Go back to Phase 3. Do NOT try to fix with edits.

### 7.3: Apply Edits

**First edit:**
```
Call tool: edit_image
Parameters: {
  "imagePath": ".infographic/images/[topic]-v1.png",
  "prompt": "Edit this infographic:\n1. [Change 1]\n2. [Change 2]\nKeep everything else exactly the same."
}
```

**Subsequent edits:**
```
Call tool: continue_editing
Parameters: { "prompt": "[further changes]" }
```

After each edit:
1. Copy from `./generated_imgs/[filename]` to `.infographic/images/[topic]-v[N].png`
2. Display using Read tool
3. Ask if changes are correct

Repeat until approved. Save final version as `[topic]-final.png`.

---

## Phase 8: Wrap Up

```
Your infographic is ready!

Saved to: .infographic/images/[topic]-final.png

Want to visualize another concept from your content?
(I had [N] other suggestions from Phase 2.)
```

If yes: return to Phase 2.5 with the next chosen concept (skip the analysis, go straight to concept selection).

---

## Progressive Updates

When a user provides feedback that constitutes a general preference (not a one-time edit), the skill should recognize it as a potential rule.

Use `AskUserQuestion`:
```
question: "Should I remember this as a permanent rule for future infographics?"
header: "New Rule"
options:
  - label: "Yes, always"
    description: "Add this to my permanent rules"
  - label: "Just this time"
    description: "Apply it now but don't save"
```

If confirmed: append a new numbered rule to the Rules section below.

---

## Reference File Load Map

| Phase | File Loaded | Purpose |
|-------|------------|---------|
| 0 | None | Just checking config |
| 1 | None | Just collecting content |
| 2 | `content-analysis.md` | 4-layer framework for analysis |
| 3 | `visualization-patterns.md` | Layout archetypes + style anchors |
| 4 | `quality-checklist.md` | 2-second test as validation gate |
| 5 | `nano-banana-api.md` | API key setup instructions |
| 6 | `brand-guidelines.md` + `prompt-engineering.md` | Brand specs + prompt vector system |
| 7 | `quality-checklist.md` (re-read) | Diagnostic framework for iteration |

---

## File Naming

| Stage | Pattern | Example |
|-------|---------|---------|
| First version | `[topic]-v1.png` | `chosen-pain-v1.png` |
| After edits | `[topic]-v2.png` | `chosen-pain-v2.png` |
| Final | `[topic]-final.png` | `chosen-pain-final.png` |
| Series | `[topic]-01-v1.png` | `tips-01-v1.png` |
| Prompts | `[topic]-prompt.md` | `.infographic/prompts/tips-prompt.md` |

---

## Directory Structure

```
.infographic/
  brand.md           # Saved brand config (optional, for overrides)
  images/            # All generated infographics
    topic-v1.png
    topic-v2.png
    topic-final.png
  prompts/           # Saved prompts (for no-key fallback)
    topic-prompt.md
```

---

## Rules

1. Never use em dashes (the long dash character)
2. Always give 5+ suggestions at every decision point (never one-off outputs)
3. Visualize claims (Layer 3) or information (Layer 4), NEVER narrative or themes
4. Apply the 2-second test BEFORE designing, not after
5. Edit don't regenerate (unless the concept itself is broken)
6. Use style anchors, not abstract descriptors ("Moebius meets Adult Swim" beats "clean modern illustration")
7. NEVER use black backgrounds
8. Max 4-5 distinct elements per infographic, one key message rule
9. Always include footer: "Ben Van Sprundel | Founder @ BenAI"
10. Instruct clearly in the process when to use each reference file (lazy loading)
