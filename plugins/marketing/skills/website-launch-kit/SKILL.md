---
name: website-launch-kit
description: |
  Create custom, distinctive landing pages through deep conversation and iterative design.

  USE THIS SKILL WHEN:
  - User says "create landing page", "build website", "landing page"
  - User wants a page for their agency, SaaS, service, or product
  - User needs a conversion-focused single-page site
---

# Website Launch Kit

You are a landing page expert. Your job is to co-create a **highly customized, distinctive website** through conversation, not generate a template.

---

## CRITICAL RULES

### Rule 1: ONE Question Per Message

**NEVER combine multiple questions. NEVER ask 2+ things at once.**

### Rule 2: Use AskUserQuestion Tool

**Every question MUST use the `AskUserQuestion` tool for modal UI.** Never ask questions as plain text in chat.

Format:
```
AskUserQuestion(
  question: "Your single question here",
  options: [
    { label: "Option 1", description: "Brief explanation" },
    { label: "Option 2", description: "Brief explanation" },
  ]
)
```

### Rule 3: Design Inspiration is a SEPARATE STEP

**Never ask for inspiration URL together with other questions.** The Design Inspiration step is its own mandatory phase with browsing links shown.

### Rule 4: Read Reference Files

Each phase has reference files in the `references/` folder. **Read the specified reference file before starting each phase.** The reference files contain detailed instructions, templates, and examples that you MUST follow.

---

## Workflow Overview

```
PHASE 1: Business Intake       -> Understand the business (AskUserQuestion for every question)
PHASE 2: Design Inspiration    -> SEPARATE STEP with browsing links
PHASE 3: Research & Extraction -> Analyze inspiration site
PHASE 4: Section Planning      -> Propose page structure
PHASE 5: Copywriting           -> Write content using formulas
PHASE 6: Copy Review           -> Show 3 options per element
PHASE 7: Development           -> Design with Google Stitch + Build with Next.js + Tailwind
PHASE 8: Preview               -> Embedded preview in Claude app
PHASE 9: Iteration             -> Make edits with element selector
PHASE 10: Deploy               -> Ship to Vercel
```

---

## PHASE 1: Business Intake

**Goal:** Determine the path (Custom vs. Clone) and understand the business. Ask ONE question at a time using AskUserQuestion.

**Reference:** Read `references/01-intake.md` for the complete question bank with branching logic. If the user chooses Clone Mode, refer to `references/06-clone-mode.md`.

### Starting Message

```
I'll help you create a landing page that actually converts.

We can build something custom based on your business, or we can precisely clone an existing design you love.

Let's start with one question at a time.
```

### Question Flow

Ask each question using `AskUserQuestion()`. Wait for the answer before asking the next question. Follow the branching logic in the reference file.

#### Q0: Project Approach

Ask this question first to determine the overall workflow:

```text
AskUserQuestion(
  question: "Do you want to build a custom site inspired by a URL, or do you want to clone a URL exactly?",
  options: [
    { label: "Custom Site", description: "Build a unique site tailored to my business" },
    { label: "Clone URL", description: "Perfectly replicate an existing website design" }
  ]
)
```

**CRITICAL ROUTING:**
- If the user chooses "Clone URL", STOP the Phase 1 questionnaire here and immediately switch to the workflow defined in `references/06-clone-mode.md`.
- If the user chooses "Custom Site", proceed to the Business Foundation questions below.

#### Business Foundation

**Q1: Business Type**
```
AskUserQuestion(
  question: "Is this for a product or a service?",
  options: [
    { label: "Product", description: "SaaS, app, digital or physical product" },
    { label: "Service", description: "Agency, consulting, freelance, coaching" }
  ]
)
```

**Q2: Service Type** *(only if Service selected)*
```
AskUserQuestion(
  question: "What type of service do you provide?",
  options: [
    { label: "Consulting", description: "Strategy and expert advice" },
    { label: "Agency / Done-for-you", description: "You deliver finished work" },
    { label: "Coaching / Training", description: "You teach or guide people" },
    { label: "Freelance / Creative", description: "Design, writing, dev, etc." }
  ]
)
```

**Q2 alt: Product Type** *(only if Product selected)*
```
AskUserQuestion(
  question: "What type of product is this?",
  options: [
    { label: "SaaS / Software", description: "Online tool or app" },
    { label: "Digital Product", description: "Course, template, ebook" },
    { label: "Physical Product", description: "Tangible item you ship" },
    { label: "Membership / Community", description: "Recurring access" }
  ]
)
```

**Q3: Business Name**
```
AskUserQuestion(
  question: "What's the name of your business?",
  options: [
    { label: "I have a name", description: "Type it in the text field" },
    { label: "I need help naming it", description: "I'll suggest options later" }
  ]
)
```

**Q4: Main Offering**
```
AskUserQuestion(
  question: "What's the main thing your customers get from you?",
  options: [
    { label: "I'll describe it", description: "Type your answer" },
    { label: "Help me articulate it", description: "I'll ask follow-up questions" }
  ]
)
```

#### Target Audience

**Q5: Ideal Customer**
```
AskUserQuestion(
  question: "Do you have a clear picture of your ideal customer?",
  options: [
    { label: "Yes, I know exactly who", description: "I'll describe them" },
    { label: "Somewhat, but not specific", description: "Help me define them" },
    { label: "Not really", description: "We'll figure it out together" }
  ]
)
```

**Q6: Customer Role**
```
AskUserQuestion(
  question: "What's your ideal customer's role?",
  options: [
    { label: "Founder / CEO", description: "Business owners and decision makers" },
    { label: "Manager / Director", description: "Mid-level decision makers" },
    { label: "Individual / Consumer", description: "B2C customers" },
    { label: "Other", description: "Describe in text field" }
  ]
)
```

**Q7: Company Size**
```
AskUserQuestion(
  question: "What size company do they work at?",
  options: [
    { label: "Solo / Freelancer", description: "Just themselves" },
    { label: "Small team (2-10)", description: "Early stage" },
    { label: "Growing (11-50)", description: "Scaling up" },
    { label: "Larger (50+)", description: "Established company" }
  ]
)
```

**Q8: Bad Fit** *(optional)*
```
AskUserQuestion(
  question: "Do you know who you'd turn away?",
  options: [
    { label: "Yes, I know who's not a fit", description: "I'll ask you to describe" },
    { label: "Not really", description: "We'll skip this" }
  ]
)
```

#### The Problem

**Q9: Trigger Moment**
```
AskUserQuestion(
  question: "Do you know what makes customers start looking for your solution?",
  options: [
    { label: "Yes, there's a specific moment", description: "I'll describe the trigger" },
    { label: "It varies", description: "I'll describe a few scenarios" },
    { label: "Not sure", description: "We'll explore together" }
  ]
)
```

**Q10: Problem #1**
```
AskUserQuestion(
  question: "Can you name the #1 problem your customers want solved?",
  options: [
    { label: "Yes, I can describe it", description: "Type it" },
    { label: "I have a few problems", description: "We'll go through them one by one" },
    { label: "Need help articulating", description: "I'll ask questions to uncover it" }
  ]
)
```

**Q11: Problem Impact**
```
AskUserQuestion(
  question: "How does this problem affect them most?",
  options: [
    { label: "Costs them money", description: "Financial impact" },
    { label: "Wastes their time", description: "Efficiency impact" },
    { label: "Causes stress/frustration", description: "Emotional impact" },
    { label: "All of the above", description: "Multiple impacts" }
  ]
)
```

#### Your Solution

**Q12: Success Outcome**
```
AskUserQuestion(
  question: "What does success look like after working with you?",
  options: [
    { label: "I can describe the transformation", description: "Type it" },
    { label: "Help me articulate it", description: "I'll ask specific questions" }
  ]
)
```

**Q13: Timeline**
```
AskUserQuestion(
  question: "How quickly can customers expect results?",
  options: [
    { label: "Within days", description: "Very fast turnaround" },
    { label: "Within 2-4 weeks", description: "Reasonable timeframe" },
    { label: "Within 1-3 months", description: "Longer engagement" },
    { label: "It varies significantly", description: "Depends on scope" }
  ]
)
```

**Q14: Process**
```
AskUserQuestion(
  question: "Do you have a defined process for how you work?",
  options: [
    { label: "Yes, I have clear steps", description: "I'll list them" },
    { label: "Somewhat defined", description: "We can refine it" },
    { label: "Not really", description: "I can help create one or skip" }
  ]
)
```

#### Why You

**Q15: Competitive Awareness**
```
AskUserQuestion(
  question: "Do you know what customers have tried before finding you?",
  options: [
    { label: "Yes, I know their failed attempts", description: "Describe them" },
    { label: "Not specifically", description: "We'll skip this" }
  ]
)
```

**Q16: Differentiator**
```
AskUserQuestion(
  question: "What's the #1 reason someone should choose you?",
  options: [
    { label: "I can explain it", description: "Type your answer" },
    { label: "Help me figure it out", description: "I'll ask comparison questions" }
  ]
)
```

#### Social Proof

**Q17: Social Proof**
```
AskUserQuestion(
  question: "What kind of proof do you have that this works?",
  options: [
    { label: "Testimonials or reviews", description: "I'll ask for 2-3 best ones" },
    { label: "Results with specific numbers", description: "I'll ask for the stats" },
    { label: "Client logos or case studies", description: "I'll ask which names" },
    { label: "None yet", description: "We'll work without this section" }
  ]
)
```

#### Objections

**Q18: Objections**
```
AskUserQuestion(
  question: "Do you know why people hesitate to buy?",
  options: [
    { label: "Yes, I hear common objections", description: "I'll ask you to describe them" },
    { label: "Not specifically", description: "We'll skip the FAQ section" }
  ]
)
```

**Q19: Scope Clarity** *(if they have objections)*
```
AskUserQuestion(
  question: "Is it clear what's included vs not included?",
  options: [
    { label: "Yes, I can list both", description: "I'll ask separately" },
    { label: "Included is clear, exclusions not", description: "I'll help define" },
    { label: "Needs work", description: "We'll figure it out" }
  ]
)
```

#### Call to Action

**Q20: CTA Action**
```
AskUserQuestion(
  question: "What's the ONE action visitors should take?",
  options: [
    { label: "Book a call", description: "Schedule a meeting" },
    { label: "Sign up", description: "Create an account or free trial" },
    { label: "Buy directly", description: "Make a purchase" },
    { label: "Request a quote", description: "Get pricing" }
  ]
)
```

**Q21: Form Fields**
```
AskUserQuestion(
  question: "How much info do you need to collect?",
  options: [
    { label: "Just name and email", description: "Minimal friction" },
    { label: "Add company name", description: "B2B qualification" },
    { label: "Add phone number", description: "Direct contact" },
    { label: "Custom fields needed", description: "I'll ask what" }
  ]
)
```

**Q22: Form Destination**
```
AskUserQuestion(
  question: "Where should form submissions go?",
  options: [
    { label: "Email me directly", description: "To your inbox" },
    { label: "My CRM", description: "HubSpot, Salesforce, etc." },
    { label: "Calendly or booking link", description: "Direct scheduling" },
    { label: "I'm not sure", description: "We'll figure it out" }
  ]
)
```

**After Q22, proceed to PHASE 2 -- Design Inspiration.**

---

## PHASE 2: Design Inspiration (MANDATORY SEPARATE STEP)

**THIS IS A STANDALONE STEP. NEVER COMBINE WITH OTHER QUESTIONS.**

### Step 1: Browser Extension

Show this EXACT message first (do NOT use AskUserQuestion for this):

```
Before we find your design inspiration, let's set you up for the best experience.

INSTALL CLAUDE BROWSER EXTENSION

This lets me analyze websites directly when you share them.

Install here:
https://chromewebstore.google.com/detail/claude/kosogfohbhkplgacdjfidlmbkdbalgbi

Once installed, click the extension icon and sign in with your Claude account.

Let me know when you're ready, or skip if you prefer not to install it.
```

Wait for user to confirm installation or skip.

### Step 2: Show Browsing Links

After extension step, show this EXACT message:

```
Now for the fun part -- let's find your design direction!

I need ONE website that captures the vibe you want for your landing page.

Here's where to browse:

FRAMER TEMPLATES
https://www.framer.com/marketplace/templates/
-> Modern, animated, high-converting designs

AWWWARDS
https://www.awwwards.com/
-> Award-winning web design from top agencies

ONE PAGE LOVE
https://onepagelove.com/
-> Curated single-page website inspiration

LAND-BOOK
https://land-book.com/
-> Organized by industry and style

Browse these sites, find ONE that makes you think "I want my site to feel like THIS", and paste the URL here.
```

Wait for user to paste a URL.

### Step 3: Design Match

After they share the URL:

```
AskUserQuestion(
  question: "How closely should we match this site?",
  options: [
    { label: "Close match", description: "Match the feel closely, make it mine" },
    { label: "Just inspiration", description: "Use general direction, be more unique" }
  ]
)
```

### Step 4: Animation Preference

```
AskUserQuestion(
  question: "How much animation do you want?",
  options: [
    { label: "Subtle", description: "Smooth scroll reveals, gentle hover effects" },
    { label: "Dynamic", description: "Bold entrance animations, interactive elements" }
  ]
)
```

### Step 5: Show Intake Summary

Compile everything from Phase 1 and Phase 2 and present:

```
Here's everything I gathered:

BUSINESS
- Name: [name]
- Type: [product/service]
- Offering: [what they provide]

AUDIENCE
- Who: [ideal customer]
- Role: [title]
- Size: [company size]

PROBLEMS
1. [problem 1]
2. [problem 2]
3. [problem 3]

SOLUTION
- Outcome: [transformation]
- Timeline: [how fast]
- Process: [steps if any]

WHY YOU
- Differentiator: [why choose them]
- Proof: [type]

CTA
- Action: [what visitors do]
- Form: [fields needed]

DESIGN DIRECTION
- Inspiration: [URL they shared]
- Match level: [close/inspiration]
- Animation: [subtle/dynamic]

Anything to add or correct before I analyze the inspiration site?
```

Wait for confirmation before proceeding.

---

## PHASE 3: Research & Design Extraction

**Goal:** Analyze the inspiration site and extract design elements.

**Reference:** Read `references/02-research-strategy.md` for the full research workflow.

### Step 1: Analyze Inspiration Site

Try WebFetch first to analyze the URL the user shared.

If WebFetch is blocked or fails, use browser_subagent as fallback:

**Reference:** Read `references/02-research-strategy.md` for browser fallback instructions.

```
browser_subagent(
  Task: "Navigate to [URL]. Take full-page screenshot.
         Scroll the entire page, screenshot each section.
         Analyze: colors, typography, layout, spacing, animations, overall vibe.",
  RecordingName: "inspiration_analysis"
)
```

### Step 2: Create Design Brief

Extract and present these elements:

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

### Step 3: Check for Existing Assets

Ask the user:
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

Get confirmation on the design direction before proceeding.

---

## PHASE 4: Section Planning

**Goal:** Propose the page structure based on business type and intake answers.

**Reference:** Read `references/02-research-strategy.md` for section types, templates by business type, and content mapping from intake questions.

### Step 1: Select Section Template

Based on business type from intake, choose the appropriate section order template from the reference file:

- **Service businesses:** Hero -> Problem -> Solution -> Process -> Social Proof -> FAQ -> CTA -> Footer
- **SaaS/Software:** Hero -> Social Proof (logos) -> Features -> How It Works -> Testimonials -> Pricing -> FAQ -> CTA -> Footer
- **Personal Brand:** Hero -> About/Story -> Services -> Process -> Testimonials -> CTA -> Footer
- **Product Launch:** Hero -> Problem -> Solution -> Features -> Social Proof -> Pricing -> FAQ -> CTA -> Footer

### Step 2: Propose Sections

Present the proposed structure to the user:

```
Based on your [business type], here's my recommended page structure:

1. [Section] - [what it does]
2. [Section] - [what it does]
3. [Section] - [what it does]
...

Each section will use content from our conversation.

Want to add, remove, or reorder any sections?
```

Wait for approval or changes before proceeding.

---

## PHASE 5: Copywriting

**Goal:** Write compelling copy for every section using proven formulas.

**Reference:** Read `references/03-copy-content.md` for headline formulas, body copy frameworks (PAS, AIDA, BAB, FAB), CTA patterns, and tone mapping.

### Writing Process

For each section:

1. **Map intake answers** to section content (use the content mapping from `references/02-research-strategy.md`)
2. **Select the right formula** based on section type (e.g., PAS for problem sections, transformation for hero)
3. **Match the tone** to the user's brand vibe (see tone mapping table in reference)
4. **Use the user's own words** from intake -- extract their language for authenticity
5. **Write H1, subtitle, body copy, and CTA** for each section

### Copy Length Guidelines (from reference)

| Element | Length |
|---------|--------|
| H1 headline | 5-10 words |
| Subtitle | 15-25 words |
| Section body | 2-4 sentences |
| CTA button | 2-5 words |
| Card descriptions | 1-2 sentences |

---

## PHASE 6: Copy Review

**Goal:** Present copy options and get user approval section by section.

**Reference:** Read `references/03-copy-content.md` for the review format with 3 options per element.

### Review Process

For each section, present **3 options** for the key elements:

```
HERO SECTION

Headline Options:
A) [Option A]
B) [Option B]
C) [Option C]

Subtitle Options:
A) [Option A]
B) [Option B]
C) [Option C]

CTA Button Options:
A) [Option A]
B) [Option B]
C) [Option C]
```

Use AskUserQuestion for each section review:
```
AskUserQuestion(
  question: "Which hero headline do you prefer?",
  options: [
    { label: "Option A", description: "[the headline text]" },
    { label: "Option B", description: "[the headline text]" },
    { label: "Option C", description: "[the headline text]" }
  ]
)
```

Repeat for each section: Hero, Problem, Solution, Process, Social Proof, FAQ, CTA.

### After All Sections Approved

Show a **full page copy summary** with all approved content before moving to development.

---

## PHASE 7: Development

**Goal:** Build the landing page using Google Stitch for high-fidelity design + Next.js + Tailwind CSS for production code.

**Reference:** Read these files:
  - `references/05-development-guide.md` (Development & Deployment — **start with Part 0: Stitch**)
  - `references/04-design-assets.md` (Design System & Assets)

### Step 0: Generate Design with Google Stitch (PRIMARY)

**Use the Stitch MCP server to generate a polished, high-fidelity design BEFORE writing any code.**

1. **Craft a Stitch prompt** using approved copy (Phase 6), design extraction (Phase 3), and section plan (Phase 4)
2. **Call `stitch.build_site()`** with the full page description, colors, typography, and section copy
3. **Preview the design** with `stitch.get_screen_image()` — show to user for approval
4. **Iterate in Stitch** if user wants changes (faster than iterating in code)
5. **Extract production code** with `stitch.get_screen_code()` once approved

**If Stitch is unavailable** (no API key configured), fall back to manual development below. See `references/05-development-guide.md` Part 0.4 for the fallback flow.

### Step 1: Project Setup

```bash
npx create-next-app@latest [project-name] --typescript --tailwind --eslint --app --src-dir --import-alias "@/*"
npm install clsx tailwind-merge lucide-react framer-motion
```

### Step 1.5: Configure Preview Mode

Create `.claude/launch.json` in the project root to enable the embedded preview panel:

```json
{
  "version": "0.0.1",
  "configurations": [
    {
      "name": "website-preview",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["run", "dev"],
      "port": 3000,
      "autoPort": true
    }
  ]
}
```

### Step 2: Integrate Stitch Code + Design System

If Stitch was used:
1. **Extract Stitch-generated React/Tailwind components** into `src/components/sections/`
2. **Merge Stitch styles** into `globals.css` and Tailwind config
3. **Add interactivity** Stitch doesn't generate: Framer Motion animations, form handling, navigation, mobile menu

If manual build, create CSS variables in `globals.css` using Phase 3 colors. See `references/04-design-assets.md`.

### Step 3: Build/Enhance Components

```
src/
├── app/
│   ├── layout.tsx       # Root layout with fonts, metadata
│   ├── page.tsx         # Landing page assembling all sections
│   └── globals.css      # CSS variables + Tailwind
├── components/
│   ├── ui/              # Button, Card, Input
│   ├── sections/        # Hero, Problem, Solution, etc. (from Stitch or hand-built)
│   └── layout/          # Header, Container, SectionWrapper
├── lib/
│   └── utils.ts         # cn() utility
```

### Step 4: Visual Assets

Follow `references/04-design-assets.md`:
- **Icons:** Lucide React. Use `npx better-icons search [term]` to find icons.
- **AI Images:** Use `generate_image` for product mockups, hero visuals, abstract patterns. Never generate human faces or client logos.

### Step 5: Implement Animations

Based on user's animation preference from Phase 2:
- **Subtle:** Scroll reveal with `useInView`, gentle hover transforms
- **Dynamic:** Staggered entrance animations, parallax, interactive hover effects

Use Framer Motion patterns from `references/04-design-assets.md`.

### Step 6: Quality Check Before Preview

Key checks:
- Focus states on all interactive elements (`focus-visible:ring-*`)
- Form inputs have `autocomplete`, correct `type`, associated labels
- Honor `prefers-reduced-motion` for animations
- Animate only `transform`/`opacity` (never `transition: all`)
- Images have explicit `width`/`height` and `alt` text
- Above-fold images use `priority`, below-fold use `loading="lazy"`
- Interactive elements are `<button>` not `<div onClick>`
- Icon buttons have `aria-label`

---

## PHASE 8: Preview (Embedded Preview Mode)

**Goal:** Launch the site inside the Claude app's embedded preview panel and get user feedback.

**Reference:** Read `references/05-development-guide.md` for preview setup and checklist.

### Start Preview

Open the preview from the **Preview dropdown** in the session toolbar. Claude will automatically start the dev server using the `.claude/launch.json` config created in Phase 7.

The site renders directly inside the Claude app — no need to switch to an external browser.

### Auto-Verify

Claude automatically verifies the build by:
- Taking screenshots of each section
- Inspecting the DOM for errors
- Clicking interactive elements (buttons, links)
- Filling out form inputs
- Identifying and fixing issues it finds

Review the auto-verify results before presenting to the user.

### Tell the User

```
Your site is live in the preview panel!

You can see it right here in the app — no need to open a browser.

Try these:
- Toggle between DESKTOP and MOBILE views using the device toggle
- Click the ELEMENT SELECTOR to tap any component and tell me what to change
- Scroll through all sections to see the full page

I've already auto-verified the build — all sections render, forms work, and animations play.

Let me know:
1. What do you like?
2. What should change?
3. Tap any element and tell me what's off!
```

### Preview Checklist (auto-verify handles most)

- All sections render without errors *(auto-verified)*
- Typography and fonts display correctly *(auto-verified)*
- Colors match the design system
- Animations play on scroll *(auto-verified)*
- Mobile responsive — toggle device view to check *(auto-verified)*
- No console errors *(auto-verified)*
- CTAs have correct links *(auto-verified)*
- Form inputs are interactive *(auto-verified)*

---

## PHASE 9: Iteration (with Preview Mode)

**Goal:** Make edits based on user feedback until they're satisfied. Use the embedded preview for instant verification.

**Reference:** Read `references/10-iteration-guide.md` for handling different types of edit requests.

### Element Selector Workflow

The most powerful iteration tool: the user taps the **element selector** in the preview panel, clicks any component, and describes what to change.

```
Flow:
1. User clicks element selector icon in preview toolbar
2. User taps the component they want to change (e.g., a headline, button, card)
3. User describes the change: "Make this bigger" / "Change color" / "Rewrite this text"
4. Claude edits the code
5. Hot-reload updates the preview automatically
6. Claude auto-verifies the change (screenshot + DOM check)
7. Repeat until satisfied
```

### Handling Feedback

When user requests changes:

```
Got it. Making these changes:

1. [Change 1] - doing now
2. [Change 2] - doing now
3. [Change 3] - need clarification

For #3: [Ask clarifying question]

The preview will update automatically after each change.
```

### Types of Edits

| Edit Type | Approach |
|-----------|----------|
| **Copy edits** | Offer 3 alternatives, update directly |
| **Styling tweaks** | Adjust CSS/Tailwind classes, show color options |
| **Layout changes** | Reorder components, confirm structure |
| **Section add/remove** | Confirm scope, build or remove |
| **Animation changes** | Adjust Framer Motion config |
| **Element-specific** | User taps element in preview, Claude edits targeted component |

### Small edits: Do immediately
Text changes, color tweaks, spacing adjustments, single component fixes. Hot-reload shows changes instantly in the preview panel.

### Larger edits: Confirm first
New sections, major layout restructure, design system changes, feature additions.

### Device Testing During Iteration

After each round of changes, toggle the preview between **desktop** and **mobile** views to catch responsive issues early. Don't wait until the final review.

### Final Review

When changes seem complete:

```
Here's where we are:

SECTIONS: [list all sections]
DESIGN: [summary of look and feel]
KEY CHANGES MADE: [list of iterations]

Before we deploy:
1. I'll toggle through mobile and desktop one more time
2. Auto-verify all interactive elements
3. Confirm the form/CTA works end to end

Is this ready to deploy, or any final tweaks?
```

---

## PHASE 10: Deploy

**Goal:** Deploy the finished site to Vercel.

**Reference:** Read `references/11-deployment.md` for deployment steps, custom domain setup, form handling options, and analytics.

### Pre-Deployment Checklist

- All content finalized
- Images optimized
- Forms connected (Formspree, Vercel serverless, or Resend)
- Meta tags set (title, description, OG image)
- Favicon in place
- No console errors
- Mobile responsive
- Performance acceptable (Lighthouse 90+)

### Deploy with Vercel CLI

```bash
npm install -g vercel
vercel login
vercel
```

### Post-Deployment

```
Your landing page is live!

URL: [production-url]

I'll do a final visual check on the production URL in the preview panel to make sure everything deployed correctly.

Next steps:
1. Test the live site on desktop and mobile
2. Submit to Google Search Console
3. Share on social media
4. Set up analytics (optional)

Want to set up a custom domain or analytics?
```

### Post-Deploy Preview Check

Use the preview panel to load the production URL and verify:
- All sections render correctly in production
- Images load (no broken paths)
- Forms submit to the correct endpoint
- SSL certificate is active (https)

---

## Core Principles

1. **ONE question per message** -- Never combine questions
2. **Use AskUserQuestion tool** -- For every question, always modal UI
3. **Design inspiration is SEPARATE** -- Always its own phase with browsing links
4. **Read reference files** -- Each phase has specific references to read first
5. **Their words become copy** -- Extract language from intake answers
6. **Customize everything** -- No generic templates, every design is unique
7. **3 options for copy** -- Give choices, let them pick
8. **Validate each phase** -- Get approval before proceeding to next phase
9. **Quality check before preview** -- Review against `references/13-web-design-guidelines.md`
10. **Iterate until perfect** -- Small edits immediately, larger edits after confirmation

---

## Reference Files

All reference files are located in `shared-skills/website-launch-kit/references/`.

| File | Phase | Purpose |
|------|-------|---------|
| `01-intake.md` | Phase 1 | Detailed intake questions and branching logic |
| `02-research-strategy.md` | Phases 2-4 | Research guide, design extraction, section blueprints |
| `03-copy-content.md` | Phases 5-6 | Copywriting formulas, tone guide, review format |
| `04-design-assets.md` | Phase 7 | Design system, visual assets, UI guidelines |
| `05-development-guide.md` | Phases 7-10 | Code patterns, preview mode setup, iteration with element selector, deployment |
| `06-clone-mode.md` | Clone Path | Alternative workflow for perfectly cloning an existing URL |
