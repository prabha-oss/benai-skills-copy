# BenAI Skills

Expert automation skills for Claude Code, organized by department.

## Installation

```bash
# Add marketplace
/plugin marketplace add naveedharri/benai-skills

# Install a department plugin
/plugin install marketing@benai-skills
/plugin install sales@benai-skills
/plugin install operations@benai-skills
/plugin install creative@benai-skills
/plugin install product@benai-skills
/plugin install repurposing@benai-skills
```

## Available Departments

### Marketing (6 skills)
| Skill | Command | Purpose |
|-------|---------|---------|
| Programmatic SEO | `/programmatic-seo` | SEO-optimized pages at scale |
| SEO Optimizing | `/seo-optimizing` | Data-driven SEO via Search Console |
| SEO Audit | `/seo-audit` | Technical SEO audits (148 rules) |
| Email Sequence | `/email-sequence` | Email sequences & drip campaigns |
| Case Study | `/case-study` | Data-driven case studies |
| Infographic | `/infographic` | AI-generated infographics |

### Sales (4 skills)
| Skill | Command | Purpose |
|-------|---------|---------|
| Lead Research Assistant | `/lead-research-assistant` | B2B lead generation & ICP scoring |
| Email Sequence | `/email-sequence` | Email sequences & drip campaigns |
| Case Study | `/case-study` | Data-driven case studies |
| n8n Blueprint Generator | `/n8n-prd-generator` | Automation blueprints from calls |

### Operations (2 skills)
| Skill | Command | Purpose |
|-------|---------|---------|
| n8n Automation | `/n8n` | n8n workflow automation |
| n8n Blueprint Generator | `/n8n-prd-generator` | Automation blueprints from calls |

### Creative (3 skills)
| Skill | Command | Purpose |
|-------|---------|---------|
| Video | `/video` | Video editing (FFmpeg/Remotion) |
| Excalidraw | `/excalidraw` | Presentations & diagrams |
| Infographic | `/infographic` | AI-generated infographics |

### Product (2 skills)
| Skill | Command | Purpose |
|-------|---------|---------|
| Excalidraw | `/excalidraw` | Presentations & diagrams |
| n8n Blueprint Generator | `/n8n-prd-generator` | Automation blueprints from calls |

### Repurposing (5 skills)
| Skill | Command | Purpose |
|-------|---------|---------|
| LinkedIn | `/linkedin` | LinkedIn posts & carousels from content |
| Newsletter | `/newsletter` | Newsletter editions from content |
| Title Generation | `/title-generation` | Optimized YouTube video titles |
| GIF Creator | `/gif-creator` | GIFs from video clips |
| Excalidraw | `/excalidraw` | Presentations & diagrams |

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

### Repurposing

Repurpose YouTube content into multiple formats. **LinkedIn** (`/linkedin`) creates posts and carousels from existing content. **Newsletter** (`/newsletter`) transforms content into engaging newsletter editions. **Title Generation** (`/title-generation`) generates optimized YouTube video titles using proven CTR formulas. **GIF Creator** (`/gif-creator`) extracts and optimizes GIFs from video clips for social media sharing.

## Project Structure

```
benai-skills/
├── .claude-plugin/
│   ├── marketplace.json
│   └── skills-map.json          # Defines which departments get which skills
├── shared-skills/               # Single source of truth for all skills
│   ├── programmatic-seo/
│   ├── seo-optimizing/
│   ├── seo-audit/
│   ├── email-sequence/
│   ├── case-study/
│   ├── infographic/
│   ├── lead-research-assistant/
│   ├── n8n-prd-generator/
│   ├── n8n/
│   ├── video/
│   ├── excalidraw/
│   ├── linkedin/
│   ├── newsletter/
│   ├── title-generation/
│   └── gif-creator/
├── commands/                    # Static command .md files mapped in skills-map.json
│   ├── marketing.md
│   ├── sales.md
│   ├── operations.md
│   ├── creative.md
│   ├── product.md
│   ├── repurpose.md
│   └── core-yt.md
├── plugins/                     # Generated by sync-skills.sh — do not edit directly
│   ├── marketing/
│   ├── sales/
│   ├── operations/
│   ├── creative/
│   ├── product/
│   └── repurposing/
├── sync-skills.sh               # Generates plugins/ from shared-skills/ + skills-map.json
├── build-zips.sh                # Builds distributable zips (runs sync first)
├── CLAUDE.md
└── README.md
```

Each department plugin follows the same structure:
```
plugins/<department>/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── <command>.md             # Mapped from commands/ via skills-map.json
└── skills/                      # Populated by sync-skills.sh
    └── <skill-name>/
        ├── SKILL.md
        └── references/
```

## Adding New Skills

1. Create the skill directory in `shared-skills/` with `SKILL.md` and optional `references/`
2. Add the skill to the relevant departments in `.claude-plugin/skills-map.json`
3. If needed, add command `.md` files in `commands/` and map them in `skills-map.json`
4. Run `./sync-skills.sh` to generate department plugins

## Editing Existing Skills

1. Edit the skill in `shared-skills/<skill>/` (never in `plugins/*/skills/`)
2. Run `./sync-skills.sh` to propagate changes

**Before every push**, run `./sync-skills.sh` to ensure departments are in sync.

## Building Distributable Zips

Run `./build-zips.sh` to generate downloadable zip files in `dist/`. The script runs `sync-skills.sh` first, then reads `marketplace.json` and creates:
- One zip per department (standalone, installable individually)
- `benai-skills-marketplace.zip` (all departments in one package)

## License

BenAI
