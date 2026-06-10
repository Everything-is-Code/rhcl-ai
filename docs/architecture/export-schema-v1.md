# Export schema v1.0

Contract for the directory produced by `threescale-export` in [3scaleextract](https://github.com/Everything-is-Code/3scaleextract).

**Schema version:** `1.0` (constant `output.SchemaVersion` in `internal/output/writer.go`).

## Directory structure

```
export/
├── manifest.json
├── products/
│   ├── {system_name}.yaml              # Red Hat toolbox
│   └── {system_name}/
│       ├── proxy.json
│       ├── policies.json
│       ├── oidc_configuration.json     # optional (OIDC products)
│       ├── application_plans.json
│       ├── backend_usages.json
│       └── metrics.json
├── backends/
│   └── {system_name}.json
├── policies/
│   └── catalog.json
├── applications/                       # optional (--include-applications)
│   └── page-{n}.json
└── accounts/                           # optional (deduplicated by account_id)
    └── {id}.json
```

## manifest.json

| Field | Type | Description |
|-------|------|-------------|
| `schema_version` | string | Always `"1.0"` |
| `exported_at` | string | RFC3339 UTC |
| `admin_url` | string | Admin Portal URL used for export |
| `product_count` | int | Number of exported services |
| `backend_count` | int | Number of backends |
| `application_count` | int | Only if `include_applications` |
| `include_applications` | bool | Export flag |
| `incomplete` | bool | `true` if partial failure occurred |

### Example

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

## Origin of each artifact

| Artifact | Source |
|----------|--------|
| `products/*.yaml` | Toolbox container: `3scale product export` |
| `products/*/proxy.json` | Admin API GET proxy config |
| `products/*/policies.json` | Admin API policy chain |
| `products/*/oidc_configuration.json` | Admin API OIDC config |
| `products/*/application_plans.json` | Admin API plans |
| `products/*/backend_usages.json` | Admin API backend usages |
| `products/*/metrics.json` | Admin API metrics |
| `backends/*.json` | Admin API backend_apis |
| `policies/catalog.json` | Admin API policy registry |
| `applications/page-*.json` | Admin API paginated |
| `accounts/{id}.json` | Admin API account per application |

## Error behavior

- Optional per-product GET failures are **silently skipped** (export continues).
- Backend catalog or primary service error → `incomplete: true` and error returned.
- `--redact-secrets` post-processes all `.json` and `.yaml` in the tree.

## Redacted keys

`access_token`, `client_secret`, `secret`, `api_key`, `user_key`, `app_key`, `provider_key` → value `***REDACTED***`.

## Validation (GateForge import)

1. Read `manifest.json`; reject if `schema_version != "1.0"`.
2. Verify `products/` is non-empty when `product_count > 0`.
3. For each `{system_name}.yaml`, require at least `proxy.json` in matching subdirectory.
4. Resolve backends via `backends/*.json` + `backend_usages.json`.

## Test fixture

Canonical path: `3scaleextract/internal/visualize/testdata/export-minimal/`

Use as versioned tarball for GateForge tests (issue INT-5).

## Schema evolution

Breaking changes require:
- Increment `schema_version` (e.g. `1.1` or `2.0`)
- Update this document
- Update `internal/visualize/loader.go` validation
- Tests in both repos
