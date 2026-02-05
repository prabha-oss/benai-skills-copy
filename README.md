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
/plugin install seo-audit@benai-skills
/plugin install seo-optimizing@benai-skills
/plugin install infographic@benai-skills
/plugin install n8n-prd-generator@benai-skills
/plugin install case-study@benai-skills
```

## Available Plugins

| Plugin | Command | Purpose |
|--------|---------|---------|
| n8n | `/n8n` | Complete n8n workflow automation via REST API |
| video | `/video` | Video editing with FFmpeg and Remotion |
| excalidraw | `/excalidraw` | Visual presentations, slides, and diagrams in Excalidraw |
| email-sequence | `/email-sequence` | Email sequences, drip campaigns, and lifecycle email programs |
| programmatic-seo | `/programmatic-seo` | SEO-optimized pages at scale using templates and data |
| seo-audit | `/seo-audit` | Technical SEO audits — 16 categories, 148 rules via seomator |
| seo-optimizing | `/seo-optimizing` | Data-driven SEO optimization using Google Search Console |
| infographic | `/infographic` | Professional infographics via Gemini AI image generation |
| n8n-prd-generator | `/n8n-prd-generator` | Convert discovery call transcripts into n8n automation blueprints |
| case-study | `/case-study` | Detailed, data-driven case studies from interviews |

---

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

### SEO Suite

Three complementary SEO plugins:

| Plugin | Role | Data Source |
|--------|------|-------------|
| **seo-audit** | Technical diagnosis — what's broken | seomator CLI |
| **seo-optimizing** | Data-driven strategy — what to DO | Google Search Console API |
| **programmatic-seo** | Scale content creation | Templates + data sources |

**seo-audit** runs comprehensive technical SEO audits covering 16 categories and 148 rules using seomator CLI. Requires `@seomator/seo-audit` (installed automatically on first use).

**seo-optimizing** uses real Google Search Console data to find striking-distance keywords, fix low-CTR pages, detect keyword cannibalization, and execute content optimizations. Three data paths:
- **API path:** Service account + GSC API (up to 25,000 rows)
- **Browser path:** Claude Code browser extension navigates GSC directly (zero setup)
- **CSV path:** Manual export from GSC web UI

**programmatic-seo** generates SEO-optimized pages at scale using templates and data sources with Webflow CMS integration.

### Infographic

Generate professional infographics and visual content using Gemini AI image generation. Supports visual metaphors, brand guidelines, series creation, and iterative refinement.

### n8n Blueprint Generator

Convert discovery call transcripts and client documentation into one-page n8n Automation Blueprints. Extracts facts, asks clarifying questions interactively, and outputs a structured spec covering trigger, inputs, workflow steps, outputs, edge cases, and error handling.

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
│   ├── infographic/
│   ├── n8n-prd-generator/
│   └── seo/
│       ├── programmatic-seo/
│       ├── seo-audit/
│       └── seo-optimizing/
├── CLAUDE.md
└── README.md
```

Each plugin follows the same structure:
```
plugins/<name>/
├── .claude-plugin/
│   └── plugin.json
└── skills/<name>/
    ├── SKILL.md
    └── references/
```

## Adding New Plugins

1. Create the plugin directory structure (see above)

2. Create `plugins/<name>/.claude-plugin/plugin.json`:
   ```json
   {
     "name": "<name>",
     "description": "Your plugin description",
     "version": "1.0.0"
   }
   ```

3. Write `SKILL.md` with frontmatter including trigger keywords in the description

4. Add reference files in `references/` for detailed documentation

5. Register in `.claude-plugin/marketplace.json`

## Building Distributable Zips

Run `./build-zips.sh` to generate downloadable zip files in `dist/`. The script reads `marketplace.json`, detects all plugins, and creates:
- One zip per plugin (standalone, installable individually)
- `benai-skills-marketplace.zip` (all plugins in one package)

Run it after adding or updating any plugin.

## License

BenAI
