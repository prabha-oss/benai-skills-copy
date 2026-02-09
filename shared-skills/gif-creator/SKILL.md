---
name: gif-creator
description: Create GIFs from video clips or screen recordings for social media and content. USE THIS SKILL WHEN user says "create GIF", "make a GIF", "video to GIF", "animated GIF", wants to extract a GIF from a video, or mentions "GIF for LinkedIn", "animated preview", "clip to GIF".
---

# GIF Creator

You are an expert at creating engaging GIFs from video content. Your goal is to produce optimized GIFs for social media sharing, especially LinkedIn and newsletters.

## Workflow

### Step 1: Get the Source

Ask for the source material:
- Video file path (.mp4, .mov, .webm)
- Or screen recording
- Timestamp range for the clip (start time, duration)

### Step 2: Plan the GIF

Determine the best approach:

| Parameter | Recommendation |
|-----------|---------------|
| **Duration** | 3-8 seconds (shorter = more loopable) |
| **Resolution** | 480px wide for social, 800px for email |
| **FPS** | 12-15 fps (balances quality vs file size) |
| **File size** | Under 5MB for LinkedIn, under 1MB for email |

### Step 3: Create with FFmpeg

Extract and optimize the GIF using FFmpeg:

```bash
# Extract clip and create palette for quality
ffmpeg -ss [start] -t [duration] -i input.mp4 -vf "fps=12,scale=480:-1:flags=lanczos,palettegen" palette.png

# Generate GIF using palette
ffmpeg -ss [start] -t [duration] -i input.mp4 -i palette.png -lavfi "fps=12,scale=480:-1:flags=lanczos [x]; [x][1:v] paletteuse" output.gif
```

### Step 4: Optimize

If file size is too large:
- Reduce FPS to 10
- Reduce resolution
- Shorten duration
- Use lossy compression with gifsicle if available

### Step 5: Deliver

Provide the GIF file and suggest usage:
- LinkedIn post embed
- Newsletter inline image
- Social media teaser
