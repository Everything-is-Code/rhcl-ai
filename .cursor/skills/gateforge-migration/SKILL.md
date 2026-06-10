---
name: gateforge-migration
description: Trabajar en GateForge MigrationService, kuadrantctl, estrategias gateway shared/dual/dedicated, AuthPolicy, RateLimitPolicy, HTTPRoute. Usar al modificar migración 3scale a Kuadrant en gateforge.
---

# GateForge Migration

## Punto de entrada

- `MigrationService.analyze(gatewayStrategy, productNames, targetClusterId)` — genera `MigrationPlan`.
- Productos desde `ThreeScaleService.listProducts()` o (futuro) import offline.

## Estrategias gateway

| Strategy | Comportamiento |
|----------|----------------|
| `shared` | Un gateway compartido; HTTPRoutes por producto |
| `dual` | Staging + production separados |
| `dedicated` | Gateway dedicado por producto |

## Recursos Kuadrant generados

Por producto típico:
- `HTTPRoute` (Gateway API)
- `AuthPolicy` — apiKey o OIDC jwt
- `RateLimitPolicy` — límite global default 100/60s
- `APIProduct` + `APIKey` según auth mode

## kuadrantctl

- Invocado vía `KuadrantCtlService` para HTTPRoute cuando producto tiene un solo backend.
- Multi-backend: skip kuadrantctl HTTPRoute; fallback YAML manual.

## Warnings conocidos

- OIDC sin `oidc_issuer_endpoint`: AuthPolicy usa issuer placeholder — warning en plan.
- Verificar issuer real antes de `apply`.

## Tests a escribir (GF-1)

Mock `ThreeScaleService` → llamar `analyze()` → assert:
- Recursos generados por kind
- Warnings OIDC cuando falta issuer
- Estrategia `dedicated` vs `shared`

## Referencias

- `gateforge/backend/.../MigrationService.java`
- `gateforge/backend/.../model/ThreeScaleProduct.java`
- rhcl-ai/docs/architecture/3scale-to-cl-mapping.md
