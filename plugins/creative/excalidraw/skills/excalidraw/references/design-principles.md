# Visual Design Philosophy

Design thinking for building Excalidraw presentations that communicate, not just display.

---

## 1. Core Philosophy

### Show, Don't Tell

A slide that requires reading is a document, not a presentation. Every slide should communicate its point through **visual structure** — shapes, spatial relationships, color, and hierarchy — with text serving as labels, not explanations.

**The 3-second glance test:** Can someone look at this slide for 3 seconds and understand the point? If not, the visual design has failed, not the content.

### Rich, Not Sparse

Excalidraw presentations should feel intentional and complete — not like wireframes. A slide with a title and three bullet points is a waste of the medium. Use the full visual vocabulary: shapes, arrows, containers, color-coding, spatial grouping, icons/emoji markers.

That said, "rich" doesn't mean "cluttered." Every element should earn its place. If removing an element doesn't lose meaning, remove it.

---

## 2. Outcome Thinking

Before designing ANY slide, answer these four questions. This prevents template-matching and forces purpose-driven design.

### Purpose
> "What does this slide need to COMMUNICATE?"

Not "what information goes here" — what understanding should the viewer gain?

### Transformation
> "What changes in the viewer's mind after seeing this?"

They should go from not knowing → knowing, or from confused → clear, or from skeptical → convinced.

### Memory
> "What's the ONE image or pattern they'll remember?"

If someone describes this slide to a colleague, what visual will they recall? That's your focal point.

### Action
> "What does this slide make them want to do next?"

Read the next slide? Ask a question? Sign up? This shapes whether the slide ends with a CTA, a cliffhanger, or a resolution.

**Run this for every slide.** It takes 10 seconds and prevents slides that exist without purpose.

---

## 3. Visual Vocabulary

These are the diagram types available for slide design. Each has a natural use case, but creative remixing is encouraged — a "Hub & Spoke" can become a mind map, a solar system, or a target with rings.

| Diagram Type | Structure | Best For | Example |
|---|---|---|---|
| **Hub & Spoke** | Central node + radiating connections | Core concept with related ideas, features, benefits | Product with 4 key features |
| **Pipeline / Flow** | Linear boxes connected by arrows (horizontal) | Processes, workflows, timelines, step-by-step | User onboarding flow |
| **Vertical Flow** | Steps stacked top-to-bottom with arrows | Sequences with descriptions, funnels | Sales funnel stages |
| **Comparison** | Side-by-side panels (left vs. right) | Before/after, old/new, us/them | Current vs. proposed architecture |
| **Grid / Matrix** | 2×2 or 2×3 grid of equal cards | Features, team members, categories | Pricing tiers, product categories |
| **Hierarchy / Nested** | Large container with smaller elements inside | Composition, containment, grouping | System architecture layers |
| **Single Concept + Annotation** | One large element with callout arrows | Detailed explanation of one thing | Product screenshot with feature callouts |
| **Metrics / Results** | Large numbers as focal point | Impact, outcomes, proof points | "47% faster" with supporting context |
| **Timeline** | Horizontal line with events marked along it | History, roadmap, milestones | Product roadmap Q1-Q4 |
| **Venn / Overlap** | Overlapping circles or regions | Relationships, intersections, shared traits | Skill overlap between roles |
| **Spectrum / Scale** | Linear scale with markers | Range, progression, positioning | Complexity spectrum from simple to advanced |
| **Cycle** | Circular arrangement with arrows | Repeating processes, feedback loops | Agile sprint cycle |
| **Title / CTA** | Centered text with supporting elements | Opening slides, closing slides, calls to action | "Let's Build This Together" |

**Creative latitude:** These are starting points, not templates. A "Pipeline" can curve, branch, or converge. A "Grid" can have unequal cards to show emphasis. A "Hub & Spoke" can be asymmetric. Design for the content, not for the pattern.

---

## 4. Content Requirements

### When Rich Content Is Provided

Extract and organize:
- **Core message** — the single thesis
- **Supporting points** — 3-5 pillars that hold up the message
- **Evidence** — data, quotes, examples, case studies
- **Relationships** — what connects to what, what causes what, what contains what
- **Call to action** — what the audience should do

Map each to a slide with a diagram type that matches the relationship structure.

### When Content Is Sparse

Ask the user in small groups (per SKILL.md Phase 3.2). Extract enough to build:
- A clear core message
- 3-5 key points
- At least one piece of evidence or example
- A call to action

**Never invent content.** If you don't have enough, ask for more. A beautiful slide with made-up data is worse than a plain slide with real data.

---

## 5. Quality Standards

### Pre-Generation Checklist

Run this BEFORE generating JSON for each slide:

- [ ] **Purpose clear?** — Can you state what this slide communicates in one sentence?
- [ ] **Diagram type chosen?** — Does the visual structure match the content relationship?
- [ ] **Focal point identified?** — Which element should the eye go to first?
- [ ] **Element count reasonable?** — 5-15 elements per slide (not counting the frame)
- [ ] **Text minimal?** — Labels and keywords, not sentences
- [ ] **Colors meaningful?** — Every color choice has a reason (brand, semantic, or grouping)
- [ ] **Brand applied?** — Using the brand palette from Phase 2, not arbitrary colors

### Good vs. Bad Checklist

| Good | Bad |
|---|---|
| One focal point per slide | Everything the same size/weight |
| Visual structure carries meaning | Text carries meaning, visuals are decoration |
| 2-3 colors per slide (from palette) | Rainbow of unrelated colors |
| Parallel elements are consistent (same size, style) | Boxes of random sizes |
| Every element connects to something | Orphan elements floating alone |
| Whitespace is intentional (breathing room) | Either cramped or empty |
| Text is labels (2-5 words per element) | Text is sentences or paragraphs |
| Eye flow follows a clear path | Eye bounces randomly |

---

## 6. Technical Specs

### Default Color Palette

Used when no brand colors are provided. Override with brand colors from `.excalidraw/brand.md`.

| Role | Background (light) | Stroke/Text (dark) | Use for |
|---|---|---|---|
| Primary | #a5d8ff | #1971c2 | Main concepts, emphasis, brand elements |
| Secondary | #d0ebff | #1971c2 | Sub-elements within primary containers |
| Success | #b2f2bb | #2f9e44 | Positive states, benefits, "after" states |
| Warning | #fff3bf | #f08c00 | Attention points, transitions |
| Danger | #ffc9c9 | #e03131 | Problems, pain points, "before" states |
| Neutral | #e9ecef | #495057 | Backgrounds, secondary info, dividers |
| Canvas | #f8f9fa | #dee2e6 | Slide frames, subtle backgrounds |

**Text colors:**
- Primary text: `#1e1e1e`
- Secondary text: `#495057`
- Muted text: `#868e96`

### Canvas Layout Zones

Each slide is 800×500px. Think of it in zones:

```
┌──────────────────────────────────────┐
│  TITLE ZONE (y: 20-70)              │
│  fontSize 28-36, centered            │
├──────────────────────────────────────┤
│                                      │
│  CONTENT ZONE (y: 80-420)           │
│  Main visual elements go here        │
│  This is 340px of vertical space     │
│                                      │
├──────────────────────────────────────┤
│  FOOTER ZONE (y: 430-490)           │
│  Annotations, sources, CTA           │
└──────────────────────────────────────┘
```

### Element Specs

Refer to `element-reference.md` for complete JSON specs. Key reminders:
- **fontFamily 2** (Helvetica) for all presentation text
- **roughness 1** for subtle hand-drawn feel, or **roughness 0** for clean — be consistent across all slides
- **roundness { type: 3 }** for rounded corners on cards and containers
- All elements in a slide share the same `groupIds` value
- Seeds use non-overlapping ranges per slide (1000-1099, 2000-2099, etc.)

### Icon / Emoji Usage

Use emoji as visual markers inside or next to elements:
- Place as standalone text elements (fontSize 24-32) next to or above labels
- Use to reinforce meaning: `🎯` for goals, `⚡` for speed, `🔒` for security, `📈` for growth
- Limit to 1-2 emoji per slide — they're markers, not decoration
- Always pair with a text label (emoji alone is ambiguous)

---

## 7. Visual Hierarchy Rules

Four dimensions that create hierarchy. Use them deliberately.

### Size = Importance
- Most important element is the largest
- Supporting elements are proportionally smaller
- Annotations and labels are smallest
- Title text: 28-36 → Label text: 16-20 → Caption text: 12-14

### Color = Meaning
- Blue: primary concepts, "the thing you're explaining"
- Green: positive outcomes, benefits, the "after" state
- Red: problems, pain points, the "before" state
- Yellow/Orange: attention, warnings, transitions
- Gray: background, secondary, structural

Don't use color arbitrarily. If two boxes are the same color, they should be the same category.

### Position = Sequence
- Left to right = time flow, progression, improvement
- Top to bottom = hierarchy, priority, funnel
- Center = focal point, most important
- Periphery = supporting context, details

### Contrast = Focus
- High contrast (dark stroke on light fill) = important, look here
- Low contrast (light stroke on light fill) = background, structural
- One element per slide should "pop" — the thing the eye finds first
- Use strokeWidth 2-4 for emphasis, strokeWidth 1 for structure

---

## 8. Heuristics That Make It Look Good

Practical rules that separate "competent" from "compelling."

### One Focal Point Per Slide
Every slide has ONE thing the eye should go to first. Make it the largest, highest-contrast, or most centrally positioned element. If everything is the same size, nothing is important.

### Flow Direction Guides the Eye
Arrange elements so the eye moves naturally:
- **Left → Right** for processes, timelines, improvement
- **Top → Bottom** for hierarchies, funnels, priority
- **Center → Out** for hub-and-spoke, radial concepts
- **Arrows confirm direction** — use them to make flow explicit

### Color Grouping for Related Items
Elements that belong to the same category should share a color. This creates instant visual parsing — the viewer sees "3 blue things and 2 green things" before reading any text.

### Emphasis Through strokeWidth and Saturation
- Primary elements: `strokeWidth: 2`, saturated fill colors
- Secondary elements: `strokeWidth: 1`, lighter/muted fill colors
- Background elements: `strokeWidth: 1`, near-white fills
- This creates depth — foreground, midground, background

### Emoji as Visual Markers
A `🎯` next to "Goals" or `⚡` next to "Fast" adds instant recognition. But:
- Max 1-2 per slide
- Always paired with text
- Used for reinforcement, not decoration

### The 3-Second Glance Test
Before finalizing any slide, ask: "If someone glanced at this for 3 seconds, would they understand the point?" If not:
- Increase the focal point's size or contrast
- Reduce the number of competing elements
- Simplify the text to keywords
- Add directional cues (arrows, position)

### Balance: Not Cramped, Not Sparse
- **Too cramped:** Elements touching or overlapping, no breathing room, text too small to fit
- **Too sparse:** Huge empty areas, one tiny element in a sea of whitespace, looks unfinished
- **Just right:** Elements have 20-30px gaps, content fills ~60-70% of the content zone, whitespace is intentional (framing the content, not leftover space)

### Consistency Across Slides
- Same font sizes for the same roles across all slides
- Same color meanings throughout the deck
- Same roughness setting on all elements
- Same card/box sizing for parallel concepts
- This makes the deck feel like ONE thing, not a collage
