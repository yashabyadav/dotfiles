# Prints one line like: 1 - Edge | 2 - ChatGPT + Gmail | 3 - VS Code | …
$ErrorActionPreference = 'SilentlyContinue'

# Cache for "last active" titles, so names persist
$cachePath = Join-Path $env:LOCALAPPDATA 'glazewm_ws_cache.json'
$cache = @{}
if (Test-Path $cachePath) { try { $cache = Get-Content $cachePath -Raw | ConvertFrom-Json } catch {} }
if (-not $cache) { $cache = @{} }

function Shorten([string]$s, [int]$len=16) {
  if (-not $s) { return '' }
  $s = $s.Trim() -replace '\s+', ' '
  if ($s.Length -le $len) { return $s }
  return $s.Substring(0, $len-1) + '…'
}

# --- Helpers to read GlazeWM state across versions ---
function Get-Ws {
  $raw = glazewm query workspaces
  try { return ($raw | ConvertFrom-Json) } catch { return @() }
}
function Get-Windows {
  # Try direct "windows" first (newer builds), else parse "tree" (older builds)
  $raw = glazewm query windows
  $json = $null
  try { $json = ($raw | ConvertFrom-Json) } catch {}
  if ($json) { return $json }

  $raw2 = glazewm query tree
  try {
    $tree = ($raw2 | ConvertFrom-Json)
    # Flatten any windows in the tree to a simple list having id, title, workspace_id, is_focused
    $list = New-Object System.Collections.Generic.List[object]
    function Walk($n) {
      if ($n -and $n.windows) {
        foreach ($w in $n.windows) { $list.Add($w) }
      }
      if ($n -and $n.nodes) { foreach ($c in $n.nodes) { Walk $c } }
    }
    Walk $tree
    return $list
  } catch { return @() }
}

$workspaces = Get-Ws
$windows    = Get-Windows

# Build lookup: workspace_id -> windows[]
$byWs = @{}
foreach ($w in $windows) {
  $wsId = $w.workspace_id
  if (-not $wsId) { continue }
  if (-not $byWs.ContainsKey($wsId)) { $byWs[$wsId] = New-Object System.Collections.ArrayList }
  [void]$byWs[$wsId].Add($w)
}

$labels = New-Object System.Collections.Generic.List[string]

foreach ($ws in $workspaces | Sort-Object index) {
  $wsId  = $ws.id
  $index = $ws.index

  $wsWins = @()
  if ($byWs.ContainsKey($wsId)) { $wsWins = $byWs[$wsId] }

  # Prefer focused window in that workspace; else cached lastActive; else first title
  $focused = $wsWins | Where-Object { $_.is_focused -eq $true } | Select-Object -First 1

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

