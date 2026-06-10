# Workflow: Seed → Export → Visualize → Migrate

Pipeline de validación end-to-end para el programa RHCL.

## Objetivo

Validar que fixtures de lab en 3scale se exportan correctamente y GateForge puede analizarlos (live hoy; offline con INT-2/3).

## Script rápido (3scaleextract)

```bash
cd 3scaleextract
source scripts/load-env.sh   # o export THREESCALE_* manualmente
./scripts/demo/seed-and-export.sh
```

Genera `./export/manifest.json` y árbol completo.

## Visualize

```bash
bin/threescale-visualize ./export -o ./report
open report/index.md
```

Revisar:
- Auth matrix por producto
- Diagrama Mermaid topology
- Backend ↔ product refs

## GateForge — flujo live (actual)

1. Configurar misma URL/token 3scale en GateForge Settings.
2. Migration Wizard → seleccionar productos `seed_*`.
3. Estrategia `shared` → Analyze → revisar plan y warnings OIDC.
4. (Opcional) Apply en cluster lab con Connectivity Link instalado.

## GateForge — flujo offline (planned INT-2/3)

```http
POST /api/migration/import-export
Content-Type: multipart/form-data

file: export.tar.gz   # manifest v1.0 + tree
```

Luego wizard continúa con productos parseados sin Admin API.

## Checklist E2E (INT-6)

- [ ] Seed 4 productos sin error
- [ ] Export `incomplete: false`
- [ ] Visualize report generado
- [ ] GateForge analyze produce AuthPolicy por auth mode
- [ ] Warning OIDC si issuer placeholder
- [ ] `seed_multi_backend` genera HTTPRoute multi-rule (sin kuadrantctl)

## Troubleshooting

| Problema | Acción |
|----------|--------|
| Toolbox pull failed | `docker login registry.redhat.io` |
| Export incomplete | Revisar permisos token Admin |
| GateForge no ve productos | Verificar `THREESCALE_ADMIN_URL` coincide con export |
| OIDC warning | Esperado si seed usa issuer ficticio |

## Referencias

- [SEED.md](https://github.com/Everything-is-Code/3scaleextract/blob/main/docs/SEED.md)
- [export-schema-v1.md](../architecture/export-schema-v1.md)
- Skill: `lab-pipeline-seed-export-migrate`
