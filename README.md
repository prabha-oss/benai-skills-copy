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
/plugin install case-study@benai-skills
```

## Available Plugins

### Marketing
| Plugin | Command | Purpose |
|--------|---------|---------|
| programmatic-seo | `/programmatic-seo` | SEO-optimized pages at scale |
| seo-optimizing | `/seo-optimizing` | Data-driven SEO via Search Console |
| seo-audit | `/seo-audit` | Technical SEO audits (148 rules) |
| email-sequence | `/email-sequence` | Email sequences & drip campaigns |
| case-study | `/case-study` | Data-driven case studies |
| infographic | `/infographic` | AI-generated infographics |

### Sales
| Plugin | Command | Purpose |
|--------|---------|---------|
| lead-research-assistant | `/lead-research-assistant` | B2B lead generation & ICP scoring |
| email-sequence | `/email-sequence` | Email sequences & drip campaigns |
| case-study | `/case-study` | Data-driven case studies |
| n8n-prd-generator | `/n8n-prd-generator` | Automation blueprints from calls |

### Operations
| Plugin | Command | Purpose |
|--------|---------|---------|
| n8n | `/n8n` | n8n workflow automation |
| n8n-prd-generator | `/n8n-prd-generator` | Automation blueprints from calls |

### Creative
| Plugin | Command | Purpose |
|--------|---------|---------|
| video | `/video` | Video editing (FFmpeg/Remotion) |
| excalidraw | `/excalidraw` | Presentations & diagrams |
| infographic | `/infographic` | AI-generated infographics |

### Product
| Plugin | Command | Purpose |
|--------|---------|---------|
| excalidraw | `/excalidraw` | Presentations & diagrams |
| n8n-prd-generator | `/n8n-prd-generator` | Automation blueprints from calls |

---

### n8n Automation

Build, test, and deploy n8n workflows via REST API with incremental testing. Includes node references for 40+ common nodes, JavaScript/Python Code node patterns, expression syntax, and credential management. Also includes the **n8n Blueprint Generator** (`/n8n-prd-generator`) for converting discovery call transcripts into n8n automation blueprints.

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

## Project Structure

```
benai-skills/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── marketing/
│   │   ├── seo-audit/
│   │   ├── seo-optimizing/
│   │   ├── programmatic-seo/
│   │   ├── email-sequence/
│   │   ├── case-study/
│   │   └── infographic/
│   ├── sales/
│   │   └── lead-research-assistant/
│   ├── operations/
│   │   ├── n8n/
│   │   └── n8n-prd-generator/
│   ├── creative/
│   │   ├── video/
│   │   └── excalidraw/
│   └── product/
├── CLAUDE.md
└── README.md
```

Each plugin follows the same structure:
```
plugins/<department>/<name>/
├── .claude-plugin/
│   └── plugin.json
└── skills/<name>/
    ├── SKILL.md
    └── references/
```

## Adding New Plugins

1. Create the plugin directory structure (see above)

2. Create `plugins/<department>/<name>/.claude-plugin/plugin.json`:
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

The `n8n-prd-generator` plugin is bundled into the `n8n.zip` rather than having its own standalone zip.

Run it after adding or updating any plugin.

## License

BenAI
