---
name: 3scale-export-schema
description: Leer, validar o parsear exports de threescale-export schema v1.0. Usar al implementar import offline, visualize, fixtures compartidos, o cambios al contrato manifest.json.
---

# Export Schema v1.0

## Validación rápida

1. Raíz contiene `manifest.json` con `"schema_version": "1.0"`.
2. Directorios: `products/`, `backends/`, `policies/`; opcional `applications/`, `accounts/`.

## manifest.json

```json
{
  "schema_version": "1.0",
  "exported_at": "RFC3339",
  "admin_url": "https://tenant-admin.example.com",
  "product_count": 4,
  "backend_count": 3,
  "application_count": 11,
  "include_applications": true,
  "incomplete": false
}
```

## Por producto `{system_name}`

| Archivo | Origen |
|---------|--------|
| `products/{sn}.yaml` | toolbox `3scale product export` |
| `products/{sn}/proxy.json` | Admin API |
| `products/{sn}/policies.json` | Admin API policy chain |
| `products/{sn}/oidc_configuration.json` | Admin API (OIDC products) |
| `products/{sn}/application_plans.json` | Admin API |
| `products/{sn}/backend_usages.json` | Admin API |
| `products/{sn}/metrics.json` | Admin API |

## Backends

- `backends/{system_name}.json` — uno por backend API.

## Redacción

Con `--redact-secrets`: valores `***REDACTED***` en keys como `access_token`, `client_secret`, `api_key`, `user_key`.

## Fixture de referencia

`3scaleextract/internal/visualize/testdata/export-minimal/` — usar para tests GateForge (INT-5).

## Código fuente

- Schema: `3scaleextract/internal/output/writer.go`
- Loader: `3scaleextract/internal/visualize/loader.go`
- Doc completa: rhcl-ai/docs/architecture/export-schema-v1.md
