# Local lab setup

Entorno local para desarrollo RHCL con los tres repos.

## Workspace

```bash
mkdir rhcl && cd rhcl
git clone https://github.com/Everything-is-Code/3scaleextract.git
git clone https://github.com/Everything-is-Code/gateforge.git
git clone https://github.com/Everything-is-Code/rhcl-ai.git
```

## 3scaleextract

### Prerrequisitos

- Go 1.22+
- Docker o Podman
- Imagen toolbox: `registry.redhat.io/3scale-amp2/toolbox-rhel9:3scale2.16`
- Token Admin API 3scale lab

```bash
docker login registry.redhat.io
export THREESCALE_ADMIN_URL="https://your-tenant-admin.example.com"
export THREESCALE_ACCESS_TOKEN="your-token"
```

### Build

```bash
cd 3scaleextract
go build -o bin/threescale-export ./cmd/threescale-export
go build -o bin/threescale-seed ./cmd/threescale-seed
go build -o bin/threescale-visualize ./cmd/threescale-visualize
go test ./...
```

## GateForge

### Prerrequisitos

- Java 17, Maven 3.9+
- Node 20+, npm
- Podman (compose local)

```bash
cd gateforge
cp .env.example .env
# Editar THREESCALE_*, OPENAI/LiteLLM, kubeconfig si aplica
./scripts/local-up.sh
```

- Frontend dev: `cd frontend && npm install && npm start` → http://localhost:4200
- Backend dev: `cd backend && mvn quarkus:dev` → http://localhost:8080

## Cursor

Configurar rules y skills antes de desarrollar:

1. Seguir **[docs/ai/cursor-setup.md](../ai/cursor-setup.md)** (guía completa).
2. En Windows, si symlink falla: `.\rhcl-ai\scripts\sync-cursor-config.ps1`
3. Opcional: copiar `rhcl-ai/templates/rhcl.code-workspace.example` → `rhcl/rhcl.code-workspace` y abrir ese workspace.

Ver también [AGENTS.md](../../AGENTS.md).
