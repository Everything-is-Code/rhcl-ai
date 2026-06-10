## Contexto

GateForge no tiene `src/test/` a pesar de declarar JUnit en `pom.xml`. `MigrationService.analyze()` es el corazón de la migración (~1500 líneas).

## Alcance

Unit tests con Mockito para `MigrationService.analyze()`:

- Mock `ThreeScaleService` retornando productos sample
- Validar recursos generados por kind (HTTPRoute, AuthPolicy, RateLimitPolicy)
- Warning OIDC cuando falta `oidc_issuer_endpoint`
- Estrategias `shared`, `dual`, `dedicated`

## Archivos

- `backend/src/test/java/io/gateforge/service/MigrationServiceTest.java`

## Criterios de aceptación

- [ ] `mvn test` pasa en `backend/`
- [ ] Al menos 3 casos de analyze cubiertos

## Referencias

- [rhcl-ai gateforge-migration skill](https://github.com/Everything-is-Code/rhcl-ai)
- `MigrationService.java`

**Plan PO:** GF-1 | **Milestone:** M1 - Test foundation
