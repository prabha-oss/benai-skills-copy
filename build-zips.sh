#!/bin/bash
#
# Builds distributable zip files for BenAI skills.
# Reads marketplace.json, detects all plugins, and generates:
#
#   dist/extension/                      Claude Code extension (Cursor, VS Code)
#     ├── <plugin-name>.zip              One plugin per zip (marketplace format)
#     └── benai-skills-marketplace.zip   All plugins in one zip
#
#   dist/claude/                         Claude Console (platform.claude.com)
#     └── <plugin-name>.zip              Flat skill zip (SKILL.md + references)
#
# Usage: ./build-zips.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
DIST="$ROOT/dist"
MARKETPLACE="$ROOT/.claude-plugin/marketplace.json"
TMP="$(mktemp -d)"

trap 'rm -rf "$TMP"' EXIT

# Check dependencies
if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is required" >&2
  exit 1
fi

if [ ! -f "$MARKETPLACE" ]; then
  echo "Error: marketplace.json not found at $MARKETPLACE" >&2
  exit 1
fi

# Clean and create dist directories
rm -rf "$DIST"
mkdir -p "$DIST/extension" "$DIST/claude"

# Plugins that should be bundled into the n8n zip instead of getting their own
BUNDLE_INTO_N8N="n8n-prd-generator"

# Read all plugins from marketplace.json
PLUGINS_JSON=$(python3 -c "
import json, sys
with open('$MARKETPLACE') as f:
    data = json.load(f)
for p in data['plugins']:
    print(p['name'] + '|' + p['source'])
")

echo "Found plugins:"
echo "$PLUGINS_JSON" | while IFS='|' read -r name source; do
  echo "  - $name ($source)"
done
echo ""

# =============================================================
# EXTENSION ZIPS (Claude Code / Cursor / VS Code)
# Structure: .claude-plugin/marketplace.json + plugins/<name>/
# =============================================================
echo "--- Building extension zips ---"

echo "$PLUGINS_JSON" | while IFS='|' read -r name source; do
  # Skip plugins that are bundled into n8n
  if echo " $BUNDLE_INTO_N8N " | grep -q " $name "; then
    echo "  Skipping $name (bundled into n8n.zip)"
    continue
  fi

  staging="$TMP/ext-$name"
  rm -rf "$staging"
  mkdir -p "$staging/.claude-plugin"
  mkdir -p "$staging/$(dirname "$source")"

  # Copy the plugin directory
  cp -R "$ROOT/$source" "$staging/$source"

  # For n8n, also include bundled plugins
  if [ "$name" = "n8n" ]; then
    for bname in $BUNDLE_INTO_N8N; do
      bsource=$(echo "$PLUGINS_JSON" | grep "^${bname}|" | head -1 | cut -d'|' -f2)
      if [ -n "$bsource" ]; then
        mkdir -p "$staging/$(dirname "$bsource")"
        cp -R "$ROOT/$bsource" "$staging/$bsource"
      fi
    done
  fi

  # Generate a marketplace.json with this plugin (and bundled plugins for n8n)
  python3 -c "
import json
with open('$MARKETPLACE') as f:
    data = json.load(f)
envelope = {k: v for k, v in data.items() if k != 'plugins'}
plugin = next(p for p in data['plugins'] if p['name'] == '$name')
plugins = [plugin]
if '$name' == 'n8n':
    for bn in '$BUNDLE_INTO_N8N'.split():
        bp = next((p for p in data['plugins'] if p['name'] == bn), None)
        if bp:
            plugins.append(bp)
envelope['plugins'] = plugins
with open('$staging/.claude-plugin/marketplace.json', 'w') as f:
    json.dump(envelope, f, indent=2)
    f.write('\n')
"

  # Create zip
  (cd "$staging" && zip -r "$DIST/extension/$name.zip" . > /dev/null 2>&1)
  SIZE=$(du -h "$DIST/extension/$name.zip" | cut -f1 | xargs)
  echo "  Created extension/$name.zip ($SIZE)"

  rm -rf "$staging"
done

# Full marketplace zip
(cd "$ROOT" && zip -r "$DIST/extension/benai-skills-marketplace.zip" .claude-plugin/marketplace.json plugins/ > /dev/null 2>&1)
SIZE=$(du -h "$DIST/extension/benai-skills-marketplace.zip" | cut -f1 | xargs)
echo "  Created extension/benai-skills-marketplace.zip ($SIZE)"

# =============================================================
# CLAUDE CONSOLE ZIPS (platform.claude.com)
# Structure: flat — SKILL.md + references/ at the root
# =============================================================
echo ""
echo "--- Building Claude Console zips ---"

echo "$PLUGINS_JSON" | while IFS='|' read -r name source; do
  # Skip plugins that are bundled into n8n
  if echo " $BUNDLE_INTO_N8N " | grep -q " $name "; then
    echo "  Skipping $name (bundled into n8n.zip)"
    continue
  fi

  staging="$TMP/claude-$name"
  rm -rf "$staging"
  mkdir -p "$staging"

  # Find the skills directory inside the plugin
  SKILL_DIR="$ROOT/$source/skills/$name"

  if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
    echo "  Skipping $name (no SKILL.md found at $SKILL_DIR)"
    continue
  fi

  # Copy into a single top-level folder named after the skill
  mkdir -p "$staging/$name"
  cp -R "$SKILL_DIR"/* "$staging/$name/" 2>/dev/null || true
  cp -R "$SKILL_DIR"/.[!.]* "$staging/$name/" 2>/dev/null || true

  # For n8n, also include bundled plugin skills
  if [ "$name" = "n8n" ]; then
    for bname in $BUNDLE_INTO_N8N; do
      bsource=$(echo "$PLUGINS_JSON" | grep "^${bname}|" | head -1 | cut -d'|' -f2)
      if [ -n "$bsource" ]; then
        BSKILL_DIR="$ROOT/$bsource/skills/$bname"
        if [ -f "$BSKILL_DIR/SKILL.md" ]; then
          mkdir -p "$staging/$bname"
          cp -R "$BSKILL_DIR"/* "$staging/$bname/" 2>/dev/null || true
          cp -R "$BSKILL_DIR"/.[!.]* "$staging/$bname/" 2>/dev/null || true
          find "$staging/$bname" -name ".gitkeep" -delete 2>/dev/null || true
          find "$staging/$bname" -type d -empty -delete 2>/dev/null || true
        fi
      fi
    done
  fi

  # Remove empty .gitkeep files
  find "$staging/$name" -name ".gitkeep" -delete 2>/dev/null || true

  # Remove empty directories
  find "$staging/$name" -type d -empty -delete 2>/dev/null || true

  # Create zip with skill folders as top-level entries
  (cd "$staging" && zip -r "$DIST/claude/$name.zip" . > /dev/null 2>&1)
  SIZE=$(du -h "$DIST/claude/$name.zip" | cut -f1 | xargs)
  echo "  Created claude/$name.zip ($SIZE)"

  rm -rf "$staging"
done

echo ""
echo "Done. All zips in $DIST/"
echo "  extension/ — for Claude Code, Cursor, VS Code"
echo "  claude/    — for Claude Console (platform.claude.com)"
