---
name: infographic
description: Generate professional infographics using Nano Banana MCP (Gemini AI image generation). Follows a guided flow — analyze content, suggest visualizable concepts, propose visualization approaches, then generate on-brand images. USE THIS SKILL WHEN user says "create infographic", "make a visual", "design an infographic", "generate infographic", wants to visualize a concept, framework, or data for social media, mentions "LinkedIn post", "visual content", "infographic series", asks to explain a concept visually or create a diagram-style image, mentions "visual metaphor", "iceberg diagram", "pyramid", "funnel visualization", wants to generate images with Gemini for informational content, or says "brand visuals", "social media graphics", "thought leadership visual".
  - User mentions "nano banana", "gemini image generation", "professional infographics"
---

# Infographic Generation Skill

Create professional, on-brand infographics using Gemini AI via the Nano Banana MCP server. This skill follows a strict interactive process — never skip ahead without user approval at each step.

---

## When This Skill Loads (DO THIS IMMEDIATELY)

1. Read `references/design-principles.md` (brand philosophy and design thinking — internalize this deeply)    
2. Read `references/gemini-image-api.md` (MCP tool reference)                                                 
3. Read `references/api-setup.md` (API key setup guide)                                                       
4. Execute Phase 0 (silent config check)
5. **If API key is NOT configured in Phase 0:**
   - Skip directly to Phase 4 (API Key Setup)
   - Do NOT proceed to Phase 1
   - Do NOT ask about content
6. **If API key IS configured:**
   - Begin Phase 1

---

## Phase 0: Silent Config Check

Run silently — do NOT ask questions yet.

### 0.1: Ensure Directory Structure

```bash
mkdir -p .infographic/images
mkdir -p .infographic/prompts
```

### 0.2: Check for API Key

Check if the GEMINI_API_KEY exists. Check BOTH the environment variable AND the `.env` file:

```bash
# Check environment variable first, then .env file
if [ -n "$GEMINI_API_KEY" ]; then
  echo "API key found in environment"
elif [ -f .env ] && grep -q "^GEMINI_API_KEY=.\+" .env; then
  echo "API key found in .env file"
else
  echo "API key not configured"
fi
```

**Why check both?** The MCP server uses `dotenv` to load `.env` automatically at startup. So even if the bash shell doesn't have the env var set, the MCP server reads it from `.env` directly. If the key exists in `.env`, the MCP server has it.

**CRITICAL DECISION POINT:**
- If found (in env var OR `.env` file): Proceed silently to Phase 1
- If NOT found in either: **IMMEDIATELY jump to Phase 4 (API Key Setup)**
  - Do NOT proceed to Phase 1
  - Do NOT ask about content
  - Do NOT try to generate
  - Go directly to Phase 4 to get the API key from the user

**Note:** Do NOT use `get_configuration_status` MCP tool - it gives false positives.

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

Propose your understanding, then confirm with `AskUserQuestion`:

```
Here's what I see as the key message:
[Your extracted insight in one sentence]

Main points:
1. [Point 1]
2. [Point 2]
3. [Point 3]
```

Use `AskUserQuestion`:

```
question: "Does this capture your key message correctly?"
header: "Content"
options:
  - label: "Yes, that's right"
    description: "Move on to platform selection"
  - label: "Close, but adjust"
    description: "I'll tell you what to change"
  - label: "No, let me reframe"
    description: "I'll explain the key message differently"
```

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
```

Then use `AskUserQuestion` (use the actual concept names as labels):

```
question: "Which concept would you like to turn into an infographic?"
header: "Concept"
options:
  - label: "[Concept A short name]"
    description: "[Brief reason why it's visualizable]"
  - label: "[Concept B short name]"
    description: "[Brief reason why it's visualizable]"
  - label: "[Concept C short name]"
    description: "[Brief reason why it's visualizable]"
  - label: "[Concept D short name]"
    description: "[Brief reason why it's visualizable]"
```

Note: `AskUserQuestion` supports up to 4 options. If you have 5 concepts, present the top 4 and the user can pick "Other" to choose the 5th.

**Never proceed without their selection.**

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

Present 3 options, then use `AskUserQuestion`:

```
For "[chosen concept]", here are 3 ways to visualize it:
```

Use `AskUserQuestion`:

```
question: "Which visualization approach do you prefer?"
header: "Layout"
options:
  - label: "[Layout Type A]"
    description: "[How content maps to this layout and why it fits]"
  - label: "[Layout Type B]"
    description: "[How content maps to this layout and why it fits]"
  - label: "[Layout Type C]"
    description: "[How content maps to this layout and why it fits]"
```

**Wait for user to choose.** Then map their specific content to the chosen structure:

```
Here's how your content maps to [chosen approach]:

[Show the exact mapping with their words — e.g., what goes in each section,
what text appears where, how the visual hierarchy works]
```

Use `AskUserQuestion`:

```
question: "Does this content mapping look right?"
header: "Mapping"
options:
  - label: "Yes, looks good"
    description: "Proceed to generate the infographic"
  - label: "Adjust the mapping"
    description: "I'll tell you what to change"
  - label: "Try a different approach"
    description: "Go back and pick another visualization style"
```

---

## Phase 4: API Key Setup

**Goal:** Ensure the Gemini API key is configured in the Nano Banana MCP server.

### 4.1: Check for API Key

Before generating, check if the GEMINI_API_KEY exists in the environment or `.env` file:

```bash
if [ -n "$GEMINI_API_KEY" ]; then
  echo "API key found in environment"
elif [ -f .env ] && grep -q "^GEMINI_API_KEY=.\+" .env; then
  echo "API key found in .env file"
else
  echo "API key not configured"
fi
```

### If Key IS Found (env var OR .env file) → Skip to Phase 5

The MCP server uses `dotenv` to load `.env` automatically. If the key is in `.env`, the MCP server has it.

### If Key NOT Found in Either

Ask the user how they want to proceed:

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

### Path A: Set Up Now (Guided Setup)

Present these instructions:

```
To get your free Gemini API key:

1. Go to Google AI Studio: https://aistudio.google.com
2. Sign in with your Google account
3. Click "Get API Key" in the left sidebar
4. Click "Create API Key" and select a project (or create a new one)
5. Copy the generated key (starts with "AIza...")

Paste your API key below when ready.
```

Wait for user to provide the key, then proceed to **Save the Key**.

### Path B: User Has Key Ready

```
Great! Paste your Gemini API key below.
```

Wait for user to provide the key, then proceed to **Save the Key**.

### Save the Key (After Path A or B)

Once user provides the key:

1. **Save to `.env` file:**
```bash
# Create .env if it doesn't exist
if [ ! -f .env ]; then
  cat > .env <<'EOF'
# BenAI Skills - API Keys Configuration

# ============================================================================
# Marketing Plugin
# ============================================================================

# GEMINI_API_KEY - Required for /infographic skill
GEMINI_API_KEY=

# GEMINI_IMAGE_MODEL - Options: gemini-3-pro-image-preview (highest quality), gemini-2.5-flash-image (fast)
GEMINI_IMAGE_MODEL=gemini-3-pro-image-preview

# APIFY_TOKEN - Required for /seo-audit and /programmatic-seo skills
APIFY_TOKEN=

EOF
fi

# Update the GEMINI_API_KEY line
sed -i '' "s|^GEMINI_API_KEY=.*|GEMINI_API_KEY=[user-provided-key]|" .env

# Add .env to .gitignore for security
echo ".env" >> .gitignore 2>/dev/null || true
```

2. **Confirm to user and EXIT THE SKILL:**
```
✅ API key saved to .env!

⚠️  Please restart Claude Code so the MCP server can load your new key.

The Nano Banana MCP server uses dotenv to read .env automatically at startup.
After restart, your key will be loaded and ready.

Steps:
1. Restart Claude Code
2. Run /infographic again
3. It will work!
```

**CRITICAL:** After showing this message, the skill MUST EXIT. Do NOT:
- Call `configure_gemini_token` MCP tool (creates unwanted .nano-banana-config.json)
- Call `get_configuration_status` MCP tool (gives false positives)
- Proceed to generation
- Continue the workflow in any way

The MCP server needs to restart to load .env via dotenv. Exit the skill now.

### Path C: Skip for Now

```
No problem! I'll complete all the planning phases and give you a ready-to-use prompt at the end.

You can then:
- Paste it into Google AI Studio (aistudio.google.com)
- Use it with other image generation tools
- Come back later with /infographic after getting your API key

Let's continue with the design...
```

In this mode, complete Phases 1-5 normally, but in Phase 5.3, save the prompt to `.infographic/prompts/[topic]-prompt.md` instead of generating.

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
