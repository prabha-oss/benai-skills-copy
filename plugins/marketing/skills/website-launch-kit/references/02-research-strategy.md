# Phase 2 & 3: Research, Strategy & Section Planning

This file covers the workflow for analyzing design inspiration, defining the strategy, and planning the page structure.

---

## Part 1: Research & Design Extraction

**Goal:** Analyze the user provided inspiration URL to extract design elements.

### 1.1 Browser Automation (Fallback)

If WebFetch fails, use `browser_subagent` to analyze the site.

**Command Template:**
```
browser_subagent(
  Task: "Navigate to [URL]. Take full-page screenshot.
         Scroll the entire page, screenshot each section.
         Analyze: colors, typography, layout, spacing, animations, overall vibe.",
  RecordingName: "inspiration_analysis"
)
```

### 1.2 Design Brief Output

Present the analysis in this format:

```
DESIGN EXTRACTION: [URL]

COLORS:
- Primary: [hex] - used for [what]
- Secondary: [hex] - used for [what]
- Background: [hex]
- Text: [hex]

TYPOGRAPHY:
- Headings: [font, weight, style]
- Body: [font, weight, style]

LAYOUT:
- Structure: [centered/full-width/asymmetric]
- Spacing: [tight/normal/generous]

HERO:
- Style: [text-heavy/image-focused/split]
- Animation: [none/subtle/dramatic]

VIBE: [3 descriptive words]
```

### 1.3 Asset Check

Ask user:
```
AskUserQuestion(
  question: "Do you have any existing brand assets?",
  options: [
    { label: "Logo and brand colors", description: "I'll share them" },
    { label: "Just a logo", description: "We'll build colors from the inspiration" },
    { label: "Nothing yet", description: "We'll create everything fresh" }
  ]
)
```

---

## Part 2: Section Planning (Blueprints)

**Goal:** Propose the page structure based on business type.

### 2.1 Section Templates

Select the template that matches the user's business type (from Intake Q1).

#### A. Service Business (Consulting, Agency)
*Focus: Trust, Authority, Process*

1. **Hero**: Headline (Transformation) + Subtitle (Clarity) + CTA
2. **Problem**: Agitation of pain points (Intake Q10, Q11)
3. **Solution**: The "New Way" / Your Offering (Intake Q4, Q12)
4. **Process**: How it works (3-4 steps) (Intake Q14)
5. **Social Proof**: Testimonials / Logos (Intake Q17)
6. **FAQ**: Handling objections (Intake Q18)
7. **CTA**: Final push (Intake Q20)
8. **Footer**: Links and contact

#### B. SaaS / Software Product
*Focus: Features, Benefits, Demo*

1. **Hero**: Value Proposition + Product Visual + CTA
2. **Social Proof**: "Trusted by" logos
3. **Problem/Solution**: The "Before/After" contrast
4. **Key Features**: 3 distinct benefits (not just specs)
5. **How it Works**: Simple 1-2-3 steps or integration view
6. **Testimonials**: User love
7. **Pricing**: Tiers (if applicable)
8. **FAQ**: Technical/Billing questions
9. **CTA**: "Start Free Trial" / "Get Demo"
10. **Footer**: Legal, links

#### C. Personal Brand / Coach
*Focus: Connection, Story, Authority*

1. **Hero**: Photo of you + Promise statement
2. **About / Story**: "I've been there" (Empathy + Authority)
3. **Services**: Ways to work together
4. **Process / Methodology**: Your unique framework
5. **Testimonials**: Client transformations
6. **Newsletter/Lead Magnet**: "Join the list" (optional)
7. **CTA**: "Work with me"
8. **Footer**: Social links

#### D. Product Launch / Waitlist
*Focus: Hype, Scarcity, Desire*

1. **Hero**: Big Promise + "Coming Soon" + Email Capture
2. **The Problem**: Why existing solutions fail
3. **The Solution**: Sneak peek of your product
4. **Features**: What makes it special
5. **Social Proof**: "Join X people on the waitlist"
6. **CTA**: Email capture again
7. **Footer**: Simple links

### 2.2 Proposal Format

Present the structure to the user for approval:

```
Based on your [business type], here's my recommended page structure:

1. [Section] - [Brief purpose]
2. [Section] - [Brief purpose]
3. [Section] - [Brief purpose]
...

Each section will use content from our intake conversation.

Want to add, remove, or reorder any sections?
```

## Part 3: Content Mapping

Map intake answers to sections.

| Section | Intake Source |
| :--- | :--- |
| **Hero** | Q4 (Offering), Q12 (Outcome) |
| **Problem** | Q10 (Problem), Q11 (Impact), Q9 (Trigger) |
| **Solution** | Q4 (Offering), Q16 (Differentiator) |
| **Why You** | Q16 (Differentiator), Q15 (Alternatives) |
| **Process** | Q14 (Process), Q13 (Timeline) |
| **Proof** | Q17 (Social Proof) |
| **FAQ** | Q18 (Objections), Q19 (Scope) |
| **CTA** | Q20 (Action), Q21 (Fields) |
