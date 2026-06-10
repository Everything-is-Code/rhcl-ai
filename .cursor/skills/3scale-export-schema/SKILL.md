---
name: 3scale-export-schema
description: Read, validate, or parse threescale-export schema v1.0 exports. Use for offline import, visualize, shared fixtures, or export contract changes.
---

# Export Schema v1.0

## Quick validation

1. Root contains `manifest.json` with `"schema_version": "1.0"`.
2. Directories: `products/`, `backends/`, `policies/`; optional `applications/`, `accounts/`.

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

## Per product `{system_name}`

| File | Source |
|------|--------|
| `products/{sn}.yaml` | toolbox `3scale product export` |
| `products/{sn}/proxy.json` | Admin API |
| `products/{sn}/policies.json` | Admin API policy chain |
| `products/{sn}/oidc_configuration.json` | Admin API (OIDC products) |
| `products/{sn}/application_plans.json` | Admin API |
| `products/{sn}/backend_usages.json` | Admin API |
| `products/{sn}/metrics.json` | Admin API |

## Backends

- `backends/{system_name}.json` — one per backend API.

## Redaction

With `--redact-secrets`: values `***REDACTED***` for keys like `access_token`, `client_secret`, `api_key`, `user_key`.

## Reference fixture

`3scaleextract/internal/visualize/testdata/export-minimal/` — use for GateForge tests (INT-5).

## Source code

- Schema: `3scaleextract/internal/output/writer.go`
- Loader: `3scaleextract/internal/visualize/loader.go`
- Full doc: rhcl-ai/docs/architecture/export-schema-v1.md
