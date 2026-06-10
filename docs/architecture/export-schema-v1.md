# Export schema v1.0

Contrato del directorio generado por `threescale-export` en [3scaleextract](https://github.com/Everything-is-Code/3scaleextract).

**Schema version:** `1.0` (constante `output.SchemaVersion` en `internal/output/writer.go`).

## Estructura de directorios

```
export/
├── manifest.json
├── products/
│   ├── {system_name}.yaml              # toolbox Red Hat
│   └── {system_name}/
│       ├── proxy.json
│       ├── policies.json
│       ├── oidc_configuration.json     # opcional (OIDC products)
│       ├── application_plans.json
│       ├── backend_usages.json
│       └── metrics.json
├── backends/
│   └── {system_name}.json
├── policies/
│   └── catalog.json
├── applications/                       # opcional (--include-applications)
│   └── page-{n}.json
└── accounts/                           # opcional (deduplicado por account_id)
    └── {id}.json
```

## manifest.json

| Campo | Tipo | Descripción |
|-------|------|-------------|
| `schema_version` | string | Siempre `"1.0"` |
| `exported_at` | string | RFC3339 UTC |
| `admin_url` | string | URL Admin Portal usada en export |
| `product_count` | int | Número de services exportados |
| `backend_count` | int | Número de backends |
| `application_count` | int | Solo si `include_applications` |
| `include_applications` | bool | Flag del export |
| `incomplete` | bool | `true` si hubo error parcial |

### Ejemplo

```json
{
  "schema_version": "1.0",
  "exported_at": "2026-06-10T12:00:00Z",
  "admin_url": "https://tenant-admin.example.com",
  "product_count": 4,
  "backend_count": 3,
  "application_count": 11,
  "include_applications": true,
  "incomplete": false
}
```

## Origen de cada artefacto

| Artefacto | Fuente |
|-----------|--------|
| `products/*.yaml` | Contenedor toolbox: `3scale product export` |
| `products/*/proxy.json` | Admin API GET proxy config |
| `products/*/policies.json` | Admin API policy chain |
| `products/*/oidc_configuration.json` | Admin API OIDC config |
| `products/*/application_plans.json` | Admin API plans |
| `products/*/backend_usages.json` | Admin API backend usages |
| `products/*/metrics.json` | Admin API metrics |
| `backends/*.json` | Admin API backend_apis |
| `policies/catalog.json` | Admin API policy registry |
| `applications/page-*.json` | Admin API paginado |
| `accounts/{id}.json` | Admin API account por application |

## Comportamiento en errores

- Endpoints opcionales por producto que fallan en GET se **omiten silenciosamente** (export continúa).
- Error en backend catalog o service principal → `incomplete: true` y error retornado.
- `--redact-secrets` post-procesa todos `.json` y `.yaml` en el árbol.

## Claves redactadas

`access_token`, `client_secret`, `secret`, `api_key`, `user_key`, `app_key`, `provider_key` → valor `***REDACTED***`.

## Validación (GateForge import)

1. Leer `manifest.json`; rechazar si `schema_version != "1.0"`.
2. Verificar `products/` no vacío si `product_count > 0`.
3. Por cada `{system_name}.yaml`, exigir al menos `proxy.json` en subdirectorio homónimo.
4. Resolver backends vía `backends/*.json` + `backend_usages.json`.

## Fixture de test

Path canónico: `3scaleextract/internal/visualize/testdata/export-minimal/`

Usar como tarball versionado para tests GateForge (issue INT-5).

## Evolución del schema

Cambios breaking requieren:
- Incrementar `schema_version` (ej. `1.1` o `2.0`)
- Actualizar este documento
- Actualizar `internal/visualize/loader.go` validación
- Tests en ambos repos
