# Configurar Cursor — rules y skills RHCL

Guía para desarrolladores del programa **3scale → Connectivity Link**. Las rules y skills oficiales viven en este repo ([`rhcl-ai`](https://github.com/Everything-is-Code/rhcl-ai)).

## Qué incluye rhcl-ai

```
rhcl-ai/
├── AGENTS.md                 # Instrucciones globales para agentes
└── .cursor/
    ├── rules/                # Reglas persistentes (.mdc)
    │   ├── rhcl-global.mdc   # Siempre activa (programa completo)
    │   ├── gateforge-java.mdc
    │   └── 3scaleextract-go.mdc
    └── skills/               # Skills invocables por el agente
        ├── pr-review-rhcl/
        ├── gateforge-migration/
        ├── 3scale-export-schema/
        └── lab-pipeline-seed-export-migrate/
```

| Rule | Cuándo aplica |
|------|----------------|
| `rhcl-global.mdc` | **Siempre** (`alwaysApply: true`) |
| `gateforge-java.mdc` | Archivos bajo `gateforge/**` |
| `3scaleextract-go.mdc` | Archivos bajo `3scaleextract/**` |

---

## Prerrequisito: layout del workspace

Cursor lee `.cursor/rules/` desde la **raíz del workspace** que tengas abierta. Por eso el layout recomendado es un directorio padre con los tres repos:

```
rhcl/                          ← abrir ESTA carpeta en Cursor
├── 3scaleextract/
├── gateforge/
├── rhcl-ai/
└── .cursor/                   ← rules/skills enlazados o copiados (ver abajo)
    ├── rules/
    └── skills/
```

Clonar repos:

```bash
mkdir rhcl && cd rhcl
git clone https://github.com/Everything-is-Code/3scaleextract.git
git clone https://github.com/Everything-is-Code/gateforge.git
git clone https://github.com/Everything-is-Code/rhcl-ai.git
```

---

## Opción A — Recomendada: workspace multi-repo + enlace a rhcl-ai

Enlazar `.cursor` del workspace padre al de `rhcl-ai`. Así siempre tenés la versión actualizada del repo de AI.

### Linux / macOS

```bash
cd rhcl
ln -s rhcl-ai/.cursor .cursor
```

### Windows (PowerShell, terminal como administrador si falla el symlink)

```powershell
cd rhcl
New-Item -ItemType SymbolicLink -Path .cursor -Target rhcl-ai\.cursor
```

Si no podés crear symlinks, usá la **Opción B** (copia).

### Archivo de workspace (opcional)

Copiá [`templates/rhcl.code-workspace.example`](../templates/rhcl.code-workspace.example) a `rhcl/rhcl.code-workspace` y abrí ese archivo con **File → Open Workspace from File**. Incluye las tres carpetas y una nota sobre `.cursor`.

---

## Opción B — Copiar rules/skills al workspace padre

Útil en Windows sin permisos de symlink o CI efímero.

```bash
cd rhcl
cp -r rhcl-ai/.cursor .cursor
```

**Importante:** después de cada `git pull` en `rhcl-ai`, volvé a copiar o usá un script:

```bash
./rhcl-ai/scripts/sync-cursor-config.sh
```

En Windows:

```powershell
.\rhcl-ai\scripts\sync-cursor-config.ps1
```

---

## Opción C — Un solo repo abierto (gateforge o 3scaleextract)

Si abrís solo `gateforge/` o `3scaleextract/` como workspace:

1. Copiá rules relevantes a ese repo:

```bash
# Desde gateforge/
mkdir -p .cursor/rules .cursor/skills
cp ../rhcl-ai/.cursor/rules/rhcl-global.mdc .cursor/rules/
cp ../rhcl-ai/.cursor/rules/gateforge-java.mdc .cursor/rules/
cp -r ../rhcl-ai/.cursor/skills/* .cursor/skills/
```

2. Ajustá el glob en `gateforge-java.mdc` de `gateforge/**/*` a `**/*` si hace falta (el workspace ya es la raíz de gateforge).

3. Copiá también `AGENTS.md` a la raíz del repo o referenciá el de rhcl-ai en el chat.

---

## Verificar que Cursor carga las rules

1. Abrí la carpeta **`rhcl/`** (no solo un subrepo), con `.cursor` enlazado o copiado.
2. En Cursor: **Settings → Cursor Settings → Rules** (o el panel **Rules** en el sidebar del Agent).
3. Deberías ver:
   - `rhcl-global` — Always
   - `gateforge-java` — cuando trabajes en archivos bajo `gateforge/`
   - `3scaleextract-go` — cuando trabajes en archivos bajo `3scaleextract/`
4. Abrí un archivo como `gateforge/backend/.../MigrationService.java` y comprobá que la rule `gateforge-java` aparece como activa.

### Prueba rápida en el chat

Escribí en Agent:

> ¿Qué rules RHCL tenés activas y cuál es el schema_version del export offline?

El agente debería mencionar `1.0` y las convenciones de `rhcl-global`.

---

## Skills

Los skills están en `.cursor/skills/<nombre>/SKILL.md`. Cursor los descubre por el frontmatter `description` — no hace falta registrarlos manualmente si `.cursor/skills/` está en la raíz del workspace.

| Skill | Invocación típica |
|-------|-------------------|
| `pr-review-rhcl` | "Revisá este PR según estándares RHCL" |
| `gateforge-migration` | "Implementá tests para MigrationService.analyze" |
| `3scale-export-schema` | "Parseá este manifest.json export v1" |
| `lab-pipeline-seed-export-migrate` | "Corré el pipeline seed → export → visualize" |

También podés mencionarlos con `@` si tu versión de Cursor soporta referencias a skills en el chat.

---

## AGENTS.md

[AGENTS.md](../../AGENTS.md) complementa las rules con contexto de programa (prioridades PO, flujo de issues, repos). Cursor lo usa como instrucción de proyecto cuando está en la raíz del workspace.

Si tu workspace es `rhcl/` y no tenés `AGENTS.md` en la raíz:

```bash
cd rhcl
ln -s rhcl-ai/AGENTS.md AGENTS.md   # o copiar
```

---

## Actualizar rules/skills (equipo PO)

1. Cambios solo en **rhcl-ai** → PR a `Everything-is-Code/rhcl-ai`.
2. Tras merge, cada dev ejecuta `git pull` en `rhcl-ai` y:
   - symlink: automático
   - copia: `./rhcl-ai/scripts/sync-cursor-config.sh`
3. Comunicar en el canal del equipo si hay rules nuevas o cambios de contrato export.

---

## Troubleshooting

| Problema | Solución |
|----------|----------|
| No veo rules en Settings | Workspace abierto es un subrepo; subí un nivel a `rhcl/` |
| Rules no aplican a archivos Go/Java | Globs asumen raíz `rhcl/`; verificá paths `gateforge/**`, `3scaleextract/**` |
| Symlink falla en Windows | Usá Opción B (copia) o PowerShell como admin |
| Skills no se invocan | Confirmá `.cursor/skills/` en raíz del workspace, no solo dentro de `rhcl-ai/` sin enlace |
| Agente ignora export schema | Abrí un archivo del export o mencioná `@3scale-export-schema` / skill por nombre |

---

## Referencias

- [AGENTS.md](../../AGENTS.md)
- [local-lab-setup.md](../workflows/local-lab-setup.md)
- [Cursor docs — Rules](https://docs.cursor.com/context/rules)
