## Contexto

GateForge hoy solo descubre 3scale vía Admin API live. Se necesita importar export offline generado por `threescale-export` (schema v1.0).

## Alcance

Nuevo endpoint:

```
POST /api/migration/import-export
Content-Type: multipart/form-data
```

Acepta:
- Directorio export (zip/tar.gz) con `manifest.json` schema 1.0
- Valida estructura según [rhcl-ai export-schema-v1](https://github.com/Everything-is-Code/rhcl-ai/blob/master/docs/architecture/export-schema-v1.md)

## Dependencias

- INT-1 (docs) — done
- INT-3 parser

## Cross-links

- [Everything-is-Code/3scaleextract](https://github.com/Everything-is-Code/3scaleextract)
- [Everything-is-Code/rhcl-ai#INT-1](https://github.com/Everything-is-Code/rhcl-ai)

**Plan PO:** INT-2 | **Milestone:** M2 - Integration offline
