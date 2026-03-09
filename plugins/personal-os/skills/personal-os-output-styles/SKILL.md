---
name: personal-os-output-styles
description: Manage and switch between output styles — conversation, YouTube script, blog post, email, quick reply, meeting summary. Use when user asks about writing styles, wants to switch style, create a custom style, or runs /personal-os-output-styles.
---

# Output Style Management

USE WHEN the user:
- Asks about available writing/output styles
- Wants to switch between styles
- Asks to create a custom output style
- Mentions "output style", "writing style", "format", "tone"
- Runs `/personal-os-output-styles`

## Pre-flight Check

1. Check if `./CLAUDE.md` exists in the current working directory
2. If it does NOT exist:
   - Tell the user: "This vault hasn't been set up yet. Run `/personal-os-setup` to bootstrap your personal assistant OS."
   - Stop here

## What Are Output Styles?

Output styles define how the assistant communicates. Each style is a markdown file in `.claude/output-styles/` that specifies tone, format, structure, and rules for a specific type of output.

## Available Styles

| Style | File | When to Use |
|-------|------|-------------|
| Conversation | `.claude/output-styles/conversation.md` | Default. Normal chat, brainstorming, Q&A |
| YouTube Script | `.claude/output-styles/youtube-script.md` | Writing YouTube video scripts |
| Blog Post | `.claude/output-styles/blog-post.md` | Long-form articles and blog content |
| Quick Reply | `.claude/output-styles/quick-reply.md` | DMs, short messages, quick responses |
| Email | `.claude/output-styles/email.md` | Professional email drafting |
| Meeting Summary | `.claude/output-styles/meeting-summary.md` | Summarizing meeting transcripts |

## How Style Switching Works

### Automatic Routing

1. **Default**: Always use `conversation.md` unless told otherwise
2. **Explicit request**: When the user says "write a YouTube script" or "draft an email", load that style
3. **Context clues**: If working on a meeting transcript, auto-switch to `meeting-summary.md`
4. **Load before writing**: Read the full style file before producing output in that format
5. **Stack with memory**: Combine the style with `Reference/about-me.md` for personalization

### Trigger Phrases

| User says... | Load style |
|---|---|
| "write a YouTube script", "script for a video" | `youtube-script.md` |
| "write a blog post", "draft an article" | `blog-post.md` |
| "draft an email", "write an email" | `email.md` |
| "quick reply", "short response", "DM" | `quick-reply.md` |
| "summarize this meeting", "meeting notes" | `meeting-summary.md` |
| Normal conversation (default) | `conversation.md` |

## How to Switch Styles

Users can switch styles at any time by simply asking:

- "Switch to blog post style"
- "Write this as a YouTube script"
- "Draft that as an email"
- "Go back to normal" (reverts to conversation style)

When switching, read the full style file to understand its rules before producing output.

## Creating Custom Styles

Users can create additional output styles by adding new `.md` files to `.claude/output-styles/`. Follow this template:

```markdown
# Style Name

## Identity
Who are you when writing in this style?

## Tone
What's the emotional register?

## Format
What's the structural template?

## Rules
What must you always/never do?

## Examples
Show 1-2 examples of ideal output in this style.
```

### Steps to Create a Custom Style

1. Ask the user what kind of content they want to write
2. Ask about tone, format, and any rules
3. Create the style file at `.claude/output-styles/[style-name].md`
4. Test by generating a sample in the new style
5. Iterate until the user is happy

### Custom Style Ideas

- Newsletter
- Social media post (Twitter/X, LinkedIn, etc.)
- Technical documentation
- Presentation outline
- Product description
- Case study
- Tutorial / how-to guide

## Personalization Layer

The user's unique voice and patterns are captured in `Reference/about-me.md` and applied ON TOP of whichever style is active. This means:

- If the user prefers concise communication, all styles will be more concise
- If the user has a specific vocabulary or tone, it carries across styles
- Style files define the structure; preferences define the personality

## Guidelines

- Always read the style file before producing styled output -- don't rely on memory
- If a style file doesn't exist locally, tell the user and offer to create it
- When listing styles, check which files actually exist in `.claude/output-styles/`
- Custom styles should follow the same template structure for consistency
- The meeting summary style is automatically used by `/personal-os-meetings`
