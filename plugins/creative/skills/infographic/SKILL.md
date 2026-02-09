---
name: infographic
description: Generate professional infographics using Nano Banana MCP (Gemini AI image generation). Follows a guided flow — analyze content, suggest visualizable concepts, propose visualization approaches, then generate on-brand images. USE THIS SKILL WHEN user says "create infographic", "make a visual", "design an infographic", "generate infographic", wants to visualize a concept, framework, or data for social media, mentions "LinkedIn post", "visual content", "infographic series", asks to explain a concept visually or create a diagram-style image, mentions "visual metaphor", "iceberg diagram", "pyramid", "funnel visualization", wants to generate images with Gemini for informational content, or says "brand visuals", "social media graphics", "thought leadership visual".
  - User mentions "nano banana", "gemini image generation", "professional infographics"
---

# Infographic Generation Skill

Create professional, on-brand infographics using Gemini AI via the Nano Banana MCP server. This skill follows a strict interactive process — never skip ahead without user approval at each step.

---

## When This Skill Loads (DO THIS IMMEDIATELY)

1. Read `references/gemini-image-api.md` (MCP tool reference)
2. Read `references/api-setup.md` (API key setup guide)
3. Execute Phase 0 (silent config check)
4. Begin Phase 1

---

## Phase 0: Silent Config Check

Run silently — do NOT ask questions yet.

### 0.1: Ensure Directory Structure

```bash
mkdir -p .infographic/images
mkdir -p .infographic/prompts
```

### 0.2: Check Nano Banana MCP Availability

```
Call tool: get_configuration_status
```

If configured: Proceed silently.
If NOT configured: Flag for Phase 4.

### 0.3: Check for Brand Config

```bash
if [ -f .infographic/brand.md ]; then
  cat .infographic/brand.md
fi
```

If brand config exists, acknowledge briefly:
```
I found your saved settings. Ready to create your infographic!
```

If nothing exists, proceed to Phase 1.

---

## Phase 1: Understand the Content

**Goal:** Understand what the user wants to communicate and for which platform.

### 1.1: Extract the Core Message

Read the user's content (LinkedIn post, concept, data, or topic). Identify:
- The ONE key insight or takeaway
- The main supporting points
- Any data, numbers, or comparisons

Propose your understanding:
```
Here's what I see as the key message:
[Your extracted insight in one sentence]

Main points:
1. [Point 1]
2. [Point 2]
3. [Point 3]

Is this right, or would you frame it differently?
```

Wait for confirmation.

### 1.2: Platform & Resolution

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

---

## Phase 2: Suggest Visualizable Concepts

**Goal:** Don't visualize the entire post. Identify the 3–5 specific parts that would work best as a standalone infographic.

Analyze the content and extract 3–5 discrete concepts that could each become a focused infographic. For each, explain:
- What the concept is (one line)
- Why it's a good candidate for visualization
- What type of visual it maps to (process, comparison, hierarchy, metaphor, etc.)

Present like this:

```
Looking at your content, here are the parts worth visualizing:

1. **[Concept A]** — [brief description]. Great for visualization because [reason].
2. **[Concept B]** — [brief description]. Great for visualization because [reason].
3. **[Concept C]** — [brief description]. Great for visualization because [reason].
4. **[Concept D]** — [brief description]. Great for visualization because [reason].
5. **[Concept E]** — [brief description]. Great for visualization because [reason].

Which one would you like to turn into an infographic?
```

**Wait for user to choose.** Never proceed without their selection.

---

## Phase 3: Propose Visualization Approaches

**Goal:** For the chosen concept, suggest 3 different ways to visualize it.

Think about what visual structure fits the concept's shape:

| Concept Shape | Visual Approaches |
|--------------|-------------------|
| Sequential process | Vertical flow, timeline, numbered steps |
| Comparison | Side-by-side split, grid, before/after |
| Hierarchy | Pyramid, layers, tier list |
| Hidden depth | Iceberg, surface vs. depth |
| Parts of a whole | Pie/donut, silhouette with branches |
| Convergence | Funnel, hourglass |
| Overlap | Venn diagram |
| Transformation | Tangled → straight, chaos → order |

Present 3 options:

```
For "[chosen concept]", here are 3 ways to visualize it:

1. **[Layout Type A]** — [Description of how the content maps to this layout]. Best because [reason].
2. **[Layout Type B]** — [Description of how the content maps to this layout]. Best because [reason].
3. **[Layout Type C]** — [Description of how the content maps to this layout]. Best because [reason].

Which approach do you prefer?
```

**Wait for user to choose.** Then map their specific content to the chosen structure:

```
Here's how your content maps to [chosen approach]:

[Show the exact mapping with their words — e.g., what goes in each section,
what text appears where, how the visual hierarchy works]

Does this mapping look right?
```

Wait for confirmation before generating.

---

## Phase 4: MCP Configuration

**Goal:** Ensure the Nano Banana MCP is ready to generate images.

### Check Configuration

```
Call tool: get_configuration_status
```

### If Configured → Skip to Phase 5

### If NOT Configured

Use `AskUserQuestion`:

```
question: "I need a Gemini API key to generate the image. How do you want to proceed?"
header: "API Key"
options:
  - label: "Set it up now (Recommended)"
    description: "I'll guide you through getting a free key from Google AI Studio"
  - label: "I have a key ready"
    description: "Let me paste it"
  - label: "Skip for now"
    description: "Just give me the prompt to use elsewhere"
```

**Path A: Set Up Now**

```
To get your Gemini API key:

1. Go to Google AI Studio: https://aistudio.google.com
2. Sign in with your Google account
3. Click "Get API Key" in the left sidebar
4. Click "Create API Key" and select a project
5. Copy the generated key

Paste your API key below when ready.
```

After user provides key:

```
Call tool: configure_gemini_token
Parameters: { "apiKey": "user-provided-key" }
```

Verify:

```
Call tool: get_configuration_status
```

**Path B: User Has Key** — Paste → `configure_gemini_token` → verify → proceed.

**Path C: Skip** — Complete all phases but output the prompt as text instead of generating. Save to `.infographic/prompts/[topic]-prompt.md`.

---

## Phase 5: Generate the Infographic

**Goal:** Craft a detailed prompt following brand guidelines, generate, and display.

### 5.1: Craft the Prompt

Build a detailed prompt that includes ALL of the following:

1. **The exact content** — all text, labels, titles from the mapping in Phase 3
2. **The visualization structure** — the chosen layout from Phase 3
3. **Brand guidelines** — colors, typography, styling (see Brand Guidelines section below)
4. **Platform specs** — aspect ratio and resolution embedded in prompt text

**IMPORTANT:** Since the MCP tool does not accept separate aspect ratio or resolution parameters, embed them in the prompt:

| Platform | Append to Prompt |
|----------|-----------------|
| LinkedIn | "Output as a 4:5 portrait aspect ratio image at approximately 2048 pixels wide" |
| Instagram (square) | "Output as a 1:1 square aspect ratio image at approximately 2048 pixels wide" |
| Twitter/Presentation | "Output as a 16:9 landscape aspect ratio image at approximately 2048 pixels wide" |

### 5.2: Show Prompt for Approval

```
Here's the prompt I'll use:

---
[Full prompt text]
---

Any tweaks before I generate?
```

Wait for approval.

### 5.3: Generate

```
Call tool: generate_image
Parameters: { "prompt": "[approved prompt]" }
```

### 5.4: Copy and Display (CRITICAL)

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

Save the prompt to `.infographic/prompts/[topic]-prompt.md` with manual instructions:
```
To generate:
1. Go to aistudio.google.com
2. Select "Gemini" model
3. Paste the prompt
4. Click Generate
5. Download the image
```

---

## Phase 6: Review & Edit

**Goal:** Iterate until the user is happy.

### 6.1: First Impression

Use `AskUserQuestion`:

```
question: "Here's your infographic. What do you think?"
header: "Reaction"
options:
  - label: "Love it!"
    description: "Maybe small tweaks, but the direction is right"
  - label: "Good direction, needs changes"
    description: "Core works, specific things to adjust"
  - label: "Not quite right"
    description: "Let's try a different approach"
  - label: "Start over"
    description: "Go back and try a different visualization"
```

If "Love it!" → copy to `[topic]-final.png`, go to Phase 7.
If "Start over" → return to Phase 3.

### 6.2: Collect Specific Feedback

Use `AskUserQuestion` with multiSelect:

```
question: "What would you like to change?"
header: "Changes"
multiSelect: true
options:
  - label: "Colors"
    description: "Wrong colors, too dark/light, off-brand"
  - label: "Text"
    description: "Wording, size, placement, readability"
  - label: "Layout"
    description: "Spacing, arrangement, composition"
  - label: "Style"
    description: "Too busy/simple, wrong feel"
```

Drill down on each selection to get specifics.

### 6.3: Apply Edits

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
1. Copy from `./generated_imgs/[returned-filename]` to `.infographic/images/[topic]-v[N].png`
2. Display using Read tool
3. Ask if changes are correct

Repeat until user approves. Save final version as `[topic]-final.png`.

---

## Phase 7: Wrap Up

```
Your infographic is ready!

Saved to:
├── .infographic/images/[topic]-final.png

Want to visualize another concept from your content? (I had [N] other suggestions from Phase 2.)
```

If yes → return to Phase 3 with the next chosen concept.

---

## Brand Guidelines

**These are non-negotiable. Every infographic MUST follow these exactly.**

### Colors

| Role | Color | Hex |
|------|-------|-----|
| Primary text | Dark | #020309 |
| Light backgrounds / text on dark | Light yellow | #FAF3E3 |
| Subtle backgrounds | Light blue | #E5F5F9 |
| Primary accent | Green | #D2ECD0 |
| Secondary accent | Red/pink | #F3C1C0 |
| Tertiary accent | Dark yellow | #FDEEC4 |

**NEVER use black (#000000) as a background color.**

### Typography

| Element | Font | Fallback |
|---------|------|----------|
| Headings (24pt+) | Space Grotesk | Montserrat → Arial |
| Body text | Montserrat | Georgia |

- Smart color selection based on background
- Preserve text hierarchy and formatting

### Shape & Accent Styling

| Property | Rule |
|----------|------|
| Shadows | **Solid / hard shadows only** — 0 blur (`8px, 8px, 0px #000`) |
| Borders | **Solid borders** — 2px width |
| Border radius | **Slightly rounded** — must NOT look fully round |
| Accent colors | Cycle through yellow (#FDEEC4), blue (#E5F5F9), and green (#D2ECD0) |

### Footer

Always include: `"Ben Van Sprundel  |  Founder @ BenAI"`

### Prompt Template

When crafting prompts, always include these brand specs. Example suffix:

```
Follow these exact brand guidelines:
- Background: #FAF3E3 (light yellow). NEVER use black backgrounds.
- Primary text color: #020309 (near-black)
- Accent colors: green #D2ECD0, red/pink #F3C1C0, dark yellow #FDEEC4. Cycle through them.
- All boxes and cards must have: solid hard shadows (8px offset, 0 blur, #000), solid 2px borders, slightly rounded corners (not fully round).
- Headings in Space Grotesk or Montserrat (bold, 24pt+). Body text in Montserrat.
- Footer text: "Ben Van Sprundel | Founder @ BenAI"
- Output as a [aspect ratio] image at approximately 2048 pixels wide.
```

---

## File Naming

| Stage | Pattern | Example |
|-------|---------|---------|
| First version | `[topic]-v1.png` | `success-iceberg-v1.png` |
| After edits | `[topic]-v2.png` | `success-iceberg-v2.png` |
| Final | `[topic]-final.png` | `success-iceberg-final.png` |
| Series | `[topic]-01-v1.png` | `tips-01-v1.png` |
| Prompts | `[topic]-prompt.md` | `.infographic/prompts/tips-prompt.md` |

---

## Directory Structure

```
.infographic/
├── brand.md           # Saved brand config (optional, for overrides)
├── images/            # All generated infographics
│   ├── topic-v1.png
│   ├── topic-v2.png
│   └── topic-final.png
└── prompts/           # Saved prompts (for no-key fallback)
    └── topic-prompt.md
```

---

## Important Rules

1. **Never skip the suggestion steps** — Always get user approval at Phase 2 (concept choice) and Phase 3 (visualization approach) before generating
2. **Don't visualize the entire post** — Pick a focused part, not everything
3. **Follow brand guidelines exactly** — Colors, shadows, borders, typography are non-negotiable
4. **Embed image specs in prompt** — Aspect ratio and resolution go in the prompt text
5. **Copy MCP output to project directory** — Always copy from `./generated_imgs/` to `.infographic/images/`
6. **Always display the image** — Use Read tool immediately after saving so the user can see it
7. **Edit, don't regenerate** — Use `edit_image`/`continue_editing` for tweaks; only regenerate for major concept changes
8. **Show prompt before generating** — Always get approval on the exact prompt
9. **NEVER use black backgrounds** — Use #FAF3E3 (light yellow) or #E5F5F9 (light blue)
10. **Always include footer** — "Ben Van Sprundel | Founder @ BenAI"
