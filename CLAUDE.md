# BenAI Skills - Expert Automation

## What This Is

A marketplace of expert automation plugins for Claude Code. Each plugin can be installed individually.

## Available Plugins

| Plugin | Command | Purpose |
|--------|---------|---------|
| n8n | `/n8n`, `/n8n-prd-generator` | n8n workflow automation + blueprint generator |
| video | `/video` | Video editing with FFmpeg and Remotion |
| excalidraw | `/excalidraw` | Visual presentations, slide decks, and diagrams in Excalidraw |
| email-sequence | `/email-sequence` | Email sequences, drip campaigns, and lifecycle email programs |
| programmatic-seo | `/programmatic-seo` | SEO-optimized pages at scale using templates and data |
| seo-optimizing | `/seo-optimizing` | Analyze and optimize content for search engines |
| seo-audit | `/seo-audit` | Technical SEO audits — 16 categories, 148 rules via seomator |
| infographic | `/infographic` | Professional infographics via Gemini AI image generation |
| case-study | `/case-study` | Detailed, data-driven case studies from interviews |
| lead-research-assistant | `/lead-research-assistant` | B2B lead generation — company research, LinkedIn prospecting, ICP scoring |

## n8n Skill

### Configuration

Requires a `.env` file in your working directory:

```
N8N_API_URL=https://your-n8n-instance.com
N8N_API_KEY=your-api-key
N8N_CREDENTIALS_TEMPLATE_URL=https://your-n8n-instance.com/workflow/template-id
```

The skill will automatically create this file if missing and prompt for values.

### Node Selection Priority

**ALWAYS prefer native n8n nodes over HTTP Request or Code nodes.**

| Priority | Use When |
|----------|----------|
| 1. Native node | A built-in n8n node exists for the service (Slack, Google Sheets, etc.) |
| 2. **AI Agent node** | For ANY AI/LLM task - ALWAYS prefer over HTTP Request to OpenAI/Anthropic APIs |
| 3. **Loop node (Split In Batches)** | For processing multiple items - ALWAYS prefer over Code node loops |
| 4. HTTP Request | Native has issues OR no node exists AND not an AI task |
| 5. Code node | Complex logic that can't be done with built-in nodes |

### Incremental Build-Test Process (MANDATORY)

**THE #1 RULE: Add ONE node -> Test entire workflow -> Repeat**

```
Add Node A -> Test -> Add Node B -> Test -> Add Node C -> Test -> Done
```

**NEVER add two or more nodes at once. ALWAYS test after each single node.**

### Key API Patterns

| Operation | Method | Endpoint |
|-----------|--------|----------|
| Create | POST | `/api/v1/workflows` |
| Update | **PUT** | `/api/v1/workflows/{id}` |
| Activate | **POST** | `/api/v1/workflows/{id}/activate` |
| Execute | POST | `/webhook/{path}` |

### Expression Essentials

**Webhook data lives under `.body`:**
```
{{ $json.body.fieldName }}  <- Correct
{{ $json.fieldName }}       <- Wrong (won't work)
```

### Code Node Return Format

```javascript
return [{ json: { result: "value" } }];
```

### Testing After Each Node

```bash
# 1. Activate
curl -X POST "${N8N_API_URL}/api/v1/workflows/{id}/activate"

# 2. Execute
curl -X POST "${N8N_API_URL}/webhook/{path}" -d '{}'

# 3. Check status
curl "${N8N_API_URL}/api/v1/executions?limit=1" | jq '.data[0].status'
```

### Common Mistakes to Avoid

- Using PATCH instead of PUT for updates
- Using PUT with `{active: true}` instead of `/activate` endpoint
- Building all nodes then testing (build incrementally!)
- Fetching all executions (always use `?limit=2`)
- Using placeholder/mock data instead of real values

## Video Skill

### Tool Selection

| Task | FFmpeg | Remotion |
|------|--------|----------|
| **Stitching** | Same codec, no effects | Transitions, overlays, programmatic |
| **Transitions** | Simple crossfades | Multiple types, custom timing |
| **Captions** | SRT burn-in | TikTok-style word highlighting |
| **Teasers** | Quick clips | Text overlays, branded elements |

### Workflow

1. **Analyze** - Examine videos with ffprobe
2. **Transcribe** - Get speech content for smart cuts
3. **Ask** - Clarify user intent
4. **Plan** - Propose edit approach
5. **QA Test** - Run automated tests before preview
6. **Preview** - Show to user after QA passes
7. **Iterate** - Refine based on feedback

### Key Rules

- **Always preview in Remotion Studio before rendering**
- Never render automatically - wait for user approval
- Use whisper.cpp (not Python whisper) for fast transcription

## Best Practices Summary

1. **Always test after each node** - No exceptions
2. **Copy full node configs from template** - Not just credentials
3. **Use correct API methods** - PUT for update, POST for activate
4. **Limit execution queries** - Always `?limit=2`
5. **Report only after confirmed working** - Never "please test this"
6. **Never use mock data** - Ask for real values

## MCP Server Integration

If the n8n MCP server is available, prefer using MCP tools for:
- Node discovery: `search_nodes`, `get_node`
- Validation: `validate_node`, `validate_workflow`
- Templates: `search_templates`, `get_template`

Fall back to REST API skills when MCP is unavailable.

## Building Distributable Zips

Run `./build-zips.sh` to generate downloadable zip files in `dist/`. The script reads `marketplace.json`, detects all plugins, and creates one zip per plugin plus a full marketplace zip. The `n8n-prd-generator` plugin is bundled into the `n8n.zip`. Run it after adding or updating any plugin.
