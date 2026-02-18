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

COMMANDS="$ROOT/commands"
AGENTS="$ROOT/agents"
CONNECTORS="$ROOT/connectors"

export ROOT SHARED SKILLS_MAP MARKETPLACE COMMANDS AGENTS CONNECTORS

python3 << 'PYEOF'
import json, os, shutil

root = os.environ.get("ROOT", "")
shared = os.environ.get("SHARED", "")
skills_map_path = os.environ.get("SKILLS_MAP", "")
marketplace_path = os.environ.get("MARKETPLACE", "")
commands_src = os.environ.get("COMMANDS", "")
agents_src = os.environ.get("AGENTS", "")
connectors_src = os.environ.get("CONNECTORS", "")

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

    with open(os.path.join(plugin_json_dir, "plugin.json"), "w") as f:
        json.dump(plugin_data, f, indent=2)
        f.write("\n")

    # --- .mcp.json ---
    connector_list = dept_config.get("connectors", [])
    if connector_list:
        mcp_servers = {}
        for conn_name in connector_list:
            conn_file = os.path.join(connectors_src, f"{conn_name}.json")
            if os.path.isfile(conn_file):
                with open(conn_file) as cf:
                    mcp_servers[conn_name] = json.load(cf)
            else:
                print(f"  Warning: connectors/{conn_name}.json not found, skipping")
        if mcp_servers:
            with open(os.path.join(dept_dir, ".mcp.json"), "w") as f:
                json.dump(mcp_servers, f, indent=2)
                f.write("\n")

    # --- commands/ ---
    commands_dir = os.path.join(dept_dir, "commands")
    os.makedirs(commands_dir, exist_ok=True)

    cmd_list = dept_config.get("commands", [])
    for cmd_name in cmd_list:
        src = os.path.join(commands_src, f"{cmd_name}.md")
        if os.path.isfile(src):
            shutil.copy2(src, os.path.join(commands_dir, f"{cmd_name}.md"))
        else:
            print(f"  Warning: commands/{cmd_name}.md not found, skipping")

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

    # --- agents/ ---
    agent_list = dept_config.get("agents", [])
    if agent_list:
        agents_dir = os.path.join(dept_dir, "agents")
        os.makedirs(agents_dir, exist_ok=True)
        agent_count = 0
        for agent_id in agent_list:
            src = os.path.join(agents_src, f"{agent_id}.md")
            if os.path.isfile(src):
                shutil.copy2(src, os.path.join(agents_dir, f"{agent_id}.md"))
                agent_count += 1
            else:
                print(f"  Warning: agents/{agent_id}.md not found, skipping")
        print(f"  {dept_name}: {agent_count} agents synced")

PYEOF

echo "Done. All department plugins generated from shared-skills/ and skills-map.json."
