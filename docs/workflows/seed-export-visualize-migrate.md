# Workflow: Seed → Export → Visualize → Migrate

End-to-end validation pipeline for the RHCL program.

## Goal

Verify lab fixtures in 3scale export correctly and GateForge can analyze them (live today; offline with INT-2/3).

## Quick script (3scaleextract)

```bash
cd 3scaleextract
source scripts/load-env.sh   # or export THREESCALE_* manually
./scripts/demo/seed-and-export.sh
```

Produces `./export/manifest.json` and full tree.

## Visualize

```bash
bin/threescale-visualize ./export -o ./report
open report/index.md
```

Review:
- Auth matrix per product
- Mermaid topology diagram
- Backend ↔ product references

## GateForge — live flow (current)

1. Configure the same 3scale URL/token in GateForge Settings.
2. Migration Wizard → select `seed_*` products.
3. Strategy `shared` → Analyze → review plan and OIDC warnings.
4. (Optional) Apply on lab cluster with Connectivity Link installed.

## GateForge — offline flow (planned INT-2/3)

```http
POST /api/migration/import-export
Content-Type: multipart/form-data

file: export.tar.gz   # manifest v1.0 + tree
```

Wizard continues with parsed products without Admin API.

## E2E checklist (INT-6)

- [ ] Seed 4 products without error
- [ ] Export `incomplete: false`
- [ ] Visualize report generated
- [ ] GateForge analyze produces AuthPolicy per auth mode
- [ ] OIDC warning when issuer is placeholder
- [ ] `seed_multi_backend` generates multi-rule HTTPRoute (no kuadrantctl)

## Troubleshooting

| Problem | Action |
|---------|--------|
| Toolbox pull failed | `docker login registry.redhat.io` |
| Export incomplete | Check Admin token permissions |
| GateForge missing products | Verify `THREESCALE_ADMIN_URL` matches export |
| OIDC warning | Expected when seed uses fictional issuer |

## References

- [SEED.md](https://github.com/Everything-is-Code/3scaleextract/blob/main/docs/SEED.md)
- [export-schema-v1.md](../architecture/export-schema-v1.md)
- Skill: `lab-pipeline-seed-export-migrate`
