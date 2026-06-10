---
name: lab-pipeline-seed-export-migrate
description: Ejecutar pipeline de lab seed → export → visualize → migrate GateForge. Usar para demos, E2E, validación de fixtures seed_api_key, seed_oidc, seed_app_id, seed_multi_backend.
---

# Lab Pipeline: Seed → Export → Visualize → Migrate

## Prerrequisitos

- Tenant 3scale de lab con Admin API token.
- Docker o Podman + imagen toolbox Red Hat.
- Variables: `THREESCALE_ADMIN_URL`, `THREESCALE_ACCESS_TOKEN`.

## Paso 1 — Seed (3scaleextract)

```bash
cd 3scaleextract
go build -o bin/threescale-seed ./cmd/threescale-seed
bin/threescale-seed --skip-existing --list-fixtures
bin/threescale-seed --skip-existing
```

Fixtures: `seed_api_key`, `seed_oidc`, `seed_app_id`, `seed_multi_backend`.

## Paso 2 — Export

```bash
go build -o bin/threescale-export ./cmd/threescale-export
bin/threescale-export --output ./export --include-applications --redact-secrets
```

Script todo-en-uno: `scripts/demo/seed-and-export.sh`

## Paso 3 — Visualize

```bash
go build -o bin/threescale-visualize ./cmd/threescale-visualize
bin/threescale-visualize ./export -o ./report
```

## Paso 4 — GateForge (live hoy / offline futuro)

**Hoy:** GateForge descubre productos vía Admin API configurada en Settings.

**Futuro (INT-2/3):** `POST /api/migration/import-export` con directorio export v1.

**Local GateForge:**

```bash
cd gateforge
cp .env.example .env   # configurar 3scale + cluster
./scripts/local-up.sh  # Podman compose
# UI http://localhost:4200 → Migration Wizard
```

## Criterio E2E (INT-6)

Para cada producto seed, `analyze()` produce plan con AuthPolicy coherente con auth mode del export.

## Referencias

- rhcl-ai/docs/workflows/seed-export-visualize-migrate.md
- rhcl-ai/docs/workflows/local-lab-setup.md
- 3scaleextract/docs/SEED.md
