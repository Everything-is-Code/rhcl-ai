## Alcance

Extender CI con:

- `golangci-lint run`
- `go test -coverprofile=coverage.out ./...`
- (Opcional) subir artefacto de cobertura

Archivo: `.github/workflows/ci.yml`

## Criterios de aceptación

- [ ] Lint y coverage en PR/push a main
- [ ] Sin regresiones en tests existentes

**Plan PO:** EXT-4 | **Milestone:** M1 - Test foundation
