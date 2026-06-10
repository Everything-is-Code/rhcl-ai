# Sync .cursor rules/skills from rhcl-ai to workspace parent (rhcl/).
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Workspace = Split-Path -Parent $Root

if (-not (Test-Path "$Workspace\3scaleextract") -or -not (Test-Path "$Workspace\gateforge")) {
    Write-Error "Expected rhcl/ layout with 3scaleextract and gateforge as siblings."
}

if (Test-Path "$Workspace\.cursor") {
    Remove-Item -Recurse -Force "$Workspace\.cursor"
}
Copy-Item -Recurse "$Root\.cursor" "$Workspace\.cursor"

if (-not (Test-Path "$Workspace\AGENTS.md")) {
    Copy-Item "$Root\AGENTS.md" "$Workspace\AGENTS.md"
}

Write-Host "Synced .cursor and AGENTS.md to $Workspace"
