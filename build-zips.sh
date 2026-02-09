#!/bin/bash
#
# Builds distributable zip files for BenAI skills.
# Reads marketplace.json, detects all department plugins, and generates:
#
#   dist/extension/                      Claude Code extension (Cursor, VS Code)
#     ├── <department>.zip               One department per zip (marketplace format)
#     └── benai-skills-marketplace.zip   All departments in one zip
#
#   dist/claude/                         Claude Console (platform.claude.com)
#     └── <department>.zip               Flat skill zips (SKILL.md + references)
#
# Usage: ./build-zips.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"

# Sync skills from _shared/ into department plugins before building
"$ROOT/sync-skills.sh"
echo ""
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

# Read all plugins from marketplace.json
PLUGINS_JSON=$(python3 -c "
import json, sys
with open('$MARKETPLACE') as f:
    data = json.load(f)
for p in data['plugins']:
    print(p['name'] + '|' + p['source'])
")

echo "Found department plugins:"
echo "$PLUGINS_JSON" | while IFS='|' read -r name source; do
  echo "  - $name ($source)"
done
echo ""

# =============================================================
# EXTENSION ZIPS (Claude Code / Cursor / VS Code)
# Structure: .claude-plugin/marketplace.json + plugins/<department>/
# =============================================================
echo "--- Building extension zips ---"

echo "$PLUGINS_JSON" | while IFS='|' read -r name source; do
  staging="$TMP/ext-$name"
  rm -rf "$staging"
  mkdir -p "$staging/.claude-plugin"
  mkdir -p "$staging/$(dirname "$source")"

  # Copy the department plugin directory
  cp -R "$ROOT/$source" "$staging/$source"

  # Generate a marketplace.json with this department
  python3 -c "
import json
with open('$MARKETPLACE') as f:
    data = json.load(f)
envelope = {k: v for k, v in data.items() if k != 'plugins'}
envelope['name'] = data['name'] + '-$name'
plugin = next(p for p in data['plugins'] if p['name'] == '$name')
envelope['plugins'] = [plugin]
with open('$staging/.claude-plugin/marketplace.json', 'w') as f:
    json.dump(envelope, f, indent=2)
    f.write('\n')
"

  # Remove .gitkeep files and empty directories
  find "$staging" -name ".gitkeep" -delete 2>/dev/null || true
  find "$staging" -type d -empty -delete 2>/dev/null || true

  # Create zip
  (cd "$staging" && zip -r "$DIST/extension/$name.zip" . > /dev/null 2>&1)
  SIZE=$(du -h "$DIST/extension/$name.zip" | cut -f1 | xargs)
  SKILL_COUNT=$(find "$staging/$source/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | xargs)
  echo "  Created extension/$name.zip ($SIZE) — $SKILL_COUNT skills"

  rm -rf "$staging"
done

# Full marketplace zip
(cd "$ROOT" && zip -r "$DIST/extension/benai-skills-marketplace.zip" .claude-plugin/marketplace.json plugins/ -x "*/\.*" > /dev/null 2>&1)
SIZE=$(du -h "$DIST/extension/benai-skills-marketplace.zip" | cut -f1 | xargs)
echo "  Created extension/benai-skills-marketplace.zip ($SIZE)"

# =============================================================
# CLAUDE CONSOLE ZIPS (platform.claude.com)
# Structure: flat — each skill as top-level folder (SKILL.md + references)
# =============================================================
echo ""
echo "--- Building Claude Console zips ---"

echo "$PLUGINS_JSON" | while IFS='|' read -r name source; do
  staging="$TMP/claude-$name"
  rm -rf "$staging"
  mkdir -p "$staging"

  SKILLS_DIR="$ROOT/$source/skills"

  if [ ! -d "$SKILLS_DIR" ]; then
    echo "  Skipping $name (no skills/ directory)"
    continue
  fi

  # Copy each skill as a top-level folder
  for skill_dir in "$SKILLS_DIR"/*/; do
    skill_name=$(basename "$skill_dir")
    if [ -f "$skill_dir/SKILL.md" ]; then
      mkdir -p "$staging/$skill_name"
      cp -R "$skill_dir"/* "$staging/$skill_name/" 2>/dev/null || true
      cp -R "$skill_dir"/.[!.]* "$staging/$skill_name/" 2>/dev/null || true

      # Remove .gitkeep files and empty directories
      find "$staging/$skill_name" -name ".gitkeep" -delete 2>/dev/null || true
      find "$staging/$skill_name" -type d -empty -delete 2>/dev/null || true
    fi
  done

  # Create zip with skill folders as top-level entries
  (cd "$staging" && zip -r "$DIST/claude/$name.zip" . > /dev/null 2>&1)
  SIZE=$(du -h "$DIST/claude/$name.zip" | cut -f1 | xargs)
  SKILL_COUNT=$(find "$staging" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | xargs)
  echo "  Created claude/$name.zip ($SIZE) — $SKILL_COUNT skills"

  rm -rf "$staging"
done

echo ""
echo "Done. All zips in $DIST/"
echo "  extension/   — for Claude Code, Cursor, VS Code"
echo "  claude/      — for Claude Console (platform.claude.com)"
