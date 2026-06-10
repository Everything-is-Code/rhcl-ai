---
name: gateforge-migration
description: Work on GateForge MigrationService, kuadrantctl, gateway strategies shared/dual/dedicated, AuthPolicy, RateLimitPolicy, HTTPRoute. Use when changing 3scale to Kuadrant migration in gateforge.
---

# GateForge Migration

## Entry point

- `MigrationService.analyze(gatewayStrategy, productNames, targetClusterId)` — produces `MigrationPlan`.
- Products from `ThreeScaleService.listProducts()` or (future) offline import.

## Gateway strategies

| Strategy | Behavior |
|----------|----------|
| `shared` | Shared gateway; HTTPRoutes per product |
| `dual` | Separate staging + production |
| `dedicated` | Dedicated gateway per product |

## Generated Kuadrant resources

Per typical product:
- `HTTPRoute` (Gateway API)
- `AuthPolicy` — apiKey or OIDC jwt
- `RateLimitPolicy` — default global limit 100/60s
- `APIProduct` + `APIKey` per auth mode

## kuadrantctl

- Invoked via `KuadrantCtlService` for HTTPRoute when product has a single backend.
- Multi-backend: skip kuadrantctl HTTPRoute; manual YAML fallback.

## Known warnings

- OIDC without `oidc_issuer_endpoint`: AuthPolicy uses placeholder issuer — warning in plan.
- Verify real issuer before `apply`.

## Tests to write (GF-1)

Mock `ThreeScaleService` → call `analyze()` → assert:
- Generated resources by kind
- OIDC warnings when issuer missing
- `dedicated` vs `shared` strategy differences

## References

- `gateforge/backend/.../MigrationService.java`
- `gateforge/backend/.../model/ThreeScaleProduct.java`
- rhcl-ai/docs/architecture/3scale-to-cl-mapping.md
