#!/bin/bash
#
# Builds distributable zip files for the BenAI skills marketplace.
# Reads marketplace.json, detects all plugins, and generates:
#   dist/benai-skills-marketplace.zip  (all plugins)
#   dist/<plugin-name>.zip             (one plugin each)
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

# Clean and create dist
rm -rf "$DIST"
mkdir -p "$DIST"

# Read all plugins from marketplace.json
PLUGINS_JSON=$(python3 -c "
import json, sys
with open('$MARKETPLACE') as f:
    data = json.load(f)
for p in data['plugins']:
    print(p['name'] + '|' + p['source'])
")

# Read the marketplace envelope (everything except plugins array)
MARKETPLACE_ENVELOPE=$(python3 -c "
import json
with open('$MARKETPLACE') as f:
    data = json.load(f)
envelope = {k: v for k, v in data.items() if k != 'plugins'}
print(json.dumps(envelope, indent=2))
")

echo "Found plugins:"
echo "$PLUGINS_JSON" | while IFS='|' read -r name source; do
  echo "  - $name ($source)"
done
echo ""

# --- Build individual plugin zips ---
echo "$PLUGINS_JSON" | while IFS='|' read -r name source; do
  staging="$TMP/$name"
  rm -rf "$staging"
  mkdir -p "$staging/.claude-plugin"
  mkdir -p "$staging/$(dirname "$source")"

  # Copy the plugin directory
  cp -R "$ROOT/$source" "$staging/$source"

  # Generate a marketplace.json with only this plugin
  python3 -c "
import json
with open('$MARKETPLACE') as f:
    data = json.load(f)
envelope = {k: v for k, v in data.items() if k != 'plugins'}
plugin = next(p for p in data['plugins'] if p['name'] == '$name')
envelope['plugins'] = [plugin]
with open('$staging/.claude-plugin/marketplace.json', 'w') as f:
    json.dump(envelope, f, indent=2)
    f.write('\n')
"

  # Create zip
  (cd "$staging" && zip -r "$DIST/$name.zip" . > /dev/null 2>&1)
  SIZE=$(du -h "$DIST/$name.zip" | cut -f1 | xargs)
  echo "Created $name.zip ($SIZE)"

  rm -rf "$staging"
done

# --- Build full marketplace zip ---
(cd "$ROOT" && zip -r "$DIST/benai-skills-marketplace.zip" .claude-plugin/marketplace.json plugins/ > /dev/null 2>&1)
SIZE=$(du -h "$DIST/benai-skills-marketplace.zip" | cut -f1 | xargs)
echo "Created benai-skills-marketplace.zip ($SIZE)"

echo ""
echo "Done. All zips in $DIST/"
