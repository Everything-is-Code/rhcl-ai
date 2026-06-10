## Alcance

Tests para `ThreeScaleService` y cliente Admin API:

- Parsing de products/backends desde JSON Admin API
- Comportamiento cache Infinispan (mock)
- Multi-source merge vía `ThreeScaleSourceRegistry`

## Criterios de aceptación

- [ ] `mvn test` pasa
- [ ] Sin llamadas red en unit tests

**Plan PO:** GF-2 | **Milestone:** M1 - Test foundation
