# 06 Clone Mode

This reference file is used ONLY when the user chooses "Clone URL" at the beginning of the interaction.

## Goal
The goal of Clone Mode is to perfectly recreate a given website pixel-for-pixel using Next.js and Tailwind CSS, bypassing the custom copywriting and business intake phases.

## Phase 1: Clone Intake
Instead of the standard Phase 1 (asking the user a series of business questions), follow this flow:

### Step 1: Request Target URL
Ask the user for the exact URL they want to clone.

```text
AskUserQuestion(
  question: "What is the URL of the website you want to perfectly clone?",
  options: [
    { label: "Provide URL", description: "I'll paste the link" }
  ]
)
```

Wait for the URL to be provided.

### Step 2: Browser Extension Setup
Remind the user to install the Claude Browser Extension so you can view the site. Show this EXACT message:

```text
Before we clone the site, let's set you up for the best experience.

INSTALL CLAUDE BROWSER EXTENSION

This lets me analyze the target website directly.

Install here:
https://chromewebstore.google.com/detail/claude/kosogfohbhkplgacdjfidlmbkdbalgbi

Once installed, click the extension icon and sign in with your Claude account.

Let me know when you're ready, or skip if you prefer not to install it.
```

Wait for user to confirm or skip.

## Phase 2: Deep Extraction

Once the URL is provided and the extension is ready, use the `browser_subagent` to deeply analyze the site.

```text
browser_subagent(
  Task: "Navigate to [URL]. Take full-page screenshots of every section. Extract the EXACT HTML structure, text copy, spacing (padding/margins), fonts, colors, and layout configurations. Note all hover effects and animations.",
  RecordingName: "clone_extraction"
)
```

## Phase 3: Exact Development

Proceed directly to development. Follow the standard development guidelines in `references/05-development-guide.md` for setting up the Next.js project, but strictly adhere to this rule:
**DO NOT INVENT COPY OR DESIGN.** Reproduce the exact text, colors, imagery, and layout found on the original site. Use placeholder images via the `generate_image` tool if exact assets cannot be downloaded, but size them perfectly to match the original proportions.

## Phase 4: Preview and Iteration
Launch the dev server using `npm run dev`, show it to the user, and ask:
"Does this look like a perfect clone? Are there any padding, spacing, or typography details I missed?"

Iterate to fix any layout inconsistencies until the user is satisfied. After approval, proceed to deploy to Vercel (Phase 10 from the standard flow).
