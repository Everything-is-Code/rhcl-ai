# GateForge — LangChain4j y AI

GateForge usa **LangChain4j** (Quarkus extension) para análisis post-generación y chat asistente.

## Componentes

| Clase | Rol |
|-------|-----|
| `MigrationAgent` | Servicio AI registrado (`@RegisterAiService`) |
| `GateForgeTools` | Tools con `@Tool` — contexto cluster/3scale |
| `ChatResource` | REST `/api/chat` — inyecta contexto manualmente |

## Modo actual: context injection (no RAG)

- El chat **no usa RAG** sobre documentos estáticos.
- `ChatResource.buildContextMessage()` prepone estado live: productos 3scale, clusters, planes recientes.
- FAQ cache en Infinispan/Data Grid — 10 prompts, TTL 24h, warm-up al startup.

## Verificación post-generación

`MigrationService.runAiVerification()` — el agente revisa YAML generado tras `analyze()`.

## Configuración

Variables típicas (Helm / `.env`):

- `QUARKUS_LANGCHAIN4J_OPENAI_API_KEY`
- `QUARKUS_LANGCHAIN4J_OPENAI_BASE_URL` (compatible LiteLLM)
- Modelo default documentado en gateforge README (deepseek-r1-distill-qwen-14b en lab)

## Limitaciones conocidas

- `GateForgeTools` tiene `@Tool` pero **no está en loop agentic autónomo** del chat.
- MCP server existe por separado — ver [mcp-tools-gateforge.md](mcp-tools-gateforge.md).

## Lineamientos para devs

1. No enviar secretos de tenant al LLM — redactar en context builder.
2. Cambios en prompts → actualizar FAQ cache si aplica.
3. Tests de AI: mockear `MigrationAgent` en unit tests de `MigrationService`.
