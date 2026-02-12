# API Key Setup Guide

How the Gemini API key is configured for image generation via the Nano Banana MCP server.

---

## How It Works

The Nano Banana MCP server is automatically registered when you install the marketing or creative department plugin. The MCP server reads `GEMINI_API_KEY` from its environment at startup (configured via the `env` block in `plugin.json`).

**Setup flow:**
1. User provides their Gemini API key during the skill's Phase 4
2. The skill saves it to a `.env` file in the project directory
3. User restarts Claude Code — the key is now in the shell environment
4. The MCP server picks up `GEMINI_API_KEY` from the env block → works automatically from then on

---

## Three Paths for API Key Handling

When the key is not configured, offer three options:

1. **Set it up now** — Guide through Google AI Studio + configure via MCP tool
2. **User has key ready** — Configure via MCP tool
3. **Skip for now** — Output prompt for manual use elsewhere

---

## Path 1: Set Up Now (Guided Setup)

### Step-by-Step Instructions

Present these instructions to the user:

```
To get your free Gemini API key:

1. Go to Google AI Studio: https://aistudio.google.com

2. Sign in with your Google account
   (If you don't have one, you'll need to create one)

3. Click "Get API Key" in the left sidebar
   (Or look for "API keys" in the menu)

4. Click "Create API key"
   - Select an existing Google Cloud project, OR
   - Click "Create project" to make a new one

5. Copy the generated key
   It looks like: AIzaSy...long-string...XYZ

6. Paste the key here when ready.

Note: The Gemini API has a generous free tier. You won't be charged
for normal infographic generation usage.
```

### After User Provides Key

1. **Save to `.env` file:**
   ```bash
   echo "GEMINI_API_KEY=user-provided-key" > .env
   echo ".env" >> .gitignore 2>/dev/null || true
   ```

2. **Source it:**
   ```bash
   source .env
   ```

3. **Confirm to user:**
   ```
   API key saved to .env.

   IMPORTANT: Please restart Claude Code so the Nano Banana MCP server
   picks up the key. Then run /infographic again — it will work
   automatically from now on.
   ```

---

## Path 2: User Has Key Ready

If user selects "I have a key ready":

```
Great! Paste your API key here and I'll configure it.
```

If user pastes a key:
1. Save to `.env` file
2. Source it
3. Tell user to restart Claude Code

---

## Path 3: Skip for Now

If user chooses to skip:

```
No problem! I'll complete all the planning phases and give you a
ready-to-use prompt at the end.

You can then:
- Paste the prompt into Google AI Studio (aistudio.google.com)
- Use it with ChatGPT or other image AIs
- Come back later with /infographic after setting up your key

Let's continue with the design...
```

### What Changes in Skip Mode

- Complete Phases 1-5 normally (all planning and specification)
- In Phase 6, instead of calling the MCP tool:
  1. Show the complete prompt
  2. Save prompt to `.infographic/prompts/[topic]-prompt.md`
  3. Provide instructions for manual generation

### Skip Mode Output

```
Here's your ready-to-use prompt:

---
[Complete prompt from Phase 6]
---

To generate your infographic:

Option 1: Google AI Studio (Recommended)
1. Go to aistudio.google.com
2. Create a new prompt
3. Paste this prompt
4. Click "Run" or "Generate"
5. Download the resulting image

Option 2: Other Image AIs
This prompt works with most image generation tools.
Paste it into your preferred service.

I've saved this prompt to: .infographic/prompts/[topic]-prompt.md

When you're ready to set up your API key, run /infographic again
and I'll use your saved brand preferences.
```

Save the prompt:

```bash
mkdir -p .infographic/prompts

cat > .infographic/prompts/[topic-slug]-prompt.md <<'EOF'
# Infographic Prompt: [Topic]

## Specifications
- Platform: [platform]
- Aspect Ratio: [ratio]
- Resolution: [resolution]
- Style: [tone]

## Prompt
```
[Full prompt text]
```

## Usage Instructions
1. Go to Google AI Studio (aistudio.google.com)
2. Select "Gemini" model
3. Paste the prompt above
4. Click Generate
5. Download the image

---
*Generated: [ISO-8601-timestamp]*
EOF
```

---

## Verification

### Check if key is set:

```bash
echo "${GEMINI_API_KEY:+API key is configured}"
```

### Check `.env` file:

```bash
if [ -f .env ] && grep -q GEMINI_API_KEY .env; then
  echo "Key found in .env"
fi
```

---

## Troubleshooting

### "MCP tool not available"

The Nano Banana MCP server may not be running. This happens if:
- The plugin was not installed correctly
- npx cannot find the `nano-banana-mcp` package
- Network issues preventing npx download

Solution: Verify the plugin installation, ensure internet connectivity, or fall back to the "Skip for now" path.

### "API key not valid"

The key may be incorrect or expired:

```
That key doesn't seem to work. Let's try again:

1. Go back to aistudio.google.com
2. Check your API keys list
3. Make sure the key is enabled
4. Copy the full key (starts with AIza...)
5. Paste it here
```

Solution:
1. Call `configure_gemini_token` with a new key
2. Verify with `get_configuration_status`

### "Quota exceeded"

```
You've hit the API rate limit. This usually resets within a minute.

Options:
1. Wait 60 seconds and try again
2. Use the skip path and generate manually
3. Check your quota at console.cloud.google.com
```

### "Permission denied"

```
Your API key may have restrictions that block image generation.

To fix:
1. Go to console.cloud.google.com
2. Navigate to APIs & Services > Credentials
3. Click on your API key
4. Under "API restrictions", select "Don't restrict key" or add
   "Generative Language API"
5. Save and try again
```

---

## Security Notes

Remind users:
- The API key is stored in `.env` in the project directory
- Don't commit `.env` to version control
- The skill automatically adds `.env` to `.gitignore`
- Don't share your API key publicly
- You can regenerate keys anytime in Google Cloud Console

```bash
# Ensure .env is in .gitignore
echo ".env" >> .gitignore 2>/dev/null || true
```
