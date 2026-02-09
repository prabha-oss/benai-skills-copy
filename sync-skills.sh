#!/bin/bash
#
# Generates the entire plugins/ directory from shared-skills/ and .claude-plugin/skills-map.json.
# Everything under plugins/ is disposable — this script recreates it from scratch.
#
# Usage: ./sync-skills.sh

set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SHARED="$ROOT/shared-skills"
SKILLS_MAP="$ROOT/.claude-plugin/skills-map.json"
MARKETPLACE="$ROOT/.claude-plugin/marketplace.json"

if [ ! -d "$SHARED" ]; then
  echo "Error: shared-skills/ directory not found" >&2
  exit 1
fi

if [ ! -f "$SKILLS_MAP" ]; then
  echo "Error: .claude-plugin/skills-map.json not found" >&2
  exit 1
fi

if [ ! -f "$MARKETPLACE" ]; then
  echo "Error: .claude-plugin/marketplace.json not found" >&2
  exit 1
fi

# Wipe and regenerate plugins/
rm -rf "$ROOT/plugins"
mkdir -p "$ROOT/plugins"

export ROOT SHARED SKILLS_MAP MARKETPLACE

python3 << 'PYEOF'
import json, os, shutil

root = os.environ.get("ROOT", "")
shared = os.environ.get("SHARED", "")
skills_map_path = os.environ.get("SKILLS_MAP", "")
marketplace_path = os.environ.get("MARKETPLACE", "")

with open(skills_map_path) as f:
    skills_map = json.load(f)

with open(marketplace_path) as f:
    marketplace = json.load(f)

# Index marketplace plugins by name
marketplace_plugins = {p["name"]: p for p in marketplace["plugins"]}
departments = skills_map["departments"]

for dept_name, dept_config in departments.items():
    dept_dir = os.path.join(root, "plugins", dept_name)
    skills = dept_config["skills"]  # dict of skill_id -> {displayName, summary}

    # --- .claude-plugin/plugin.json ---
    plugin_json_dir = os.path.join(dept_dir, ".claude-plugin")
    os.makedirs(plugin_json_dir, exist_ok=True)

    mp = marketplace_plugins.get(dept_name, {})
    plugin_data = {
        "name": dept_name,
        "description": mp.get("description", ""),
        "version": mp.get("version", "1.0.0"),
        "author": mp.get("author", {"name": "BenAI"}),
    }

    if "mcpServers" in dept_config:
        plugin_data["mcpServers"] = dept_config["mcpServers"]

    with open(os.path.join(plugin_json_dir, "plugin.json"), "w") as f:
        json.dump(plugin_data, f, indent=2)
        f.write("\n")

    # --- commands/benai-start.md ---
    commands_dir = os.path.join(dept_dir, "commands")
    os.makedirs(commands_dir, exist_ok=True)

    title = dept_name.capitalize()
    rows = []
    for skill_id, meta in skills.items():
        display = meta.get("displayName", skill_id)
        summary = meta.get("summary", "")
        rows.append(f"| {display} | `/{skill_id}` | {summary} |")

    table = "\n".join(rows)
    benai_md = f"""---
description: See all {title} skills and get started
---

# BenAI {title}

You have the following {dept_name} skills available. Present them to the user in a clean table and ask what they'd like to work on:

| Skill | Command | What it does |
|-------|---------|-------------|
{table}

Ask the user which skill they want to use, then invoke that skill's slash command.
"""

    with open(os.path.join(commands_dir, "benai-start.md"), "w") as f:
        f.write(benai_md)

    # --- skills/ ---
    skills_dir = os.path.join(dept_dir, "skills")
    os.makedirs(skills_dir, exist_ok=True)

    count = 0
    for skill_id in skills:
        src = os.path.join(shared, skill_id)
        dst = os.path.join(skills_dir, skill_id)
        if os.path.isdir(src):
            shutil.copytree(src, dst)
            count += 1
        else:
            print(f"  Warning: shared-skills/{skill_id} not found, skipping")

    print(f"  {dept_name}: {count} skills synced")

PYEOF

echo "Done. All department plugins generated from shared-skills/ and skills-map.json."
