# Cursor setup — RHCL rules and skills

Developer guide for the **3scale → Connectivity Link** program. Official rules and skills live in this repo ([`rhcl-ai`](https://github.com/Everything-is-Code/rhcl-ai)).

**All rules, skills, and agent docs must be written in English.**

## What rhcl-ai includes

```
rhcl-ai/
├── AGENTS.md                 # Global agent instructions
└── .cursor/
    ├── rules/                # Persistent rules (.mdc)
    │   ├── rhcl-global.mdc   # Always active (whole program)
    │   ├── gateforge-java.mdc
    │   └── 3scaleextract-go.mdc
    └── skills/               # Agent-invokable skills
        ├── pr-review-rhcl/
        ├── gateforge-migration/
        ├── 3scale-export-schema/
        └── lab-pipeline-seed-export-migrate/
```

| Rule | When it applies |
|------|-----------------|
| `rhcl-global.mdc` | **Always** (`alwaysApply: true`) |
| `gateforge-java.mdc` | Files under `gateforge/**` |
| `3scaleextract-go.mdc` | Files under `3scaleextract/**` |

---

## Prerequisite: workspace layout

Cursor reads `.cursor/rules/` from the **workspace root** you have open. Use a parent directory with all three repos:

```
rhcl/                          ← open THIS folder in Cursor
├── 3scaleextract/
├── gateforge/
├── rhcl-ai/
└── .cursor/                   ← linked or copied rules/skills (see below)
    ├── rules/
    └── skills/
```

Clone repos:

```bash
mkdir rhcl && cd rhcl
git clone https://github.com/Everything-is-Code/3scaleextract.git
git clone https://github.com/Everything-is-Code/gateforge.git
git clone https://github.com/Everything-is-Code/rhcl-ai.git
```

Or run: `./rhcl-ai/scripts/setup-rhcl-workspace.sh`

---

## Option A — Recommended: multi-repo workspace + link to rhcl-ai

Link the parent workspace `.cursor` to `rhcl-ai/.cursor` so you always get the latest AI repo version.

### Linux / macOS

```bash
cd rhcl
ln -s rhcl-ai/.cursor .cursor
ln -s rhcl-ai/AGENTS.md AGENTS.md   # optional
```

### Windows (PowerShell; admin terminal if symlink fails)

```powershell
cd rhcl
New-Item -ItemType SymbolicLink -Path .cursor -Target rhcl-ai\.cursor
```

If symlinks are not available, use **Option B** (copy).

### Workspace file (optional)

Copy [`templates/rhcl.code-workspace.example`](../templates/rhcl.code-workspace.example) to `rhcl/rhcl.code-workspace` and open it via **File → Open Workspace from File**.

---

## Option B — Copy rules/skills to workspace root

Useful on Windows without symlink permissions or ephemeral CI.

```bash
cd rhcl
./rhcl-ai/scripts/sync-cursor-config.sh
```

Windows:

```powershell
.\rhcl-ai\scripts\sync-cursor-config.ps1
```

Re-run after each `git pull` in `rhcl-ai` when using copy (not symlink).

---

## Option C — Single repo open (gateforge or 3scaleextract)

If you open only `gateforge/` or `3scaleextract/` as the workspace:

1. Copy relevant rules into that repo:

```bash
# From gateforge/
mkdir -p .cursor/rules .cursor/skills
cp ../rhcl-ai/.cursor/rules/rhcl-global.mdc .cursor/rules/
cp ../rhcl-ai/.cursor/rules/gateforge-java.mdc .cursor/rules/
cp -r ../rhcl-ai/.cursor/skills/* .cursor/skills/
```

2. Adjust glob in `gateforge-java.mdc` from `gateforge/**/*` to `**/*` if needed.

3. Copy or symlink `AGENTS.md` to the repo root.

---

## Verify Cursor loads rules

1. Open **`rhcl/`** (not a single subrepo) with `.cursor` linked or copied.
2. In Cursor: **Settings → Cursor Settings → Rules** (or **Rules** in the Agent sidebar).
3. You should see:
   - `rhcl-global` — Always
   - `gateforge-java` — when editing files under `gateforge/`
   - `3scaleextract-go` — when editing files under `3scaleextract/`
4. Open `gateforge/backend/.../MigrationService.java` and confirm `gateforge-java` is active.

### Quick chat test

Ask the Agent:

> What RHCL rules are active and what is the offline export schema_version?

The agent should mention `1.0` and `rhcl-global` conventions.

---

## Skills

Skills live in `.cursor/skills/<name>/SKILL.md`. Cursor discovers them via frontmatter `description` — no manual registration if `.cursor/skills/` is at the workspace root.

| Skill | Typical invocation |
|-------|-------------------|
| `pr-review-rhcl` | "Review this PR against RHCL standards" |
| `gateforge-migration` | "Add tests for MigrationService.analyze" |
| `3scale-export-schema` | "Parse this export v1 manifest.json" |
| `lab-pipeline-seed-export-migrate` | "Run seed → export → visualize pipeline" |

Reference skills with `@` if your Cursor version supports it.

---

## AGENTS.md

[AGENTS.md](../../AGENTS.md) complements rules with program context (PO priorities, issue flow, repos). Cursor uses it as project instructions when at the workspace root.

---

## Updating rules/skills (PO team)

1. Changes land in **rhcl-ai** via PR.
2. After merge, each dev runs `git pull` in `rhcl-ai`:
   - symlink: automatic
   - copy: `./rhcl-ai/scripts/sync-cursor-config.sh`
3. Announce new rules or export contract changes in the team channel.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| No rules in Settings | Workspace is a subrepo; open parent `rhcl/` |
| Rules not applied to Go/Java files | Globs assume `rhcl/` root; check `gateforge/**`, `3scaleextract/**` |
| Symlink fails on Windows | Option B (copy) or admin PowerShell |
| Skills not invoked | Confirm `.cursor/skills/` at workspace root, not only inside unlinked `rhcl-ai/` |
| Agent ignores export schema | Open an export file or mention `@3scale-export-schema` |

---

## References

- [AGENTS.md](../../AGENTS.md)
- [local-lab-setup.md](../workflows/local-lab-setup.md)
- [Cursor docs — Rules](https://docs.cursor.com/context/rules)
