# Phase 8-10: Development, Local Preview & Deployment

This file covers the end-to-end technical workflow: setup, coding, previewing, and shipping.

---

## Part 0: Design Generation with Google Stitch (PRIMARY METHOD)

**Goal:** Generate high-fidelity UI designs before writing any code. Stitch produces better-looking designs than hand-coding from scratch.

### Prerequisites

The `stitch` MCP server must be configured in the **project root** `.mcp.json` (not in a plugin subdirectory — Claude Code only reads root-level MCP configs).

**Option A: Google OAuth (Recommended)**

More reliable — some Stitch endpoints reject API keys. Run the init wizard first:

```bash
npx @_davideast/stitch-mcp init
```

This opens a browser for Google login, sets up a GCP project, and enables the Stitch API. Then configure `.mcp.json`:

```json
{
  "stitch": {
    "command": "npx",
    "args": ["-y", "@_davideast/stitch-mcp"],
    "env": {
      "STITCH_USE_SYSTEM_GCLOUD": "1",
      "GOOGLE_CLOUD_PROJECT": "your-gcp-project-id"
    }
  }
}
```

**Option B: API Key**

Get your API key from https://stitch.withgoogle.com (Settings → API Keys). Free tier: 350 generations/month.

```json
{
  "stitch": {
    "command": "npx",
    "args": ["-y", "@_davideast/stitch-mcp"],
    "env": {
      "STITCH_API_KEY": "your-api-key"
    }
  }
}
```

**Note:** API key auth has known reliability issues — OAuth is preferred.

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

If the Stitch MCP server is not configured or authentication is missing, fall back to the manual development workflow in Part 1 below. Ask the user:

```
AskUserQuestion(
  question: "Google Stitch can generate a polished design first, but it needs authentication. How would you like to proceed?",
  options: [
    { label: "Set up Stitch (Google OAuth)", description: "I'll run npx @_davideast/stitch-mcp init to authenticate with Google" },
    { label: "Set up Stitch (API key)", description: "I'll get an API key from stitch.withgoogle.com" },
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

## Part 3: Preview Mode

**Goal:** Verify the site in a browser before presenting to the user.

### 3.1 Starting the Preview

1.  **Lint first:** `npm run lint -- --fix`
2.  **Start the dev server** in the background: `npm run dev &`
3.  **Wait for the server** to be ready (2-3 seconds)
4.  **Open the browser automatically:**
    - macOS: `open http://localhost:3000`
    - Linux: `xdg-open http://localhost:3000`

**Claude Code Desktop users:** If running in the Desktop app, the embedded preview panel will auto-start the server from `.claude/launch.json` instead — no manual steps needed.

### 3.2 Auto-Verify (Desktop Only)

When running in Claude Code Desktop, Claude automatically verifies the build:
- Takes screenshots of each visible section
- Inspects the DOM for errors and console warnings
- Clicks interactive elements (buttons, links, nav items)
- Fills out form inputs to test validation
- Reports any issues found

**In CLI mode:** Claude cannot auto-verify visually. Instead, run `npm run build` to catch compile errors and check the browser manually.

### 3.3 Visual QA Checklist

- [ ] **Colors:** Match the design system from Phase 3
- [ ] **Brand feel:** Matches the inspiration site vibe
- [ ] **Copy:** Matches approved copy from Phase 6
- [ ] **Responsiveness:** Resize the browser window to check mobile layout
- [ ] **No console errors:** Check browser DevTools console
- [ ] **Forms work:** Fill out and submit test data
- [ ] **Links/CTAs:** Click all buttons and navigation items

---

## Part 4: Iteration Loop

**Goal:** Refine based on user feedback.

### 4.1 The Loop

1.  **Present preview:** The site is open in the browser (auto-opened or via preview panel)
2.  **Gather feedback:** User describes changes — reference specific sections by name (e.g., "the hero headline", "the pricing card")
3.  **Implement fixes:** Edit code → save → hot-reload updates the browser automatically
4.  **Verify:** Check the browser to confirm the change looks correct
5.  **Repeat:** Until approved

### 4.2 Handling "Vague" Feedback

- *User:* "Make it pop more."
- *Dev Action:* Increase contrast, add shadows, or speed up animations.
- *User:* "It feels too crowded."
- *Dev Action:* Increase `py-` padding and `gap-` classes.

### 4.3 Device Testing

After each round of changes, resize the browser window or use browser DevTools device emulation to catch responsive issues. Don't wait for the final review.

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
