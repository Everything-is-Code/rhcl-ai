## Alcance

Script/documentación E2E completa:

1. `threescale-seed --skip-existing`
2. `threescale-export --include-applications --redact-secrets`
3. `threescale-visualize`
4. GateForge analyze (live hoy; offline post INT-2/3)

Documentar en [rhcl-ai seed-export-visualize-migrate.md](https://github.com/Everything-is-Code/rhcl-ai/blob/main/docs/workflows/seed-export-visualize-migrate.md) y script opcional en `rhcl-ai/scripts/` o `3scaleextract/scripts/demo/`.

## Checklist E2E

- [ ] 4 productos seed
- [ ] export `incomplete: false`
- [ ] analyze AuthPolicy por auth mode
- [ ] warning OIDC placeholder

## Cross-links

- [Everything-is-Code/3scaleextract](https://github.com/Everything-is-Code/3scaleextract)
- [Everything-is-Code/gateforge](https://github.com/Everything-is-Code/gateforge)

**Plan PO:** INT-6 | **Milestone:** M3 - E2E lab
