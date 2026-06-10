#!/usr/bin/env bash
# Sync .cursor rules/skills from rhcl-ai to workspace parent (rhcl/).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE="$(cd "$ROOT/.." && pwd)"

if [[ ! -d "$WORKSPACE/3scaleextract" || ! -d "$WORKSPACE/gateforge" ]]; then
  echo "Error: run from rhcl/ layout (3scaleextract + gateforge siblings expected)" >&2
  exit 1
fi

rm -rf "$WORKSPACE/.cursor"
cp -r "$ROOT/.cursor" "$WORKSPACE/.cursor"

if [[ ! -e "$WORKSPACE/AGENTS.md" ]]; then
  cp "$ROOT/AGENTS.md" "$WORKSPACE/AGENTS.md"
fi

echo "Synced .cursor and AGENTS.md to $WORKSPACE"
