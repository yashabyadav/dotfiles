# Prints one line like: 1 - Edge | 2 - ChatGPT + Gmail | 3 - VS Code | …
$ErrorActionPreference = 'SilentlyContinue'

# Cache for "last active" titles, so names persist. Stored as a hashtable
# (not the PSCustomObject ConvertFrom-Json would give us) so ContainsKey/[] work.
$cachePath = Join-Path $env:LOCALAPPDATA 'glazewm_ws_cache.json'
$cache = @{}
if (Test-Path $cachePath) {
  try {
    $loaded = Get-Content $cachePath -Raw | ConvertFrom-Json
    if ($loaded) {
      $loaded.PSObject.Properties | ForEach-Object { $cache[$_.Name] = @{ lastActive = $_.Value.lastActive } }
    }
  } catch {}
}

function Shorten([string]$s, [int]$len=16) {
  if (-not $s) { return '' }
  $s = $s.Trim() -replace '\s+', ' '
  if ($s.Length -le $len) { return $s }
  return $s.Substring(0, $len-1) + '…'
}

# Recursively collect window nodes nested under a workspace (they may sit
# inside split containers rather than directly under the workspace).
function Get-WorkspaceWindows($workspace) {
  $result = New-Object System.Collections.Generic.List[object]
  function Walk($n) {
    if (-not $n) { return }
    if ($n.type -eq 'window') { $result.Add($n); return }
    if ($n.children) { foreach ($c in $n.children) { Walk $c } }
  }
  if ($workspace.children) { foreach ($c in $workspace.children) { Walk $c } }
  return $result
}

$raw = glazewm query workspaces
$workspaces = @()
try { $workspaces = ($raw | ConvertFrom-Json).data.workspaces } catch {}
if (-not $workspaces) { $workspaces = @() }

$labels = New-Object System.Collections.Generic.List[string]

foreach ($ws in $workspaces | Sort-Object { [int]$_.name }) {
  $wsId  = $ws.id
  $index = $ws.name

  $wsWins = Get-WorkspaceWindows $ws

  # Prefer focused window in that workspace; else cached lastActive; else first title
  $focused = $wsWins | Where-Object { $_.hasFocus -eq $true } | Select-Object -First 1

  $title1 = $null
  $title2 = $null

  if ($focused) {
    $title1 = $focused.title
    $title2 = ($wsWins | Where-Object { $_.id -ne $focused.id -and $_.title } | Select-Object -ExpandProperty title -First 1)
    $cache["$wsId"] = @{ lastActive = $title1 }
  } else {
    if ($cache.ContainsKey("$wsId")) { $title1 = $cache["$wsId"].lastActive }
    if (-not $title1) { $title1 = ($wsWins | Where-Object { $_.title } | Select-Object -ExpandProperty title -First 1) }
    $title2 = ($wsWins | Where-Object { $_.title -and $_.title -ne $title1 } | Select-Object -ExpandProperty title -First 1)
  }

  $t1 = Shorten $title1
  $t2 = Shorten $title2 12
  $name = if ($t1 -and $t2) { "$index - $t1 + $t2" }
          elseif ($t1)      { "$index - $t1" }
          else              { "$index" }

  $labels.Add($name)
}

# Persist cache and print line for ZeBar
try { $cache | ConvertTo-Json -Depth 5 | Set-Content -Path $cachePath -Encoding UTF8 } catch {}
$sep = '  |  '
$labels -join $sep
