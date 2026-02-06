# Gemini Image Generation API Reference

Technical reference for generating and editing infographic images using the Gemini API.

---

## Environment Setup

### Option 1: Export in Shell

```bash
export GEMINI_API_KEY=your-api-key-here
```

### Option 2: Use .env File (Recommended for Persistence)

```bash
echo "GEMINI_API_KEY=your-api-key-here" > .env
source .env
```

The `.env` file persists across sessions and is automatically loaded in Phase 0.

### Verify Setup

```bash
echo "${GEMINI_API_KEY:+API key is set}"
```

### No API Key? See Fallback Options

If no API key is available, see the "No API Key Fallback" section below for alternative workflows.

---

## Model Selection

| Model | Best For | Notes |
|-------|----------|-------|
| `gemini-3-pro-image-preview` | Image generation (RECOMMENDED) | Latest model, best quality |

**Default:** Always use `gemini-3-pro-image-preview` for image generation.

---

## Text-to-Image Generation

### Using curl (Recommended Method)

```bash
# Set variables
GEMINI_API_KEY="${GEMINI_API_KEY}"
MODEL_ID="gemini-3-pro-image-preview"
PROMPT="Generate a professional infographic about the 5 stages of product development. Use a clean timeline layout with numbered circles connected by a blue line. Each stage has a short title and one-line description. White background, blue (#2563EB) and amber (#F59E0B) accent colors. Professional flat design style. 4:5 aspect ratio for LinkedIn."

# Create request JSON
cat > request.json << 'EOF'
{
  "contents": [
    {
      "role": "user",
      "parts": [
        {
          "text": "PROMPT_PLACEHOLDER"
        }
      ]
    }
  ],
  "generationConfig": {
    "responseModalities": ["IMAGE", "TEXT"]
  }
}
EOF

# Replace placeholder with actual prompt
sed -i '' "s|PROMPT_PLACEHOLDER|${PROMPT}|g" request.json 2>/dev/null || sed -i "s|PROMPT_PLACEHOLDER|${PROMPT}|g" request.json

# Make API call and save image
curl -s -X POST \
  -H "Content-Type: application/json" \
  "https://generativelanguage.googleapis.com/v1beta/models/${MODEL_ID}:streamGenerateContent?key=${GEMINI_API_KEY}" \
  -d @request.json | \
  jq -r '.[] | .candidates[]?.content.parts[]? | select(.inlineData) | .inlineData.data' | \
  head -1 | base64 -d > infographic-output.png

# Verify and display
ls -la infographic-output.png
```

### Complete Generation Function

```bash
generate_infographic() {
  local prompt="$1"
  local output_file="$2"
  local aspect_ratio="${3:-}"  # Optional: "1:1", "4:5", "16:9"

  local MODEL_ID="gemini-3-pro-image-preview"

  # Build the request JSON
  local request_json=$(cat << EOF
{
  "contents": [
    {
      "role": "user",
      "parts": [
        {"text": "${prompt}"}
      ]
    }
  ],
  "generationConfig": {
    "responseModalities": ["IMAGE", "TEXT"]
  }
}
EOF
)

  # Make the API call
  local response=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    "https://generativelanguage.googleapis.com/v1beta/models/${MODEL_ID}:streamGenerateContent?key=${GEMINI_API_KEY}" \
    -d "${request_json}")

  # Check for errors
  if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
    echo "Error: $(echo "$response" | jq -r '.error.message')"
    return 1
  fi

  # Extract and save image
  local image_data=$(echo "$response" | jq -r '.[] | .candidates[]?.content.parts[]? | select(.inlineData) | .inlineData.data' | head -1)

  if [ -z "$image_data" ] || [ "$image_data" = "null" ]; then
    echo "Error: No image data in response"
    echo "Response: $response" | head -c 500
    return 1
  fi

  echo "$image_data" | base64 -d > "$output_file"

  if [ -s "$output_file" ]; then
    echo "Success: Image saved to $output_file"
    echo "File size: $(ls -lh "$output_file" | awk '{print $5}')"
    return 0
  else
    echo "Error: Failed to save image"
    return 1
  fi
}

# Usage
generate_infographic "Your detailed prompt here" "infographic-output.png"
```

---

## Image Editing (Multi-Turn)

Send the existing image back with edit instructions:

```bash
edit_infographic() {
  local input_image="$1"
  local edit_prompt="$2"
  local output_file="$3"

  local MODEL_ID="gemini-3-pro-image-preview"

  # Encode the image
  local image_base64=$(base64 -i "$input_image" | tr -d '\n')

  # Build request with image + edit prompt
  local request_json=$(cat << EOF
{
  "contents": [
    {
      "role": "user",
      "parts": [
        {
          "inlineData": {
            "mimeType": "image/png",
            "data": "${image_base64}"
          }
        },
        {"text": "${edit_prompt}"}
      ]
    }
  ],
  "generationConfig": {
    "responseModalities": ["IMAGE", "TEXT"]
  }
}
EOF
)

  # Make API call
  local response=$(curl -s -X POST \
    -H "Content-Type: application/json" \
    "https://generativelanguage.googleapis.com/v1beta/models/${MODEL_ID}:streamGenerateContent?key=${GEMINI_API_KEY}" \
    -d "${request_json}")

  # Extract and save edited image
  local image_data=$(echo "$response" | jq -r '.[] | .candidates[]?.content.parts[]? | select(.inlineData) | .inlineData.data' | head -1)

  if [ -n "$image_data" ] && [ "$image_data" != "null" ]; then
    echo "$image_data" | base64 -d > "$output_file"
    echo "Edited image saved to $output_file"
    return 0
  else
    echo "Error: No image in edit response"
    return 1
  fi
}

# Usage
edit_infographic "infographic-v1.png" "Make the colors warmer and increase the title size" "infographic-v2.png"
```

---

## Directory Structure

All infographic files are stored in a dedicated `.infographic/` directory:

```
.infographic/
├── brand.md           # Brand config (Markdown, human-readable)
├── images/            # All generated infographics
│   ├── topic-v1.png
│   ├── topic-v2.png
│   └── topic-final.png
└── prompts/           # Saved prompts for reuse
    └── topic-prompt.md
```

### Setup Directory

```bash
# Create directory structure on first run
mkdir -p .infographic/images
mkdir -p .infographic/prompts
```

---

## Saving and Displaying Images

### CRITICAL: Always Save to .infographic/images/

Images MUST be saved to the `.infographic/images/` directory with descriptive names:

```bash
# Single infographic (versions during editing)
.infographic/images/[topic-slug]-v1.png
.infographic/images/[topic-slug]-v2.png
.infographic/images/[topic-slug]-final.png

# Series
.infographic/images/[topic-slug]-01-v1.png
.infographic/images/[topic-slug]-02-v1.png
```

### CRITICAL: Always Display to User

After saving, **immediately use the Read tool** to show the image:

```
After saving the image, USE THE READ TOOL to display it:

Read the file: .infographic/images/topic-v1.png

This allows the user to SEE the image and provide feedback for edits.
```

### Complete Save & Display Workflow

```bash
# 0. Ensure directory exists
mkdir -p .infographic/images

# 1. Generate the image
generate_infographic "$PROMPT" ".infographic/images/myproject-v1.png"

# 2. Verify it exists
if [ -f ".infographic/images/myproject-v1.png" ]; then
  echo "Image saved successfully"
  ls -la .infographic/images/myproject-v1.png
else
  echo "Error: Image not saved"
  exit 1
fi

# 3. THEN use Read tool to display (Claude will do this)
# Read the file: .infographic/images/myproject-v1.png
```

---

## Resolution Options

Include resolution in your prompt to control image quality:

| Quality | Width | Best For | Add to Prompt |
|---------|-------|----------|---------------|
| Standard | 1080px | Quick social posts, mobile-first | "1080 pixels wide" |
| 2K | 2048px | Professional social, presentations | "2048 pixels wide, high resolution" |
| 4K | 4096px | Print, large displays | "4096 pixels wide, ultra high resolution" |

**Example prompt with resolution:**
```
Generate a professional infographic...
2048 pixels wide, high resolution, 4:5 portrait aspect ratio for LinkedIn.
```

---

## Aspect Ratios

Include the aspect ratio in your prompt text:

| Platform | Ratio | Standard (1080px) | 2K (2048px) | 4K (4096px) |
|----------|-------|-------------------|-------------|-------------|
| LinkedIn | 4:5 | 1080×1350 | 2048×2560 | 4096×5120 |
| Square | 1:1 | 1080×1080 | 2048×2048 | 4096×4096 |
| Twitter | 16:9 | 1200×675 | 2048×1152 | 4096×2304 |
| Presentation | 16:9 | 1920×1080 | 2560×1440 | 3840×2160 |
| Stories | 9:16 | 1080×1920 | 1152×2048 | 2304×4096 |

**Add to prompt:**
- LinkedIn: "4:5 portrait aspect ratio"
- Square: "square 1:1 aspect ratio"
- Twitter: "16:9 landscape aspect ratio"
- Stories: "9:16 vertical aspect ratio"

---

## Error Handling

### Common Errors

| Error | Cause | Solution |
|-------|-------|----------|
| No image in response | Model returned text only | Add "Generate an image:" prefix to prompt |
| `SAFETY` block | Content flagged | Rephrase prompt, avoid sensitive terms |
| 429 Rate Limited | Too many requests | Wait 60 seconds, retry |
| 401/403 Auth Error | Invalid API key | Check key, verify permissions |

### Check for Errors in Response

```bash
# Check if response contains an error
if echo "$response" | jq -e '.error' > /dev/null 2>&1; then
  echo "API Error: $(echo "$response" | jq -r '.error.message')"
  exit 1
fi

# Check if response contains image data
if ! echo "$response" | jq -e '.[] | .candidates[]?.content.parts[]? | select(.inlineData)' > /dev/null 2>&1; then
  echo "No image in response. Model may have returned text only."
  echo "Text response: $(echo "$response" | jq -r '.[] | .candidates[]?.content.parts[]? | select(.text) | .text' | head -c 200)"
  exit 1
fi
```

---

## No API Key Fallback

When no API key is available, save the prompt for manual use:

```bash
# Ensure directory exists
mkdir -p .infographic/prompts

# Save prompt to Markdown file
cat > .infographic/prompts/[topic-slug]-prompt.md << 'EOF'
# Infographic Prompt: [Topic Name]

## Specifications
- Platform: LinkedIn
- Aspect Ratio: 4:5
- Resolution: 2K (2048px)
- Style: Professional Blue

## Prompt
```
[Complete detailed prompt here]
```

## Usage Instructions
1. Go to https://aistudio.google.com
2. Sign in with Google
3. Select "Gemini 3 Pro" model
4. Paste the prompt above
5. Click Generate
6. Download to .infographic/images/

---
*Generated: [timestamp]*
EOF

echo "Prompt saved to .infographic/prompts/"
```

**Instructions for user:**
```
Your infographic prompt is ready in .infographic/prompts/[topic]-prompt.md

To generate:
1. Go to https://aistudio.google.com
2. Sign in with Google
3. Select "Gemini 3 Pro" model
4. Paste the prompt from the file
5. Click Generate
6. Download the image to .infographic/images/
```

---

## Quick Reference

### Generate Image
```bash
mkdir -p .infographic/images
curl -s -X POST \
  -H "Content-Type: application/json" \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-pro-image-preview:streamGenerateContent?key=${GEMINI_API_KEY}" \
  -d '{"contents":[{"role":"user","parts":[{"text":"YOUR PROMPT"}]}],"generationConfig":{"responseModalities":["IMAGE","TEXT"]}}' | \
  jq -r '.[] | .candidates[]?.content.parts[]? | select(.inlineData) | .inlineData.data' | head -1 | base64 -d > .infographic/images/output-v1.png
```

### Verify API Key
```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=${GEMINI_API_KEY}" | head -c 200
```

### Directory Structure
```
.infographic/
├── brand.md              # Brand config (Markdown)
├── images/               # All generated infographics
│   └── [topic]-v1.png
└── prompts/              # Saved prompts
    └── [topic]-prompt.md
```

### File Naming
| Type | Pattern | Location |
|------|---------|----------|
| First version | `[topic]-v1.png` | `.infographic/images/` |
| Edits | `[topic]-v2.png` | `.infographic/images/` |
| Final | `[topic]-final.png` | `.infographic/images/` |
| Series | `[topic]-01-v1.png` | `.infographic/images/` |
| Prompts | `[topic]-prompt.md` | `.infographic/prompts/` |

### Resolution Quick Reference
| Quality | Width | Example for 4:5 |
|---------|-------|-----------------|
| Standard | 1080px | 1080×1350 |
| 2K | 2048px | 2048×2560 |
| 4K | 4096px | 4096×5120 |
