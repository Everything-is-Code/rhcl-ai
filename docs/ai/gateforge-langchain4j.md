# GateForge — LangChain4j and AI

GateForge uses **LangChain4j** (Quarkus extension) for post-generation analysis and assistant chat.

## Components

| Class | Role |
|-------|------|
| `MigrationAgent` | Registered AI service (`@RegisterAiService`) |
| `GateForgeTools` | `@Tool` methods — cluster/3scale context |
| `ChatResource` | REST `/api/chat` — manual context injection |

## Current mode: context injection (not RAG)

- Chat **does not use RAG** over static documents.
- `ChatResource.buildContextMessage()` prepends live state: 3scale products, clusters, recent plans.
- FAQ cache in Infinispan/Data Grid — 10 prompts, 24h TTL, warm-up at startup.

## Post-generation verification

`MigrationService.runAiVerification()` — agent reviews generated YAML after `analyze()`.

## Configuration

Typical variables (Helm / `.env`):

- `QUARKUS_LANGCHAIN4J_OPENAI_API_KEY`
- `QUARKUS_LANGCHAIN4J_OPENAI_BASE_URL` (LiteLLM-compatible)
- Default model documented in gateforge README (deepseek-r1-distill-qwen-14b in lab)

## Known limitations

- `GateForgeTools` has `@Tool` but **is not in an autonomous agentic loop** in chat.
- MCP server exists separately — see [mcp-tools-gateforge.md](mcp-tools-gateforge.md).

## Developer guidelines

1. Do not send tenant secrets to the LLM — redact in context builder.
2. Prompt changes → update FAQ cache if applicable.
3. AI tests: mock `MigrationAgent` in `MigrationService` unit tests.
