## Contexto

`.github/workflows/build-push-quay.yml` construye imágenes con `-DskipTests`. Los tests nunca corren en CI.

## Alcance

- Agregar job `test` que ejecute `mvn test` en `backend/`
- (Opcional) `npm test` en frontend cuando GF-5 esté listo
- Bloquear merge si tests fallan

## Criterios de aceptación

- [ ] Job test en workflow o workflow separado en PR/push
- [ ] Eliminar `-DskipTests` del path crítico o documentar excepción solo para release manual

**Plan PO:** GF-3 | **Milestone:** M1 - Test foundation
