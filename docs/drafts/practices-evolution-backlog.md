# Draft — Practices evolution backlog (PO only)

**Status:** Draft — do not treat as committed program policy until PO promotes items.

**Source inspiration:** [lock_code_manager](https://github.com/raman325/lock_code_manager) (agent-first, mature CI/governance).

**Last updated:** 2026-06-10

---

## Why this document exists

We intentionally deferred several practices during RHCL bootstrap (M1 focus: tests + English docs). This draft captures **what**, **why deferred**, **when to adopt**, and **acceptance criteria** so we can evolve without re-discovering the same ideas.

---

## Tier 1 — Adopt after M1 (CI green)

### 1. Branch protection on default branch

**Done (2026-06-10):** `main` protected on rhcl-ai, 3scaleextract, gateforge — PR required, 1 approval, no force push/deletion. Admins can bypass.

Phase 2 (after GF-3 / EXT-4): add required CI status checks.

---

### 2. Required status checks before merge

| Repo | Required checks (target) |
|------|--------------------------|
| 3scaleextract | `go test ./...` job name from CI |
| gateforge | `mvn test` job (new) + existing build job optional |
| rhcl-ai | markdown/yaml lint (lightweight) |

**From LCM:** explicit check list in auto-merge workflow (`MUST_PASS`, `IF_RUN_PASS`).

**RHCL adaptation:** start with 1 required check per repo; expand later.

---

### 3. File-based PR labeler (`actions/labeler`)

**LCM reference:** `.github/labeler.yml` + `.github/workflows/labeler.yaml`

**Proposed labels:**

| Label | Paths |
|-------|-------|
| `go` | `3scaleextract/**/*.go`, `go.mod` |
| `java` | `gateforge/backend/**/*.java`, `pom.xml` |
| `frontend` | `gateforge/frontend/**` |
| `github-config` | `.github/**` |
| `documentation` | `**/*.md`, `docs/**` |

**Repos:** 3scaleextract, gateforge (not critical for rhcl-ai).

---

### 4. golangci-lint + coverage (3scaleextract)

**Issue:** EXT-4

**LCM equivalent:** Ruff + pytest coverage in reusable workflow.

**Target:**

```yaml
- golangci-lint run
- go test -coverprofile=coverage.out ./...
```

Optional: Codecov upload (public repos).

---

### 5. GateForge CI test job

**Issue:** GF-3

**LCM equivalent:** `Python Checks` reusable workflow with Ruff, mypy, pytest matrix.

**Target:** separate `test` job in CI; `-DskipTests` only if explicitly documented exception.

---

## Tier 2 — Adopt after M2 (integration stable)

### 6. Dependabot

**LCM reference:** `.github/dependabot.yaml`

**Per repo:**

| Repo | Ecosystems |
|------|------------|
| 3scaleextract | gomod, github-actions |
| gateforge | maven, npm, github-actions |
| rhcl-ai | github-actions |

**Policy:** patch/minor auto-merge only after branch protection + CI (copy LCM `repository.yaml` auto-merge logic).

---

### 7. Release Drafter

**LCM reference:** `.github/release-drafter.yml` + `release-drafter/release-drafter@v7`

**Repos:** 3scaleextract (semver tags already), gateforge (Quay tags).

**Categories:** enhancement, fix, documentation, dependencies, breaking-change.

**Not for rhcl-ai** unless we start versioning docs releases.

---

### 8. Auto-merge (dependabot / labeled PRs)

**LCM reference:** `repository.yaml` → `auto-merge` job waits for CI, merges squash.

**RHCL prerequisites:**

- Branch protection enabled
- Required checks named and stable
- Label `auto-merge` for trusted bot/human PRs only

**Scope:** dependabot patch/minor first; never auto-merge integration PRs.

---

### 9. Reusable workflows in rhcl-ai templates

**LCM pattern:** `python-checks.yml` as `workflow_call`.

**RHCL templates to add:**

```
templates/github/.github/workflows/
├── go-checks.yml      # test, lint, coverage
├── java-checks.yml    # mvn test, optional spotless
└── docs-checks.yml    # markdownlint, yamllint
```

Consume from each product repo via `uses: Everything-is-Code/rhcl-ai/...` (or copy until path stable).

---

## Tier 3 — Quality of life (post-M3)

### 10. pre-commit / prek (local dev)

**LCM reference:** `prek run --all-files` in AGENTS.md; `scripts/setup` installs hooks.

**RHCL challenge:** three stacks — no single hook config.

**Options:**

| Scope | Hooks |
|-------|-------|
| rhcl-ai only | markdownlint, yamllint on templates |
| 3scaleextract | golangci-lint, gofmt |
| gateforge | spotless (Java), eslint (frontend) — heavier |

**Recommendation:** optional local hooks; **required checks stay in CI** (LCM uses both).

---

### 11. Integration test CI (scheduled)

**Issue:** EXT-3

**LCM equivalent:** integration test job with secrets (HA test env).

**RHCL:** weekly `workflow_dispatch` + `THREESCALE_*` secrets for `go test -tags=integration`.

---

### 12. Codecov / coverage gates

**LCM reference:** `.github/codecov.yaml`

**RHCL:** optional after baseline coverage exists; do not gate M1 on percentage.

---

### 13. Issue body labeler

**LCM reference:** `github/issue-labeler` + `.github/issue-labeler.yml`

**Use case:** auto-label `area/integration` when issue body mentions "export" + "gateforge".

Low priority — manual PO labels work at current team size.

---

## Promotion checklist (PO)

When moving an item from this draft to active program:

- [ ] GitHub issue created with acceptance criteria
- [ ] Milestone assigned (M1/M2/M3)
- [ ] `docs/ai/agent-governance.md` updated (remove from "not copied yet")
- [ ] Team notified (Red Hat channel)
- [ ] Cursor rule / AGENTS.md updated if agents must know new convention

---

## References

- LCM `AGENTS.md` — operational rules, testing philosophy
- LCM `.github/workflows/repository.yaml` — release-drafter + auto-merge
- LCM `.github/workflows/python-checks.yml` — reusable CI
- RHCL [agent-governance.md](../ai/agent-governance.md) — what we adopted today
