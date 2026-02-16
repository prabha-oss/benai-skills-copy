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

### 1.3 Folder Structure

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

## Part 3: Local Preview

**Goal:** Verify the site locally before user review.

### 3.1 Running the Server

1.  **Start formatting:** `npm run lint -- --fix`
2.  **Start server:** `npm run dev` (usually localhost:3000)
3.  **Verify:** Check console for errors.

### 3.2 Visual QA Checklist

- [ ] **Responsiveness:** Check Mobile (375px), Tablet (768px), Desktop (1440px).
- [ ] **Images:** Are they loading? Do they have alt text?
- [ ] **Links:** Do all buttons and nav links work?
- [ ] **Console:** Any red errors? (Hydration mismatches, 404s).

---

## Part 4: Iteration Loop

**Goal:** Refine based on user feedback.

### 4.1 The Loop

1.  **Show Preview:** "I've built the Hero and Problem sections. Take a look at [URL]."
2.  **Gather Feedback:** "What do you think of the spacing? The colors?"
3.  **Implement Fixes:** Edit code -> Save -> Hot Reload.
4.  **Repeat:** Until approved.

### 4.2 Handling "Vague" Feedback

- *User:* "Make it pop more."
- *Dev Action:* Increase contrast, add shadows, or speed up animations.
- *User:* "It feels too crowded."
- *Dev Action:* Increase `py-` padding and `gap-` classes.

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
