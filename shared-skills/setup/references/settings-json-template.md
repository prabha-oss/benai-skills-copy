```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/persist-session.sh",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```
