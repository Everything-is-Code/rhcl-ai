# Local lab setup

Local environment for RHCL development with all three repos.

## Workspace

```bash
mkdir rhcl && cd rhcl
git clone https://github.com/Everything-is-Code/3scaleextract.git
git clone https://github.com/Everything-is-Code/gateforge.git
git clone https://github.com/Everything-is-Code/rhcl-ai.git
./rhcl-ai/scripts/setup-rhcl-workspace.sh   # optional: sync .cursor
```

## 3scaleextract

### Prerequisites

- Go 1.22+
- Docker or Podman
- Toolbox image: `registry.redhat.io/3scale-amp2/toolbox-rhel9:3scale2.16`
- Lab 3scale Admin API token

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

### Prerequisites

- Java 17, Maven 3.9+
- Node 20+, npm
- Podman (local compose)

```bash
cd gateforge
cp .env.example .env
# Edit THREESCALE_*, OPENAI/LiteLLM, kubeconfig as needed
./scripts/local-up.sh
```

- Frontend dev: `cd frontend && npm install && npm start` → http://localhost:4200
- Backend dev: `cd backend && mvn quarkus:dev` → http://localhost:8080

## Cursor

Configure rules and skills before developing:

1. Follow **[docs/ai/cursor-setup.md](../ai/cursor-setup.md)** (full guide).
2. On Windows, if symlink fails: `.\rhcl-ai\scripts\sync-cursor-config.ps1`
3. Optional: copy `rhcl-ai/templates/rhcl.code-workspace.example` → `rhcl/rhcl.code-workspace`

See also [AGENTS.md](../../AGENTS.md).
