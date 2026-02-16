# Phase 7: Design System & Visual Assets

This file defines the design system, asset generation, and UI guidelines for the website.

---

## Part 1: Design System Setup

**Goal:** Translate the Design Brief (from Phase 2) into code variables.

### 1.1 CSS Variables (`globals.css`)

Generate these based on the extracted colors and typography.

```css
:root {
  /* Colors - Derived from Inspiration */
  --primary: [hex];
  --primary-foreground: [hex];
  --secondary: [hex];
  --secondary-foreground: [hex];
  --accent: [hex];
  --accent-foreground: [hex];
  --background: [hex];
  --foreground: [hex];
  
  /* Radii - Match vibe (0px for sharp/bold, 0.5rem for friendly/soft) */
  --radius: 0.5rem;
  
  /* Fonts - Loaded via Next.js Font Optimization */
  --font-heading: var(--font-inter);
  --font-body: var(--font-roboto);
}
```

### 1.2 Tailwind Configuration

Extend `tailwind.config.ts`:

```typescript
theme: {
  extend: {
    colors: {
      primary: "var(--primary)",
      // ... map all usage
    },
    fontFamily: {
      heading: ["var(--font-heading)"],
      body: ["var(--font-body)"],
    },
    animation: {
      "fade-in": "fadeIn 0.5s ease-out",
      "slide-up": "slideUp 0.5s ease-out",
    }
  }
}
```

---

## Part 2: Visual Assets

**Goal:** Create or source high-quality visuals. **No placeholders allowed.**

### 2.1 Icons (`lucide-react`)

Use `lucide-react` for all UI icons.
- **Search:** `npx better-icons search [keyword]`
- **Consistency:** Use consistent stroke width (usually 2px).
- **Size:** 16px (sm), 24px (md), 32px (lg), 48px (xl).

### 2.2 AI Image Generation

Use `generate_image` tool for specific assets.

**Rules:**
1. **No Faces:** Do not generate realistic human faces (avoid uncanny valley).
2. **Abstract/Geometric:** Best for SaaS/Tech backgrounds.
3. **Product Mockups:** Generate generic device frames with UI-like abstract content.
4. **Style Consistency:** Match the "Vibe" from Phase 2.

**Prompts:**
- *Abstract:* "Abstract gradient mesh, subtle motion blur, brand colors [hex], minimal, 4k"
- *Mockup:* "Clean laptop screen mockup, isometric view, glass morphism UI elements, floating 3D, minimal background"
- *Texture:* "Noise texture, subtle grain, monochromatic, high contrast"

### 2.3 Image Optimization

- **Format:** WebP for complex images, SVG for vectors.
- **Loading:** `priority` for Hero images, `loading="lazy"` for everything else.
- **Alt Text:** Descriptive for accessibility.

---

## Part 3: UI/UX Guidelines

**Goal:** Ensure the site feels professional and polished.

### 3.1 Design Principles

| Principle | Rule |
| :--- | :--- |
| **Hierarchy** | H1 > H2 > H3. Size disparity should be obvious. |
| **Breathing Room** | Minimum 80px padding between sections on desktop. |
| **Consistency** | Use the same button style for primary actions. |
| **Feedback** | All interactive elements must have hover/focus states. |

### 3.2 Animation Guidelines

Match the "Animation Level" from Phase 2.

#### Subtle (Professional/Trust)
- **Scroll Reveal:** Elements fade in + slide up (20px) as they enter viewport.
- **Hover:** Slight lift (-2px) or shadow increase.
- **Transitions:** default 200ms ease-out.

#### Dynamic (Creative/Bold)
- **Staggered Entrance:** Lists/grids animate items one by one.
- **Parallax:** Background moves slower than foreground.
- **Hover:** Scale up, color shifts, border draws.

### 3.3 Accessibility Checklist
- [ ] Contrast ratio > 4.5:1 for text
- [ ] Interactive elements minimum 44x44px target
- [ ] Focus rings visible on keyboard navigation
- [ ] Images have alt text
- [ ] Semantic HTML (`<main>`, `<section>`, `<nav>`)

---

## Part 4: Component Implementation

### 4.1 Button Component
- Variants: `default` (primary), `outline` (secondary), `ghost` (nav), `link` (inline).
- Sizes: `sm`, `default`, `lg`.

### 4.2 Card Component
- consistent `padding` (p-6), `radius` (rounded-lg), `border` (border-border).
- Hover effect: `hover:shadow-lg transition-all`.

### 4.3 Section Wrapper
- Container: `max-w-7xl mx-auto px-4 sm:px-6 lg:px-8`.
- Vertical Spacing: `py-16` or `py-24`.
