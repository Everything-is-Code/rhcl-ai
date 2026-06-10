# Instrucciones para agentes — RHCL

Eres un agente que trabaja en el programa de migración **3scale → Connectivity Link (Kuadrant)**.

## Repos del ecosistema

- **3scaleextract** (Go): `threescale-export`, `threescale-seed`, `threescale-visualize`
- **gateforge** (Java/Quarkus + Angular): descubrimiento live, análisis, apply/revert Kuadrant
- **rhcl-ai**: documentación, skills, templates — **lee aquí antes de tocar código transversal**

## Reglas generales

1. **No commitear secretos** — tokens 3scale, kubeconfigs, client secrets OIDC.
2. **Tests obligatorios** en PRs que toquen lógica de negocio; GateForge no debe usar `-DskipTests` en CI.
3. **Export offline** usa `schema_version: "1.0"` — ver [docs/architecture/export-schema-v1.md](docs/architecture/export-schema-v1.md).
4. **Cambios de contrato export** requieren actualizar rhcl-ai + tests en ambos repos.
5. **Idioma**: issues y docs técnicos en español o inglés según el repo; código e identificadores en inglés.

## Prioridades PO

| Prioridad | Área |
|-----------|------|
| P0 | Tests GateForge (MigrationService, CI sin skipTests) |
| P1 | Integración offline export → GateForge |
| P2 | E2E lab, visualize metrics, UI import |
| P3 | Hygiene (LICENSE, module path, templates) |

## Skills disponibles

| Skill | Cuándo usarlo |
|-------|---------------|
| `lab-pipeline-seed-export-migrate` | Lab, demos, E2E |
| `gateforge-migration` | Cambios en MigrationService, kuadrantctl, estrategias gateway |
| `3scale-export-schema` | Parser export, visualize, contrato v1 |
| `pr-review-rhcl` | Revisión de PRs del equipo |

## Configurar Cursor (devs)

Antes de codear, configurá rules y skills desde este repo. Guía paso a paso:

**[docs/ai/cursor-setup.md](docs/ai/cursor-setup.md)**

Resumen: workspace `rhcl/` con los 3 repos → enlace `rhcl-ai/.cursor` → abrir `rhcl/` en Cursor.

## Flujo de trabajo coder

1. Tomar issue con label `area/*` y milestone asignado.
2. Branch desde `main`: `feature/EXT-1-seed-mock-tests` o similar.
3. PR con template de [templates/github/pull_request_template.md](templates/github/pull_request_template.md).
4. PO revisa con checklist `pr-review-rhcl`.

## Referencias externas

- [3scaleextract README](https://github.com/Everything-is-Code/3scaleextract)
- [gateforge README](https://github.com/Everything-is-Code/gateforge)
- Red Hat toolbox: `registry.redhat.io/3scale-amp2/toolbox-rhel9:3scale2.16`
