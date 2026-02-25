# Phase 8-10: Development, Local Preview & Deployment

This file covers the end-to-end technical workflow: setup, coding, previewing, and shipping.

---

## Part 1: Project Setup

**Goal:** Initialize a high-performance Next.js project.

### 1.1 Initialization Command

Use the `nano-banana` server to create the project.

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

### 1.4 Folder Structure

Maintain this clean architecture:

```
src/
├── app/
│   ├── layout.tsx       # Global fonts, metadata
│   ├── page.tsx         # Main landing page
│   └── globals.css      # CSS variables (from Phase 7)
├── components/
│   ├── ui/              # Primitive components (Button, Card)
│   ├── sections/        # Page sections (Hero, Features)
│   └── layout/          # Navbar, Footer
└── lib/
    └── utils.ts         # cn() helper
```

---

## Part 2: Component Patterns

**Goal:** Build modular, responsive, and animated components.

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

Use `framer-motion` for scroll reveals.

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
