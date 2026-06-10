# GateForge — MCP Tools

GateForge expone servidores MCP (Model Context Protocol) vía Quarkus MCP SSE para clientes externos (Cursor, otros agentes).

## Clases

| Clase | Dominio |
|-------|---------|
| `ThreeScaleMcpTools` | Admin API 3scale — products, backends |
| `KubernetesMcpTools` | Recursos cluster, namespaces |
| `ConnectivityLinkMcpTools` | Kuadrant policies, topology |

## Uso vs Chat interno

- MCP tools están disponibles para **clientes MCP externos**.
- El chat UI de GateForge usa **context injection manual** en `ChatResource`, no invoca MCP tools en loop.
- Roadmap: conectar chat con tool calling real (fuera de M1-M3).

## Desarrollo

- Dependencia: `quarkus-mcp-server-sse`
- Endpoints SSE documentados en gateforge README / docs site
- Al agregar tool: documentar parámetros aquí y en skill `gateforge-migration`

## Seguridad

- MCP expone operaciones cluster — restringir en producción vía network policy / auth.
- No retornar tokens Admin API en respuestas de tools.
