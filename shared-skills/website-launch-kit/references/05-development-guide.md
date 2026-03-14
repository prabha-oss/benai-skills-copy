# Phase 8-10: Development, Local Preview & Deployment

This file covers the end-to-end technical workflow: setup, coding, previewing, and shipping.

---

## Part 0: Design Generation with Google Stitch (PRIMARY METHOD)

**Goal:** Generate high-fidelity UI designs before writing any code. Stitch produces better-looking designs than hand-coding from scratch.

### Prerequisites

The `stitch` MCP server must be configured in `.mcp.json` with a valid `STITCH_API_KEY`. Get your API key from https://stitch.withgoogle.com (Settings → API Keys). Free tier: 350 generations/month.

### 0.1 Generate the Full Page Design

Using the approved copy (Phase 6), design extraction (Phase 3), and section plan (Phase 4), craft a detailed Stitch prompt:

```
Stitch Prompt Template:
"Create a modern landing page for [business name], a [business type] that [main offering].

Design direction: [vibe words from Phase 3] aesthetic.
Color palette: Primary [hex], Secondary [hex], Background [hex], Text [hex].
Typography: [heading font] for headings, [body font] for body text.
Layout: [centered/full-width/asymmetric] with [tight/normal/generous] spacing.
Animation feel: [subtle/dynamic].

Sections (in order):
1. HERO: [headline] / [subtitle] / CTA: [button text]
2. [SECTION]: [headline] / [body copy summary]
3. [SECTION]: [headline] / [body copy summary]
... (include all approved sections with their copy)

Style reference: Similar to [inspiration URL].
Make it conversion-focused with clear visual hierarchy."
```

**Call the Stitch MCP tool:**
```
stitch.build_site(prompt: "<your prompt above>")
```

### 0.2 Review Generated Screens

After Stitch generates the design:

1. **Get the visual preview:**
   ```
   stitch.get_screen_image(screen_id: "<id>")
   ```
   Show the generated design to the user for approval.

2. **Iterate on the design in Stitch** if needed:
   - Adjust colors, layout, spacing, or copy
   - Regenerate specific screens
   - Try different layout variants

3. **Get user approval** before extracting code:
   ```
   AskUserQuestion(
     question: "Here's the generated design. How does it look?",
     options: [
       { label: "Love it, let's build it", description: "Extract code and set up the project" },
       { label: "Needs tweaks", description: "I'll describe what to change" },
       { label: "Try a different direction", description: "Regenerate with different parameters" }
     ]
   )
   ```

### 0.3 Extract Production Code

Once the user approves the design:

```
stitch.get_screen_code(screen_id: "<id>")
```

This returns **React + Tailwind CSS** code that matches the high-fidelity design. Use this as the foundation for the Next.js project instead of hand-coding from scratch.

### 0.4 When Stitch Is Unavailable

If the Stitch MCP server is not configured or the API key is missing, fall back to the manual development workflow in Part 1 below. Ask the user:

```
AskUserQuestion(
  question: "Google Stitch can generate a polished design first, but it needs an API key. How would you like to proceed?",
  options: [
    { label: "Set up Stitch", description: "I'll get an API key from stitch.withgoogle.com" },
    { label: "Skip, build manually", description: "Code the design directly with Next.js + Tailwind" }
  ]
)
```

---

## Part 1: Project Setup

**Goal:** Initialize a high-performance Next.js project and integrate Stitch-generated code.

### 1.1 Initialization Command

```bash
npx -y create-next-app@latest [project-name] --typescript --tailwind --eslint
# Select: Yes (src dir), Yes (App Router), No (Turbo)
```

### 1.2 Dependencies

Install essential libraries immediately:

```bash
npm install framer-motion lucide-react clsx tailwind-merge
```

### 1.3 Configure Preview Mode

Create `.claude/launch.json` in the project root so the embedded preview panel auto-detects the dev server:

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

**Key fields:**
- `autoPort: true` — if port 3000 is busy, Claude auto-picks a free port
- `runtimeExecutable` / `runtimeArgs` — adjust if using `yarn dev` or `pnpm dev`

### 1.4 Integrate Stitch Code

If Stitch was used (Part 0):

1. **Extract components** from the Stitch-generated code into the project structure
2. **Map Stitch output to Next.js:**
   - Stitch HTML/React → `src/components/sections/` (one file per section)
   - Stitch styles → merge into `globals.css` and Tailwind config
   - Stitch assets → download and place in `public/`
3. **Add interactivity** that Stitch doesn't generate:
   - Framer Motion animations (based on Phase 2 preference)
   - Form handling and submission logic
   - Navigation scroll behavior
   - Mobile menu toggle

If Stitch was NOT used, build components manually following Part 2 below.

### 1.5 Folder Structure

Maintain this clean architecture:

```
src/
├── app/
│   ├── layout.tsx       # Global fonts, metadata
│   ├── page.tsx         # Main landing page
│   └── globals.css      # CSS variables (from Phase 7)
├── components/
│   ├── ui/              # Primitive components (Button, Card)
│   ├── sections/        # Page sections (Hero, Features) — from Stitch or hand-built
│   └── layout/          # Navbar, Footer
└── lib/
    └── utils.ts         # cn() helper
```

---

## Part 2: Component Patterns

**Goal:** Build modular, responsive, and animated components. When Stitch code is available, use it as the base and enhance with these patterns.

### 2.1 The `cn()` Helper

Always add this utility for class merging:

```typescript
// src/lib/utils.ts
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
```

### 2.2 Section Wrapper Pattern

Wrap every section for consistent spacing and max-width.

```typescript
export function Section({ children, className, id }: SectionProps) {
  return (
    <section id={id} className={cn("py-20 md:py-32", className)}>
      <div className="container px-4 md:px-6 mx-auto">
        {children}
      </div>
    </section>
  )
}
```

### 2.3 Animation Pattern

Use `framer-motion` for scroll reveals. Add these to Stitch-generated components that lack animation.

```typescript
/* Client Component */
"use client"
import { motion } from "framer-motion"

export function FadeIn({ children }: { children: React.ReactNode }) {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      whileInView={{ opacity: 1, y: 0 }}
      viewport={{ once: true }}
      transition={{ duration: 0.5 }}
    >
      {children}
    </motion.div>
  )
}
```

---

## Part 3: Preview Mode (Embedded Browser)

**Goal:** Verify the site in the Claude app's embedded preview panel before presenting to the user.

### 3.1 Starting the Preview

1.  **Lint first:** `npm run lint -- --fix`
2.  **Open preview:** Click the **Preview dropdown** in the session toolbar, or let Claude auto-start the server from `.claude/launch.json`
3.  The site renders in the embedded browser — no external browser needed

### 3.2 Auto-Verify

Claude automatically verifies the build:
- Takes screenshots of each visible section
- Inspects the DOM for errors and console warnings
- Clicks interactive elements (buttons, links, nav items)
- Fills out form inputs to test validation
- Reports any issues found

### 3.3 Preview Panel Features

| Feature | What it does |
|---------|--------------|
| **Device toggle** | Switch between desktop and mobile views |
| **Element selector** | Click any component to reference it in chat |
| **Session persistence** | Cookies/local storage survive server restarts |
| **Auto-verify** | Claude tests the page after every code change |

### 3.4 Visual QA Checklist

Most items are covered by auto-verify. Manually confirm:
- [ ] **Colors:** Match the design system from Phase 3
- [ ] **Brand feel:** Matches the inspiration site vibe
- [ ] **Copy:** Matches approved copy from Phase 6
- [ ] **Responsiveness:** Toggle device view — check mobile layout

---

## Part 4: Iteration Loop (with Preview Mode)

**Goal:** Refine based on user feedback using the embedded preview.

### 4.1 The Loop

1.  **Present preview:** The site is already visible in the preview panel
2.  **Gather feedback:** User describes changes or uses the **element selector** to tap a component
3.  **Implement fixes:** Edit code → save → hot-reload updates the preview automatically
4.  **Auto-verify:** Claude checks the change (screenshot + DOM inspection)
5.  **Repeat:** Until approved

### 4.2 Element Selector Workflow

The fastest way to iterate:
1. User clicks the **element selector** icon in the preview toolbar
2. Taps the specific component (headline, button, card, etc.)
3. Describes the change in chat
4. Claude edits → hot-reload → auto-verify → done

### 4.3 Handling "Vague" Feedback

- *User:* "Make it pop more."
- *Dev Action:* Increase contrast, add shadows, or speed up animations.
- *User:* "It feels too crowded."
- *Dev Action:* Increase `py-` padding and `gap-` classes.

### 4.4 Device Testing

After each round of changes, toggle the preview between desktop and mobile views. Don't wait for the final review to catch responsive issues.

---

## Part 5: Deployment

**Goal:** Ship to production.

### 5.1 Vercel Deployment (Recommended)

1.  **Login:** `npx vercel login`
2.  **Deploy:** `npx vercel`
    - Accept defaults for all prompts.
3.  **Prod Deploy:** `npx vercel --prod` (after testing preview).

### 5.2 Netlify Alternative

1.  **Build:** `npm run build`
2.  **Deploy:** `npx netlify-cli deploy --dir=out --prod`

### 5.3 Final Handover

Provide the user:
1.  **Live URL:** (e.g., `https://project.vercel.app`)
2.  **Repo Link:** (if pushed to GitHub)
3.  **Next Steps:** "Connect your custom domain in Vercel settings."
