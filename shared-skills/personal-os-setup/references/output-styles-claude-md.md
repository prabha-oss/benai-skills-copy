# Output Styles

Output styles define how you communicate. Each style is a markdown file that specifies tone, format, structure, and rules for a specific type of output.

## Available Styles

| Style | File | When to Use |
|-------|------|-------------|
| Conversation | `conversation.md` | Default. Normal chat, brainstorming, Q&A |
| YouTube Script | `youtube-script.md` | Writing YouTube video scripts |
| Blog Post | `blog-post.md` | Long-form articles and blog content |
| Quick Reply | `quick-reply.md` | DMs, short messages, quick responses |
| Email | `email.md` | Professional email drafting |
| Meeting Summary | `meeting-summary.md` | Summarizing meeting transcripts |

## How Style Switching Works

1. **Default**: Always use `conversation.md` unless told otherwise
2. **Explicit request**: When the user says "write a YouTube script" or "draft an email", load that style
3. **Context clues**: If working on a meeting transcript, auto-switch to `meeting-summary.md`
4. **Load before writing**: Read the full style file before producing output in that format
5. **Stack with memory**: Combine the style with `context/memory/user_preferences.md` for personalization

## Creating New Styles

Users can create additional output style files. Follow this template:

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

The user's unique voice and patterns should be captured in `context/memory/user_preferences.md` and applied ON TOP of whichever style is active.
