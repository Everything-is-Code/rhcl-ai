---
name: pr-review-rhcl
description: Revisar PRs del programa RHCL (3scaleextract, gateforge). Usar en code review, antes de merge, o cuando el usuario pide revisar un PR del equipo de migración 3scale a Connectivity Link.
---

# PR Review — RHCL

## Checklist obligatorio

- [ ] **Tests**: lógica nueva o cambiada tiene tests; CI los ejecuta (no `-DskipTests`).
- [ ] **Secretos**: no hay tokens, kubeconfigs, client secrets en diff ni fixtures sin redactar.
- [ ] **Scope**: el PR resuelve un issue referenciado (EXT-*, GF-*, INT-*).
- [ ] **Export schema**: si toca formato export/import, actualiza rhcl-ai `export-schema-v1.md`.
- [ ] **Breaking changes**: documentados en PR body y en docs si aplica.

## Por repo

### 3scaleextract
- `go test ./...` pasa localmente.
- Seed/export no rompe `schema_version: "1.0"`.
- Errores HTTP del Admin API manejados explícitamente.

### gateforge
- `mvn test` pasa en `backend/`.
- Cambios en `MigrationService` incluyen casos OIDC placeholder warning.
- Frontend: specs no obsoletos; `ApiService` mockeado en tests de componentes.

## Respuesta de review

Estructura sugerida:

1. **Resumen** (1-2 oraciones)
2. **Bloqueantes** (must fix)
3. **Sugerencias** (nice to have)
4. **Veredicto**: Approve / Request changes
