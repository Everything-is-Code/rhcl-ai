# Mapping 3scale → Connectivity Link (Kuadrant)

Referencia para GateForge `MigrationService` y futuro import offline desde export v1.

## Modelo intermedio GateForge

`ThreeScaleProduct` (`gateforge/backend/.../model/ThreeScaleProduct.java`):

| Campo | Origen export v1 |
|-------|------------------|
| `systemName` | Nombre archivo `products/{sn}.yaml` o `proxy.json` |
| `name` | YAML product metadata o `proxy.json` |
| `serviceId` | `proxy.json` → service id |
| `mappingRules` | `proxy.json` mapping rules |
| `backendUsages` | `backend_usages.json` + resolución `backends/*.json` |
| `authentication` | `proxy.json` auth + `oidc_configuration.json` |
| `applicationPlans` | `application_plans.json` |
| `applications` | `applications/page-*.json` |
| `sourceCluster` | Label manual o `admin_url` del manifest |

## Auth modes

| 3scale auth | Detección | Recurso Kuadrant |
|-------------|-----------|------------------|
| API Key (`api_key`, `user_key`) | `proxy.json` auth_type | AuthPolicy `apiKey` selector `app: {systemName}` + APIKey CR |
| App ID + App Key | `app_id` auth | AuthPolicy apiKey (app credentials) |
| OIDC | `backend_version: oidc` + oidc config | AuthPolicy `jwt` con `issuerUrl` |

### OIDC issuer

- Preferir `oidc_issuer_endpoint` del export/proxy.
- Si falta: GateForge emite **warning** y usa placeholder `https://sso.example.com/realms/api`.
- **Acción pre-apply:** configurar issuer real del IdP (Keycloak/RH-SSO).

## Policies 3scale → Kuadrant

GateForge hoy genera un subconjunto; policies 3scale en export son referencia para migración manual o futuras reglas:

| Policy 3scale (seed) | Estado migración GateForge |
|----------------------|----------------------------|
| `cors` | No generado automáticamente — considerar HTTPRoute filters / Envoy |
| `jwt_claim_check` | Parcial vía AuthPolicy OIDC |
| `ip_check` | RateLimitPolicy / futuro AuthorizationPolicy |
| `edge_limit` | RateLimitPolicy (default 100/60s hoy) |
| `url_rewriting` | HTTPRoute URLRewrite filter (manual) |
| `apicast` | Implícito en gateway — no migrar como policy |

## Backends

| Export | Uso en migración |
|--------|------------------|
| `backends/{sn}.json` → `private_endpoint` | BackendRef HTTPRoute / ServiceEntry |
| `backend_usages.json` → path prefix | Rules HTTPRoute por path |

Multi-backend (`seed_multi_backend`): GateForge **no usa kuadrantctl** para HTTPRoute; genera YAML manual con múltiples rules.

## Gateway strategies

| Strategy | Cuándo usar | Recursos |
|----------|-------------|----------|
| `shared` | Default lab | 1 Gateway, N HTTPRoutes |
| `dual` | Staging + prod 3scale | 2 Gateways |
| `dedicated` | Aislamiento por producto | Gateway por producto |

## Recursos generados por producto

```
HTTPRoute          → routing + backend refs
AuthPolicy         → apiKey o OIDC jwt
RateLimitPolicy    → límite global (placeholder 100/min)
APIProduct         → definición API Kuadrant
APIKey             → credenciales (API Key mode)
```

Labels comunes: `app.kubernetes.io/managed-by: gateforge`, `gateforge.io/product: {systemName}`.

## Productos seed de referencia

| system_name | Auth | Backends | Policies seed |
|-------------|------|----------|---------------|
| `seed_api_key` | API Key | 1 | cors |
| `seed_oidc` | OIDC | 1 | jwt_claim_check, cors |
| `seed_app_id` | App ID | 2 | ip_check, cors |
| `seed_multi_backend` | API Key | 3 | edge_limit, url_rewriting |

## Criterio de aceptación integración (INT-2/3)

Dado export de productos seed con `--redact-secrets`, GateForge `analyze()` sin Admin API produce plan equivalente al flujo live para auth mode y número de recursos por kind.

## Referencias código

- `MigrationService.buildAuthPolicy()` / `buildRateLimitPolicy()`
- `ThreeScaleAuthMode` resolver
- `3scaleextract/internal/seed/fixtures.go`
