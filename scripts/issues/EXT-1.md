## Contexto

El paquete `internal/seed/seeder.go` implementa la carga de fixtures en un tenant 3scale vía Admin API, pero solo tiene tests dry-run. El gap principal de cobertura del repo.

## Alcance

- Mock de `admin.Client` (HTTP) para probar flujos reales del seeder sin tenant live.
- Casos mínimos:
  - Auth API Key (`seed_api_key`)
  - Auth OIDC (`seed_oidc`) — recreación de apps
  - `--skip-existing` cuando el producto ya existe
  - Errores HTTP (4xx/5xx) propagados correctamente

## Archivos

- `internal/seed/seeder.go`
- `internal/seed/seeder_test.go` (nuevo o ampliar)

## Criterios de aceptación

- [ ] `go test ./internal/seed/...` cubre auth modes y skip-existing
- [ ] Sin llamadas de red en tests unitarios
- [ ] CI existente (`go test ./...`) pasa

## Referencias

- [docs/SEED.md](https://github.com/Everything-is-Code/3scaleextract/blob/main/docs/SEED.md)
- [rhcl-ai skill 3scale-export-schema](https://github.com/Everything-is-Code/rhcl-ai)

**Plan PO:** EXT-1 | **Milestone:** M1 - Test foundation
