# RHCL AI — Contexto, skills y lineamientos

Repositorio central del programa **Red Hat Connectivity Link (RHCL)**: migración de **3scale API Management** a **Connectivity Link (Kuadrant)**.

## Ecosistema

| Repo | Rol |
|------|-----|
| [3scaleextract](https://github.com/Everything-is-Code/3scaleextract) | Export híbrido, seed de lab, visualize |
| [gateforge](https://github.com/Everything-is-Code/gateforge) | Plataforma de migración (Quarkus + Angular) |
| **rhcl-ai** (este repo) | Docs transversales, Cursor rules/skills, templates GitHub |

## Layout del workspace recomendado

```
rhcl/
├── 3scaleextract/
├── gateforge/
└── rhcl-ai/          ← este repo
```

## Uso con Cursor

**Guía completa:** [docs/ai/cursor-setup.md](docs/ai/cursor-setup.md)

Resumen:

1. Clonar los tres repos bajo un directorio `rhcl/`.
2. Enlazar o copiar `.cursor` desde este repo a la raíz del workspace:
   ```bash
   cd rhcl && ln -s rhcl-ai/.cursor .cursor
   # Windows / sin symlink: ./rhcl-ai/scripts/sync-cursor-config.sh
   ```
3. Abrir la carpeta **`rhcl/`** en Cursor (no un subrepo suelto).
4. Verificar rules en **Settings → Rules** (`rhcl-global`, `gateforge-java`, `3scaleextract-go`).

Ver también [AGENTS.md](AGENTS.md) para instrucciones globales de agentes.

## Documentación

| Área | Path |
|------|------|
| Pipeline general | [docs/architecture/pipeline-overview.md](docs/architecture/pipeline-overview.md) |
| Contrato export v1 | [docs/architecture/export-schema-v1.md](docs/architecture/export-schema-v1.md) |
| Mapping 3scale → CL | [docs/architecture/3scale-to-cl-mapping.md](docs/architecture/3scale-to-cl-mapping.md) |
| **Configurar Cursor** | [docs/ai/cursor-setup.md](docs/ai/cursor-setup.md) |
| LangChain4j / AI | [docs/ai/gateforge-langchain4j.md](docs/ai/gateforge-langchain4j.md) |
| MCP tools | [docs/ai/mcp-tools-gateforge.md](docs/ai/mcp-tools-gateforge.md) |
| Lab local | [docs/workflows/local-lab-setup.md](docs/workflows/local-lab-setup.md) |
| Pipeline seed → migrate | [docs/workflows/seed-export-visualize-migrate.md](docs/workflows/seed-export-visualize-migrate.md) |

## Templates GitHub

Copiar desde [`templates/github/`](templates/github/) a cada repo:

```bash
cp -r templates/github/.github ../3scaleextract/
cp -r templates/github/.github ../gateforge/
```

## Milestones del programa

| Milestone | Objetivo |
|-----------|----------|
| **M1 — Test foundation** | CI corre tests; cobertura mínima en paths críticos |
| **M2 — Integration offline** | GateForge importa export v1 |
| **M3 — E2E lab** | Pipeline seed→export→migrate documentado y automatizable |

## Licencia

Apache 2.0 — ver [LICENSE](LICENSE).
