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

## Saving and Displaying Images

### CRITICAL: Always Save to Working Directory

Images MUST be saved to the current working directory with descriptive names:

```bash
# Single infographic
infographic-[topic-slug].png

# Series
infographic-[topic-slug]-01.png
infographic-[topic-slug]-02.png

# Versions during editing
infographic-[topic-slug]-v1.png
infographic-[topic-slug]-v2.png
infographic-[topic-slug]-final.png
```

### CRITICAL: Always Display to User

After saving, **immediately use the Read tool** to show the image:

```
After saving the image, USE THE READ TOOL to display it:

Read the file: ./infographic-output.png

This allows the user to SEE the image and provide feedback for edits.
```

### Complete Save & Display Workflow

```bash
# 1. Generate the image
generate_infographic "$PROMPT" "infographic-myproject.png"

# 2. Verify it exists
if [ -f "infographic-myproject.png" ]; then
  echo "Image saved successfully"
  ls -la infographic-myproject.png
else
  echo "Error: Image not saved"
  exit 1
fi

# 3. THEN use Read tool to display (Claude will do this)
# Read the file: ./infographic-myproject.png
```

---

## Aspect Ratios

Include the aspect ratio in your prompt text:

| Platform | Ratio | Add to Prompt |
|----------|-------|---------------|
| LinkedIn | 4:5 | "4:5 portrait aspect ratio" |
| LinkedIn/Instagram | 1:1 | "square 1:1 aspect ratio" |
| Twitter | 16:9 | "16:9 landscape aspect ratio" |
| Presentation | 16:9 | "16:9 landscape aspect ratio" |
| Stories | 9:16 | "9:16 vertical aspect ratio" |

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
# Save prompt to file
cat > infographic-prompt.txt << 'EOF'
[Complete detailed prompt here]
EOF

echo "Prompt saved to infographic-prompt.txt"
```

**Instructions for user:**
```
Your infographic prompt is ready! To generate:

1. Go to https://aistudio.google.com
2. Sign in with Google
3. Select "Gemini 3 Pro" model
4. Paste the prompt from infographic-prompt.txt
5. Click Generate
6. Download the image
```

---

## Quick Reference

### Generate Image
```bash
curl -s -X POST \
  -H "Content-Type: application/json" \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-pro-image-preview:streamGenerateContent?key=${GEMINI_API_KEY}" \
  -d '{"contents":[{"role":"user","parts":[{"text":"YOUR PROMPT"}]}],"generationConfig":{"responseModalities":["IMAGE","TEXT"]}}' | \
  jq -r '.[] | .candidates[]?.content.parts[]? | select(.inlineData) | .inlineData.data' | head -1 | base64 -d > output.png
```

### Verify API Key
```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=${GEMINI_API_KEY}" | head -c 200
```

### File Naming
| Type | Pattern |
|------|---------|
| Single | `infographic-[topic].png` |
| Series | `infographic-[topic]-01.png` |
| Versions | `infographic-[topic]-v1.png` |
| Final | `infographic-[topic]-final.png` |
