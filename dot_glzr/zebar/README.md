- to display workspace name, I used chatGPT. I added this code block in the `settings.json` file:
```json
{
  "type": "script",
  "name": "Workspaces+Titles",
  "interval_ms": 1000,
  "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"$env:USERPROFILE\\.config\\glazewm\\scripts\\workspace-labels.ps1\"",
  "on_click": {
    "action": "shell",
    "command": "glazewm command workspace focus {index}"
  },
  "font_size": 12,
  "padding": "6 10"
}
```
Notes:

interval_ms controls how often ZeBar runs the script (1000 ms is smooth without being wasteful).

The optional on_click block uses the {index} token if you split the string and wire per-workspace clicks. If you don’t need click-to-focus, drop that block.

If you want icons per app, you can map common titles to emojis in the PowerShell script before Shorten.
