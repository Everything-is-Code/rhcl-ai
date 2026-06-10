#!/usr/bin/env bash
# Bootstrap RHCL workspace: clone product repos + sync Cursor config.
set -euo pipefail

ORG="Everything-is-Code"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE="$(cd "$ROOT/.." && pwd)"

clone_if_missing() {
  local name="$1"
  local dir="$WORKSPACE/$name"
  if [[ -d "$dir/.git" ]]; then
    echo "==> $name already cloned"
  else
    echo "==> Cloning $name"
    git clone "https://github.com/$ORG/$name.git" "$dir"
  fi
}

echo "RHCL workspace root: $WORKSPACE"
clone_if_missing "3scaleextract"
clone_if_missing "gateforge"

if [[ ! -d "$WORKSPACE/rhcl-ai/.git" ]]; then
  if [[ "$ROOT" != "$WORKSPACE/rhcl-ai" ]]; then
    echo "==> Cloning rhcl-ai"
    git clone "https://github.com/$ORG/rhcl-ai.git" "$WORKSPACE/rhcl-ai"
  fi
fi

RHCL_AI="$WORKSPACE/rhcl-ai"
if [[ -d "$RHCL_AI/scripts" ]]; then
  bash "$RHCL_AI/scripts/sync-cursor-config.sh"
else
  echo "Warning: sync-cursor-config.sh not found" >&2
fi

cat <<EOF

Done. Next steps:
  1. Open folder '$WORKSPACE' in Cursor
  2. Verify rules in Settings -> Rules (rhcl-global, gateforge-java, 3scaleextract-go)
  3. Read AGENTS.md and docs/ai/cursor-setup.md

EOF
