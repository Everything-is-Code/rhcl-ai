# Agent governance — prácticas RHCL

Qué rescatamos de repos maduros con desarrollo **agent-first** (referencia: `lock_code_manager`) y qué adaptamos al programa RHCL.

## Qué rescatamos

| Práctica | lock_code_manager | RHCL (rhcl-ai) |
|----------|-------------------|----------------|
| **AGENTS.md maestro** | Guía única para todos los agentes | [AGENTS.md](../../AGENTS.md) |
| **CLAUDE.md delgado** | Apunta a AGENTS.md | [CLAUDE.md](../../CLAUDE.md) |
| **Reglas operativas** | "Run pytest before handback", pre-commit | Tests por stack antes de entregar (`go test`, `mvn test`) |
| **Git conventions** | No amend post-PR, tests con código | Igual en AGENTS.md |
| **Workspace multi-repo** | `../home-assistant/`, `../frontend/` | `rhcl/` con 3scaleextract, gateforge, rhcl-ai |
| **Script setup** | `scripts/setup` (venv, hooks, yarn) | [setup-rhcl-workspace.sh](../setup-rhcl-workspace.sh) |
| **PR template estructurado** | Tipo de cambio + breaking change | [pull_request_template.md](../../templates/github/.github/pull_request_template.md) |
| **Issues sin blank** | `blank_issues_enabled: false` | [config.yml](../../templates/github/.github/ISSUE_TEMPLATE/config.yml) |
| **Arquitectura en AGENTS** | Componentes, data flow, patterns | Resumen + links a `docs/architecture/` |
| **Testing philosophy** | "Mock at the boundary" | Tabla por repo en AGENTS.md |

## Qué no copiamos (aún)

| Práctica LCM | Por qué no aplica igual en RHCL |
|--------------|----------------------------------|
| **pre-commit / prek** | Tres stacks distintos (Go, Java, TS); CI por repo |
| **release-drafter + auto-merge** | rhcl-ai es docs; releases en 3scaleextract/gateforge por separado |
| **labeler automático por archivos** | Útil en gateforge/3scaleextract; backlog opcional post-M1 |
| **Codecov + mypy + ruff matrix** | Específico Python; gateforge usa Maven, 3scaleextract golangci-lint (EXT-4) |
| **Dependabot** | Recomendable después en cada repo de código |

## Roadmap opcional (post-M1)

1. **labeler.yml** en gateforge y 3scaleextract (`java`, `go`, `frontend`, `github-config`)
2. **Workflow reusable** `python-checks`-style → `go-checks.yml` / `java-checks.yml` compartidos desde rhcl-ai templates
3. **Dependabot** en los tres repos
4. **pre-commit** mínimo en rhcl-ai (markdownlint, yamllint en templates)

## Mantenimiento

Cuando el PO cambie convenciones:

1. Actualizar `AGENTS.md` (fuente de verdad)
2. Sincronizar rules Cursor si aplica (`.cursor/rules/rhcl-global.mdc`)
3. Comunicar al equipo: `git pull` en rhcl-ai + `./scripts/sync-cursor-config.sh`
