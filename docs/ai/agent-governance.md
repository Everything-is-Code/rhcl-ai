# Agent governance — RHCL practices

What we adopt from mature **agent-first** repos (reference: `lock_code_manager`) and how we adapt it for RHCL.

**Language:** All agent-facing content in rhcl-ai is **English only**. Sibling product repos must follow the same policy (see tracking issue for 3scaleextract Spanish README).

## What we adopt

| Practice | lock_code_manager | RHCL (rhcl-ai) |
|----------|-------------------|----------------|
| **Master AGENTS.md** | Single guide for all agents | [AGENTS.md](../../AGENTS.md) |
| **Thin CLAUDE.md** | Points to AGENTS.md | [CLAUDE.md](../../CLAUDE.md) |
| **Operational rules** | "Run pytest before handback", pre-commit | Per-stack tests before handback (`go test`, `mvn test`) |
| **Git conventions** | No amend post-PR, tests with code | Same in AGENTS.md |
| **Multi-repo workspace** | `../home-assistant/`, `../frontend/` | `rhcl/` with 3scaleextract, gateforge, rhcl-ai |
| **Setup script** | `scripts/setup` | [setup-rhcl-workspace.sh](../setup-rhcl-workspace.sh) |
| **Structured PR template** | Change type + breaking change | [pull_request_template.md](../../templates/github/.github/pull_request_template.md) |
| **No blank issues** | `blank_issues_enabled: false` | [config.yml](../../templates/github/.github/ISSUE_TEMPLATE/config.yml) |
| **Architecture in AGENTS** | Components, data flow, patterns | Summary + links to `docs/architecture/` |
| **Testing philosophy** | "Mock at the boundary" | Per-repo table in AGENTS.md |
| **English-only agent context** | Implicit in LCM | Explicit policy in AGENTS.md + rules |

## What we do not copy (yet)

| LCM practice | Why not identical in RHCL |
|--------------|---------------------------|
| **pre-commit / prek** | Three stacks (Go, Java, TS); CI per repo |
| **release-drafter + auto-merge** | rhcl-ai is docs; releases in 3scaleextract/gateforge separately |
| **File-based labeler** | Useful in gateforge/3scaleextract; optional post-M1 |
| **Codecov + mypy matrix** | Python-specific; gateforge uses Maven, 3scaleextract golangci-lint (EXT-4) |
| **Dependabot** | Recommended later per code repo |

## Optional roadmap (post-M1)

1. **labeler.yml** in gateforge and 3scaleextract (`java`, `go`, `frontend`, `github-config`)
2. Reusable workflows from rhcl-ai templates (`go-checks.yml`, `java-checks.yml`)
3. **Dependabot** in all three repos
4. Minimal **pre-commit** in rhcl-ai (markdownlint, yamllint on templates)

## Maintenance

When PO changes conventions:

1. Update `AGENTS.md` (source of truth)
2. Sync Cursor rules (`.cursor/rules/rhcl-global.mdc`)
3. Notify team: `git pull` in rhcl-ai + `./scripts/sync-cursor-config.sh`
4. Keep all changes in **English**
