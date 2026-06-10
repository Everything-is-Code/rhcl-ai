# GateForge — MCP Tools

GateForge exposes MCP (Model Context Protocol) servers via Quarkus MCP SSE for external clients (Cursor, other agents).

## Classes

| Class | Domain |
|-------|--------|
| `ThreeScaleMcpTools` | 3scale Admin API — products, backends |
| `KubernetesMcpTools` | Cluster resources, namespaces |
| `ConnectivityLinkMcpTools` | Kuadrant policies, topology |

## Usage vs internal chat

- MCP tools are available to **external MCP clients**.
- GateForge chat UI uses **manual context injection** in `ChatResource`, not MCP tool loops.
- Roadmap: connect chat to real tool calling (post M1–M3).

## Development

- Dependency: `quarkus-mcp-server-sse`
- SSE endpoints documented in gateforge README / docs site
- When adding a tool: document parameters here and in skill `gateforge-migration`

## Security

- MCP exposes cluster operations — restrict in production via network policy / auth.
- Do not return Admin API tokens in tool responses.
