# Nano Banana MCP Image Generation Reference

Technical reference for generating and editing infographic images using the Nano Banana MCP tools.

---

## Overview

Image generation and editing is handled through the Nano Banana MCP server, which exposes 6 tools. The MCP server is auto-configured via the plugin system — no manual setup required beyond having a Gemini API key.

**Underlying model:** gemini-2.5-flash-image-preview

---

## Available MCP Tools

### 1. `generate_image`

Creates a new image from a text prompt.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `prompt` | string | Yes | Detailed text description of the image to create |

**Returns:** Image preview + file path where the image was saved (in `./generated_imgs/`)

**Usage:**

```
Call tool: generate_image
Parameters: { "prompt": "Your detailed infographic prompt here" }
```

**IMPORTANT:** This tool does not accept separate `aspectRatio` or `imageSize` parameters. Embed these in the prompt text:
- "Create a 4:5 portrait infographic at approximately 2048 pixels wide..."
- "Generate a 16:9 landscape diagram at 4K resolution..."

---

### 2. `edit_image`

Modifies an existing image based on text instructions.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `imagePath` | string | Yes | Path to the image to edit |
| `prompt` | string | Yes | Edit instructions |
| `referenceImages` | string[] | No | Paths to reference images for style guidance |

**Returns:** Edited image preview + file path

**Usage:**

```
Call tool: edit_image
Parameters: {
  "imagePath": ".infographic/images/topic-v1.png",
  "prompt": "Make the title text larger and change the blue to purple #7C3AED"
}
```

---

### 3. `continue_editing`

Applies further edits to the most recently processed image without specifying a path.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `prompt` | string | Yes | Further modifications to apply |
| `referenceImages` | string[] | No | Paths to reference images |

**Returns:** Updated image preview + file path

**Usage:**

```
Call tool: continue_editing
Parameters: { "prompt": "Add more whitespace around the title" }
```

**When to use:** After an initial `edit_image` call, use `continue_editing` for all subsequent iterations in the same session. This maintains editing context.

---

### 4. `get_last_image_info`

Retrieves metadata about the most recently created or edited image.

**Parameters:** None

**Returns:** File path, size, modification time of the last image

---

### 5. `configure_gemini_token`

Stores the Gemini API key for the MCP server.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `apiKey` | string | Yes | Your Gemini API key |

**Returns:** Confirmation that the key was saved

**Usage:**

```
Call tool: configure_gemini_token
Parameters: { "apiKey": "AIzaSy..." }
```

---

### 6. `get_configuration_status`

Checks whether the API key is configured.

**Parameters:** None

**Returns:** Status indicating whether credentials are loaded

---

## File Handling

### MCP Output Location

The MCP server saves images to `./generated_imgs/` with timestamped names:
- Generated: `generated-[timestamp]-[id].png`
- Edited: `edited-[timestamp]-[id].png`

### Copy to Project Directory

After every generation or edit, copy the output to the canonical project directory:

```bash
mkdir -p .infographic/images
cp "./generated_imgs/[returned-filename]" ".infographic/images/[topic-slug]-v[N].png"
```

### File Naming Convention

| Stage | Pattern | Example |
|-------|---------|---------|
| First version | `[topic]-v1.png` | `success-iceberg-v1.png` |
| After edits | `[topic]-v2.png` | `success-iceberg-v2.png` |
| Final approved | `[topic]-final.png` | `success-iceberg-final.png` |
| Series | `[topic]-01-v1.png` | `productivity-tips-01-v1.png` |

### CRITICAL: Always Display to User

After saving, **immediately use the Read tool** to show the image:

```
Read the file: .infographic/images/topic-v1.png
```

This allows the user to SEE the image and provide feedback for edits.

---

## Embedding Image Specifications in Prompts

Since the MCP tool does not have separate parameters for aspect ratio and resolution, these must be embedded in the prompt text.

### Aspect Ratio

| Platform | Prompt Suffix |
|----------|---------------|
| LinkedIn | "Output as a 4:5 portrait aspect ratio image" |
| Square (Instagram) | "Output as a 1:1 square aspect ratio image" |
| Twitter/Presentation | "Output as a 16:9 landscape aspect ratio image" |
| Stories | "Output as a 9:16 vertical aspect ratio image" |

### Resolution

| Quality Level | Prompt Suffix |
|---------------|---------------|
| Standard | "at approximately 1024 pixels wide" |
| 2K (Recommended) | "at approximately 2048 pixels wide" |
| 4K | "at approximately 4096 pixels wide" |

### Combined Example

```
... [rest of prompt]. Output as a 4:5 portrait aspect ratio image at approximately 2048 pixels wide.
```

---

## Complete Generation Workflow

### Step 1: Generate

```
Call tool: generate_image
Parameters: { "prompt": "[full prompt with embedded aspect ratio and resolution]" }
```

### Step 2: Copy to Project Directory

```bash
mkdir -p .infographic/images
cp "./generated_imgs/[returned-filename]" ".infographic/images/[topic-slug]-v1.png"
```

### Step 3: Display to User

```
Read the file: .infographic/images/[topic-slug]-v1.png
```

### Step 4: Verify

```bash
ls -la .infographic/images/[topic-slug]-v1.png
```

---

## Editing Workflow

### First Edit

```
Call tool: edit_image
Parameters: {
  "imagePath": ".infographic/images/topic-v1.png",
  "prompt": "Edit instructions: 1. Make colors warmer 2. Increase title size"
}
```

Then copy and display:
```bash
cp "./generated_imgs/[returned-filename]" ".infographic/images/topic-v2.png"
```

### Subsequent Edits

```
Call tool: continue_editing
Parameters: { "prompt": "Add more whitespace, simplify the bottom section" }
```

Then copy and display:
```bash
cp "./generated_imgs/[returned-filename]" ".infographic/images/topic-v3.png"
```

### When to Edit vs Regenerate

| Situation | Action |
|-----------|--------|
| Color adjustments | `edit_image` / `continue_editing` |
| Text changes | `edit_image` / `continue_editing` |
| Layout tweaks | `edit_image` / `continue_editing` |
| Different metaphor | Regenerate with `generate_image` |
| Major concept change | Regenerate with `generate_image` |
| 50%+ of image needs change | Regenerate with `generate_image` |

---

## Error Handling

### MCP Tool Not Available

If the Nano Banana MCP tools are not available (MCP server not running or not configured in plugin):
- Fall back to the "Skip for now" path
- Save the prompt to `.infographic/prompts/` for manual use
- Direct user to Google AI Studio

### API Key Not Configured

If `get_configuration_status` indicates no key:
- Use `configure_gemini_token` to set it
- Or follow the "Skip for now" path

### Generation Fails

If `generate_image` returns an error:
- Check configuration with `get_configuration_status`
- Try simplifying the prompt
- If the prompt was flagged for safety, rephrase and avoid sensitive terms
- Fall back to saving prompt for manual use

### Rate Limit

If you hit a 429 rate limit:
- Wait 60 seconds and try again
- Or use the skip path for manual generation

---

## Directory Structure

```
.infographic/
├── brand.md           # Brand config (Markdown, human-readable)
├── images/            # All generated infographics (copied from MCP output)
│   ├── topic-v1.png
│   ├── topic-v2.png
│   └── topic-final.png
└── prompts/           # Saved prompts for reuse
    └── topic-prompt.md
```

---

## Quick Reference

### Check Configuration
```
Call tool: get_configuration_status
```

### Configure API Key
```
Call tool: configure_gemini_token
Parameters: { "apiKey": "your-key-here" }
```

### Generate Image
```
Call tool: generate_image
Parameters: { "prompt": "Detailed prompt with aspect ratio and resolution" }
```

### Edit Image (first edit)
```
Call tool: edit_image
Parameters: { "imagePath": "path/to/image.png", "prompt": "Edit instructions" }
```

### Continue Editing (subsequent edits)
```
Call tool: continue_editing
Parameters: { "prompt": "Further edit instructions" }
```

### Get Last Image Info
```
Call tool: get_last_image_info
```
