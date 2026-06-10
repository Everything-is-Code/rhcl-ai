---
name: lab-pipeline-seed-export-migrate
description: Run lab pipeline seed, export, visualize, and GateForge migrate. Use for demos, E2E, and validating seed_api_key, seed_oidc, seed_app_id, seed_multi_backend fixtures.
---

# Lab Pipeline: Seed → Export → Visualize → Migrate

## Prerequisites

- Lab 3scale tenant with Admin API token.
- Docker or Podman + Red Hat toolbox image.
- Variables: `THREESCALE_ADMIN_URL`, `THREESCALE_ACCESS_TOKEN`.

## Step 1 — Seed (3scaleextract)

```bash
cd 3scaleextract
go build -o bin/threescale-seed ./cmd/threescale-seed
bin/threescale-seed --skip-existing --list-fixtures
bin/threescale-seed --skip-existing
```

Fixtures: `seed_api_key`, `seed_oidc`, `seed_app_id`, `seed_multi_backend`.

## Step 2 — Export

```bash
go build -o bin/threescale-export ./cmd/threescale-export
bin/threescale-export --output ./export --include-applications --redact-secrets
```

All-in-one script: `scripts/demo/seed-and-export.sh`

## Step 3 — Visualize

```bash
go build -o bin/threescale-visualize ./cmd/threescale-visualize
bin/threescale-visualize ./export -o ./report
```

## Step 4 — GateForge (live today / offline future)

**Today:** GateForge discovers products via Admin API configured in Settings.

**Future (INT-2/3):** `POST /api/migration/import-export` with export v1 directory.

**Local GateForge:**

```bash
cd gateforge
cp .env.example .env   # configure 3scale + cluster
./scripts/local-up.sh  # Podman compose
# UI http://localhost:4200 → Migration Wizard
```

## E2E criteria (INT-6)

For each seed product, `analyze()` produces a plan with AuthPolicy matching export auth mode.

## References

- rhcl-ai/docs/workflows/seed-export-visualize-migrate.md
- rhcl-ai/docs/workflows/local-lab-setup.md
- 3scaleextract/docs/SEED.md
