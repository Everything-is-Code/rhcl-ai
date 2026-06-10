## Alcance

Smoke tests para entrypoints en `cmd/`:

- `threescale-export --help`
- `threescale-seed --help`, `--list-fixtures`
- `threescale-visualize --help`
- Exit code != 0 cuando faltan credenciales requeridas (export)

## Criterios de aceptación

- [ ] Tests en `cmd/` o test main package sin red
- [ ] `go test ./...` en CI

**Plan PO:** EXT-2 | **Milestone:** M1 - Test foundation
