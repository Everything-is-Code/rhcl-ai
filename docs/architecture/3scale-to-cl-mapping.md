# Mapping 3scale → Connectivity Link (Kuadrant)

Reference for GateForge `MigrationService` and future offline import from export v1.

## GateForge intermediate model

`ThreeScaleProduct` (`gateforge/backend/.../model/ThreeScaleProduct.java`):

| Field | Export v1 source |
|-------|------------------|
| `systemName` | `products/{sn}.yaml` filename or `proxy.json` |
| `name` | YAML product metadata or `proxy.json` |
| `serviceId` | `proxy.json` → service id |
| `mappingRules` | `proxy.json` mapping rules |
| `backendUsages` | `backend_usages.json` + `backends/*.json` resolution |
| `authentication` | `proxy.json` auth + `oidc_configuration.json` |
| `applicationPlans` | `application_plans.json` |
| `applications` | `applications/page-*.json` |
| `sourceCluster` | Manual label or manifest `admin_url` |

## Auth modes

| 3scale auth | Detection | Kuadrant resource |
|-------------|-----------|-------------------|
| API Key (`api_key`, `user_key`) | `proxy.json` auth_type | AuthPolicy `apiKey` selector `app: {systemName}` + APIKey CR |
| App ID + App Key | `app_id` auth | AuthPolicy apiKey (app credentials) |
| OIDC | `backend_version: oidc` + oidc config | AuthPolicy `jwt` with `issuerUrl` |

### OIDC issuer

- Prefer `oidc_issuer_endpoint` from export/proxy.
- If missing: GateForge emits **warning** and uses placeholder `https://sso.example.com/realms/api`.
- **Pre-apply action:** configure real IdP issuer (Keycloak/RH-SSO).

## 3scale policies → Kuadrant

GateForge generates a subset today; 3scale policies in export are reference for manual migration or future rules:

| 3scale policy (seed) | GateForge migration status |
|----------------------|----------------------------|
| `cors` | Not auto-generated — consider HTTPRoute filters / Envoy |
| `jwt_claim_check` | Partial via OIDC AuthPolicy |
| `ip_check` | RateLimitPolicy / future AuthorizationPolicy |
| `edge_limit` | RateLimitPolicy (default 100/60s today) |
| `url_rewriting` | HTTPRoute URLRewrite filter (manual) |
| `apicast` | Implicit in gateway — do not migrate as policy |

## Backends

| Export | Migration use |
|--------|---------------|
| `backends/{sn}.json` → `private_endpoint` | HTTPRoute BackendRef / ServiceEntry |
| `backend_usages.json` → path prefix | HTTPRoute rules by path |

Multi-backend (`seed_multi_backend`): GateForge **does not use kuadrantctl** for HTTPRoute; manual YAML with multiple rules.

## Gateway strategies

| Strategy | When to use | Resources |
|----------|-------------|-----------|
| `shared` | Default lab | 1 Gateway, N HTTPRoutes |
| `dual` | Staging + prod 3scale | 2 Gateways |
| `dedicated` | Per-product isolation | Gateway per product |

## Resources generated per product

```
HTTPRoute          → routing + backend refs
AuthPolicy         → apiKey or OIDC jwt
RateLimitPolicy    → global limit (placeholder 100/min)
APIProduct         → Kuadrant API definition
APIKey             → credentials (API Key mode)
```

Common labels: `app.kubernetes.io/managed-by: gateforge`, `gateforge.io/product: {systemName}`.

## Reference seed products

| system_name | Auth | Backends | Seed policies |
|-------------|------|----------|---------------|
| `seed_api_key` | API Key | 1 | cors |
| `seed_oidc` | OIDC | 1 | jwt_claim_check, cors |
| `seed_app_id` | App ID | 2 | ip_check, cors |
| `seed_multi_backend` | API Key | 3 | edge_limit, url_rewriting |

## Integration acceptance criteria (INT-2/3)

Given seed product export with `--redact-secrets`, GateForge `analyze()` without Admin API produces a plan equivalent to the live flow for auth mode and resource count by kind.

## Code references

- `MigrationService.buildAuthPolicy()` / `buildRateLimitPolicy()`
- `ThreeScaleAuthMode` resolver
- `3scaleextract/internal/seed/fixtures.go`
