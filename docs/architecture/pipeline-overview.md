# Pipeline overview — RHCL

**Red Hat 3scale API Management** to **Red Hat Connectivity Link** (Kuadrant on OpenShift) migration program.

## Diagram

```mermaid
flowchart TB
    subgraph lab [Lab / Source tenant]
        T3[3scale Admin Portal]
    end

    subgraph extract [3scaleextract]
        Seed[threescale-seed]
        Export[threescale-export]
        Viz[threescale-visualize]
    end

    subgraph artifact [Offline artifact]
        Manifest[manifest.json v1.0]
        Files[products/ backends/ applications/]
    end

    subgraph forge [gateforge]
        Live[ThreeScaleService live API]
        Import[Import export offline - planned]
        Analyze[MigrationService.analyze]
        Apply[Apply Kuadrant resources]
    end

    subgraph target [Target cluster]
        CL[Connectivity Link / Kuadrant]
    end

    T3 --> Seed
    Seed --> T3
    T3 --> Export
    Export --> Manifest
    Export --> Files
    Files --> Viz
    T3 --> Live
    Manifest --> Import
    Files --> Import
    Live --> Analyze
    Import --> Analyze
    Analyze --> Apply
    Apply --> CL
```

## GateForge product phases

| Phase | Capability |
|-------|------------|
| 1 | Multi-source 3scale Admin API |
| 2 | Multi-cluster target (ArgoCD discovery) |
| 3 | Hub-spoke persistence (PostgreSQL) |
| 4 | AI analysis (LangChain4j) |
| 5 | Developer Hub plugins |
| 6 | APICast discovery → Istio/CL mapping |

## Role of each repo

| Repo | Input | Output |
|------|-------|--------|
| 3scaleextract | Admin API credentials | `export/` directory + Markdown report |
| gateforge | 3scale products (live or export) | Kuadrant YAML applied to cluster |
| rhcl-ai | — | Docs, skills, templates, contracts |

## PO milestones

1. **M1** — Tests + CI in both code repos
2. **M2** — Offline export v1 import in GateForge
3. **M3** — Automated E2E lab (seed → export → analyze)
