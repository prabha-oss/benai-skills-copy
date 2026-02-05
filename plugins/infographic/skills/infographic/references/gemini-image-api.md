# Gemini Image Generation API Reference

Technical reference for generating and editing infographic images using the Gemini API.

---

## Environment Setup

Set the API key as an environment variable:

```bash
export GEMINI_API_KEY=your-api-key-here
```

Verify it's set:

```bash
echo "${GEMINI_API_KEY:+API key is set}"
```

---

## Model Selection

| Model | Best For | Speed | Quality | Text Rendering |
|-------|----------|-------|---------|----------------|
| `gemini-2.5-flash-image` | Image generation with Gemini API | Fast | Excellent | Excellent |

**What is gemini-2.5-flash-image?**
- This is the correct model name for Gemini's image generation API
- Supports native image generation through the generateContent endpoint
- Excels at creating images with correctly rendered, legible text—ideal for infographics, posters, UI mockups, and diagrams

**Default recommendation:**
- Use `gemini-2.5-flash-image` for all image generation tasks

---

## Text-to-Image Generation

### Using curl

```bash
# Generate an infographic image
curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent" \
  -H "x-goog-api-key: ${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [
        {"text": "Generate a professional infographic about the 5 stages of product development. Use a clean timeline layout with numbered circles connected by a blue line. Each stage has a short title and one-line description. White background, blue (#2563EB) and amber (#F59E0B) accent colors. Professional flat design style. 4:5 aspect ratio for LinkedIn."}
      ]
    }]
  }' | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > infographic-output.png
```

### Using Node.js

```javascript
const { GoogleGenAI } = require("@google/genai");
const fs = require("fs");

const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

async function generateInfographic(prompt, outputPath) {
  const response = await ai.models.generateContent({
    model: "gemini-2.5-flash-image",
    contents: [{ parts: [{ text: prompt }] }],
  });

  // Extract and save the image
  for (const part of response.candidates[0].content.parts) {
    if (part.inlineData) {
      const imageData = Buffer.from(part.inlineData.data, "base64");
      fs.writeFileSync(outputPath, imageData);
      console.log(`Image saved to ${outputPath}`);
      return outputPath;
    }
  }
  throw new Error("No image in response");
}

// Usage
generateInfographic(
  "Generate a pyramid infographic showing 4 levels of leadership...",
  "infographic-leadership.png"
);
```

---

## Image Editing (Multi-Turn Chat)

Use multi-turn conversations to iteratively refine an image without losing context.

### curl — Multi-Turn Edit

```bash
# Step 1: Generate initial image (same as above, save the full response)
RESPONSE=$(curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent" \
  -H "x-goog-api-key: ${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "contents": [{
      "parts": [
        {"text": "Generate a professional infographic about remote work benefits. Iceberg style. Blue color scheme."}
      ]
    }]
  }')

# Save the image
echo "$RESPONSE" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > infographic-v1.png

# Step 2: Edit the image by sending it back with modification instructions
IMAGE_B64=$(base64 -i infographic-v1.png)

curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent" \
  -H "x-goog-api-key: ${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"contents\": [{
      \"parts\": [
        {\"inlineData\": {\"mimeType\": \"image/png\", \"data\": \"${IMAGE_B64}\"}},
        {\"text\": \"Edit this infographic: change the title to 'Why Remote Works' and make the colors warmer (use orange and coral tones instead of blue)\"}
      ]
    }]
  }" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > infographic-v2.png
```

### Node.js — Multi-Turn Edit

```javascript
async function editInfographic(imagePath, editPrompt, outputPath) {
  const imageData = fs.readFileSync(imagePath);
  const base64Image = imageData.toString("base64");

  const response = await ai.models.generateContent({
    model: "gemini-2.5-flash-image",
    contents: [
      {
        parts: [
          {
            inlineData: {
              mimeType: "image/png",
              data: base64Image,
            },
          },
          { text: editPrompt },
        ],
      },
    ],
  });

  for (const part of response.candidates[0].content.parts) {
    if (part.inlineData) {
      const newImage = Buffer.from(part.inlineData.data, "base64");
      fs.writeFileSync(outputPath, newImage);
      console.log(`Edited image saved to ${outputPath}`);
      return outputPath;
    }
  }
  throw new Error("No image in edit response");
}
```

---

## Aspect Ratios

Specify aspect ratio in the prompt text (Gemini respects natural language aspect ratio instructions).

| Platform | Ratio | Prompt Instruction |
|----------|-------|--------------------|
| LinkedIn feed | 4:5 | "4:5 portrait aspect ratio" |
| LinkedIn feed | 1:1 | "square 1:1 aspect ratio" |
| LinkedIn carousel | 4:5 | "4:5 portrait aspect ratio" |
| Instagram feed | 1:1 | "square 1:1 aspect ratio" |
| Instagram feed | 4:5 | "4:5 portrait aspect ratio" |
| Twitter | 16:9 | "16:9 landscape aspect ratio" |
| Stories | 9:16 | "9:16 vertical/portrait aspect ratio" |
| Presentation | 16:9 | "16:9 landscape aspect ratio" |

---

## Error Handling

### Common Errors and Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `SAFETY` block | Prompt triggered safety filter | Rephrase prompt, remove potentially sensitive terms |
| `RECITATION` | Content too similar to training data | Make prompt more specific and unique |
| 429 Too Many Requests | Rate limited | Wait 30-60 seconds, retry |
| 400 Bad Request | Malformed request | Check JSON structure, verify model name |
| No image in response | Model returned text only | Add `"responseModalities": ["TEXT", "IMAGE"]` to config |

### Retry Pattern (bash)

```bash
generate_with_retry() {
  local prompt="$1"
  local output="$2"
  local max_retries=3
  local retry=0

  while [ $retry -lt $max_retries ]; do
    RESULT=$(curl -s -w "\n%{http_code}" -X POST \
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent" \
      -H "x-goog-api-key: ${GEMINI_API_KEY}" \
      -H "Content-Type: application/json" \
      -d "{
        \"contents\": [{\"parts\": [{\"text\": \"${prompt}\"}]}]
      }")

    HTTP_CODE=$(echo "$RESULT" | tail -1)
    BODY=$(echo "$RESULT" | sed '$d')

    if [ "$HTTP_CODE" = "200" ]; then
      echo "$BODY" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > "$output"
      if [ -s "$output" ]; then
        echo "Success: $output"
        return 0
      fi
    fi

    retry=$((retry + 1))
    echo "Retry $retry/$max_retries (HTTP $HTTP_CODE)..."
    sleep $((retry * 15))
  done

  echo "Failed after $max_retries retries"
  return 1
}
```

---

## Saving and Displaying Images

### Save to Working Directory

Always save generated images with descriptive names:

```bash
# Single infographic
infographic-remote-work-benefits.png

# Series
infographic-leadership-series-01.png
infographic-leadership-series-02.png
infographic-leadership-series-03.png
```

### Display to User

After saving, use the Read tool to show the image to the user:

```
Read the file: ./infographic-output.png
```

The Read tool supports image files and will display them inline.

---

## Complete Generation Workflow

```bash
# 1. Set API key
export GEMINI_API_KEY=your-key

# 2. Craft prompt (see prompt-engineering.md)
PROMPT="Generate a professional infographic..."

# 3. Generate
curl -s -X POST \
  "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-image:generateContent" \
  -H "x-goog-api-key: ${GEMINI_API_KEY}" \
  -H "Content-Type: application/json" \
  -d "{
    \"contents\": [{\"parts\": [{\"text\": \"${PROMPT}\"}]}]
  }" | jq -r '.candidates[0].content.parts[] | select(.inlineData) | .inlineData.data' | base64 -d > output.png

# 4. Verify file was created
ls -la output.png

# 5. Show to user (Claude reads the image file)
```
