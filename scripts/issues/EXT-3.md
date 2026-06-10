## Alcance

Agregar job en `.github/workflows/ci.yml` (o workflow separado) para:

```bash
go test -tags=integration ./internal/export/...
```

Requiere secrets:
- `THREESCALE_ADMIN_URL`
- `THREESCALE_ACCESS_TOKEN`
- `THREESCALE_OUTPUT_DIR`

Trigger: `workflow_dispatch` y/o schedule semanal.

## Criterios de aceptación

- [ ] Job documentado en README
- [ ] Falla gracefully si secrets no configurados (solo manual)

**Plan PO:** EXT-3 | **Milestone:** M1 - Test foundation
