---
name: pr-review-rhcl
description: Review PRs for the RHCL program (3scaleextract, gateforge). Use for code review, before merge, or when reviewing 3scale to Connectivity Link migration PRs.
---

# PR Review — RHCL

## Required checklist

- [ ] **Tests**: new or changed logic has tests; CI runs them (no `-DskipTests`).
- [ ] **Secrets**: no tokens, kubeconfigs, or OIDC client secrets in diff or unredacted fixtures.
- [ ] **Scope**: PR resolves a referenced issue (EXT-*, GF-*, INT-*).
- [ ] **Export schema**: if export/import format changes, update rhcl-ai `export-schema-v1.md`.
- [ ] **Language**: PR description, docs, and new comments in English.
- [ ] **Breaking changes**: documented in PR body and docs when applicable.

## By repo

### 3scaleextract
- `go test ./...` passes locally.
- Seed/export does not break `schema_version: "1.0"`.
- Admin API HTTP errors handled explicitly.

### gateforge
- `mvn test` passes in `backend/`.
- `MigrationService` changes include OIDC placeholder warning cases.
- Frontend: specs not stale; `ApiService` mocked in component tests.

## Review response format

1. **Summary** (1–2 sentences)
2. **Blockers** (must fix)
3. **Suggestions** (nice to have)
4. **Verdict**: Approve / Request changes
