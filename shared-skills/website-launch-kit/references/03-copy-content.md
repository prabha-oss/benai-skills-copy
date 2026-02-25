# Phase 4 & 5: Copywriting & Content Review

This file guides the creation and review of high-converting landing page copy.

---

## Part 1: Copywriting Formulas

**Goal:** Write compelling copy for every section using proven frameworks.

### 1.1 Tone Mapping

Adjust the tone based on the user's business type and "vibe" from Phase 2.

| Vibe | Tone Keywords | Best For |
| :--- | :--- | :--- |
| **Professional** | Authoritative, Clear, Concise | Corporate, Finance, Enterprise SaaS |
| **Friendly** | Warm, Approachable, Simple | Consumer Apps, Coaching, Lifestyle |
| **Luxury** | Elegant, Minimal, Evocative | High-end Goods, Premium Services |
| **Bold** | Confident, Direct, Energetic | Startups, Agencies, Disruptors |

### 1.2 Section Formulas

#### Hero: The Value Proposition
*Formula:* **The Transformation Statement**
- **Headline:** [Action/Benefit] + [Mechanism] + [Outcome]
- **Example:** "Get 10 New Clients (Benefit) in 30 Days (Outcome) with Our Lead Gen Engine (Mechanism)"

#### Problem: Agitation (PAS)
*Formula:* **Problem - Agitation - Solution**
- **Problem:** State the pain clearly.
- **Agitation:** Make it hurt (cost, stress, time).
- **Solution:** Introduce your offer as the relief.

#### Solution: Benefits > Features (FAB)
*Formula:* **Features - Advantages - Benefits**
- **Feature:** What it is (e.g., "One-click scheduling")
- **Advantage:** What it does (e.g., "No back-and-forth emails")
- **Benefit:** The emotional payoff (e.g., "Reclaim 5 hours of your week")

#### Social Proof: Specificity
*Formula:* **The Specific Win**
- Don't say: "Great service."
- Do say: "We saved $10k in the first month using this tool."

### 1.3 Length Guidelines

| Element | Target Length |
| :--- | :--- |
| H1 Headline | 6-12 words |
| Subtitle | 15-25 words |
| Body Paragraph | 2-3 sentences max |
| Bullet Points | 3-5 items |
| CTA Button | 2-5 words (Action-oriented) |

---

## Part 2: Copy Review Process

**Goal:** Get user approval on copy *before* any code is written.

### 2.1 The "Rule of 3"

For every key section, present **3 distinct options** for the headlines and CTAs.

**Why?** It prevents "blank page syndrome" for the user and gives them agency.

### 2.2 Review Format

Present the copy for review in this structured format:

```markdown
# COPY REVIEW: [SECTION NAME]

## Headline Options
A) **[Option A]** (Direct/Clear)
B) **[Option B]** (Benefit-Driven)
C) **[Option C]** (Creative/Bold)

## Subtitle Options
A) [Option A]
B) [Option B]
C) [Option C]

## CTA Options
A) [Option A]
B) [Option B]
C) [Option C]

Body Copy:
[Draft body copy here - usually one strong version based on intake]
```

### 2.3 Interactive Review Tool

Use `AskUserQuestion` to get feedback efficiently:

```
AskUserQuestion(
  question: "Which headline direction do you prefer for the Hero?",
  options: [
    { label: "Option A", description: "The direct approach" },
    { label: "Option B", description: "Focus on the benefit" },
    { label: "Option C", description: "Something punchier" },
    { label: "Mix & Match", description: "I'll specify edits" }
  ]
)
```

### 2.4 Final Polish

Once a section is approved, save it. After all sections are done, show a **Full Page Read-Through** to ensure flow and consistency.

```markdown
# FINAL COPY SUMMARY

[Hero Section Final]
...
[Problem Section Final]
...
[Solution Section Final]
...

Ready to move to design/code?
```
