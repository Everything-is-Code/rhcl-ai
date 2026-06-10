## Alcance

Implementar parser export v1 → `List<ThreeScaleProduct>` sin Admin API.

Mapping según [3scale-to-cl-mapping.md](https://github.com/Everything-is-Code/rhcl-ai/blob/main/docs/architecture/3scale-to-cl-mapping.md):

| Export | ThreeScaleProduct field |
|--------|-------------------------|
| `products/{sn}.yaml` + `proxy.json` | systemName, mappingRules |
| `backend_usages.json` | backendUsages |
| `oidc_configuration.json` | authentication |
| `application_plans.json` | applicationPlans |
| `applications/page-*.json` | applications |

Integrar con `MigrationService.analyze()` vía nuevo provider o flag.

## Criterio de aceptación

Export seed fixtures (`seed_*`) → analyze() produce plan coherente con flujo live.

## Dependencias

- Blocked by INT-2 (API upload) o puede desarrollarse en paralelo con tests locales

## Cross-links

- [Everything-is-Code/3scaleextract](https://github.com/Everything-is-Code/3scaleextract)
- INT-5 fixture tarball

**Plan PO:** INT-3 | **Milestone:** M2 - Integration offline
