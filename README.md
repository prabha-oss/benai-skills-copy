# BenAI Skills

Expert automation skills for Claude Code.

## Installation

```bash
# Add marketplace
/plugin marketplace add naveedharri/benai-skills

# Install individual plugins
/plugin install n8n@benai-skills
/plugin install video@benai-skills
/plugin install excalidraw@benai-skills
/plugin install email-sequence@benai-skills
/plugin install programmatic-seo@benai-skills
/plugin install seo-optimizing@benai-skills
```

## Available Plugins

| Plugin | Command | Purpose |
|--------|---------|---------|
| n8n | `/n8n` | Complete n8n workflow automation via REST API |
| video | `/video` | Video editing with FFmpeg and Remotion |
| excalidraw | `/excalidraw` | Visual presentations, slide decks, and diagrams in Excalidraw |
| email-sequence | `/email-sequence` | Email sequences, drip campaigns, and lifecycle email programs |
| programmatic-seo | `/programmatic-seo` | SEO-optimized pages at scale using templates and data |
| seo-optimizing | `/seo-optimizing` | Analyze and optimize content for search engines |

### n8n Automation

Build, test, and deploy n8n workflows via REST API with incremental testing. Includes node references for 40+ common nodes, JavaScript/Python Code node patterns, expression syntax, and credential management.

**Setup:** Create `.env` in your working directory:
```bash
N8N_API_URL=https://your-n8n.app.n8n.cloud
N8N_API_KEY=your-api-key
N8N_CREDENTIALS_TEMPLATE_URL=https://your-n8n.app.n8n.cloud/workflow/template-id
```

### Video Editing

Video editing pipeline with FFmpeg and Remotion. Supports stitching, transitions, TikTok-style captions, teasers, transcription, title cards, and graphics generation.

### Excalidraw

Create visual presentations, slide decks, and diagrams in Excalidraw. Supports generating `.excalidraw` JSON files or injecting slides directly into excalidraw.com via Chrome browser automation.

### Email Sequence

Design email sequences including welcome/onboarding, lead nurture, re-engagement, post-purchase, and sales sequences. Includes copy guidelines and sequence templates.

### Programmatic SEO

Build SEO-optimized pages at scale using templates and data sources. Covers directory pages, location pages, comparison pages, and integration pages with Webflow CMS support.

### SEO Optimizing

Analyze and optimize content for search engines. Includes content analysis, on-page SEO checks, competitor comparison, and optimization suggestions.

## Project Structure

```
benai-skills/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── n8n/
│   ├── video/
│   ├── excalidraw/
│   ├── email-sequence/
│   └── seo/
│       ├── programmatic-seo/
│       └── seo-optimizing/
├── CLAUDE.md
└── README.md
```

## Adding New Plugins

1. Create plugin directory structure:
   ```
   plugins/<name>/
   ├── .claude-plugin/
   │   └── plugin.json
   └── skills/<name>/
       ├── SKILL.md
       └── references/
   ```

2. Create `plugins/<name>/.claude-plugin/plugin.json`:
   ```json
   {
     "name": "<name>",
     "description": "Your plugin description",
     "version": "1.0.0"
   }
   ```

3. Add plugin entry to `.claude-plugin/marketplace.json`:
   ```json
   {
     "name": "<name>",
     "source": "./plugins/<name>",
     "description": "..."
   }
   ```

## License

MIT License
