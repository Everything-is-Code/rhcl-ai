# Draft — Branch protection (PO only)

**Status:** Draft — recommended action for PO/org admins.

**Current state (2026-06-10):** None of the RHCL repos have branch protection enabled.

| Repo | Default branch | Direct push to default? |
|------|----------------|------------------------|
| [rhcl-ai](https://github.com/Everything-is-Code/rhcl-ai) | `master` | Yes (today) |
| [3scaleextract](https://github.com/Everything-is-Code/3scaleextract) | `main` | Yes (today) |
| [gateforge](https://github.com/Everything-is-Code/gateforge) | `main` | Yes (today) |

---

## Should we protect `main` / `master`?

**Yes.** Once the team has more than one contributor (or agents merging PRs), unprotected default branches are a risk:

- Accidental push to default branch bypasses review
- Force-push can rewrite history
- CI can be skipped entirely
- PO process (EXT/GF/INT issues, English policy) is not enforceable

**When to enable:**

| Phase | Action |
|-------|--------|
| **Now (PO only)** | PO can still push directly if needed; enable protection with admin bypass |
| **Before onboarding coders** | **Required** — all changes via PR |
| **After GF-3 / EXT-4** | Add required status checks (tests must pass) |

Do **not** require CI checks until those jobs exist — otherwise merges block with no way to satisfy rules.

---

## Recommended settings (GitHub UI)

**Settings → Branches → Add branch protection rule**

Branch name pattern: `main` (and separate rule for `master` on rhcl-ai, or rename rhcl-ai to `main` first).

### Minimum (enable before coders join)

| Setting | Value |
|---------|-------|
| Require a pull request before merging | Yes |
| Required approvals | **1** (PO or peer) |
| Dismiss stale pull request approvals when new commits are pushed | Yes |
| Require conversation resolution before merging | Optional (recommended) |
| Allow force pushes | **No** |
| Allow deletions | **No** |
| Do not allow bypassing the above settings | **No** (admins can bypass for hotfixes) |

### After CI is ready (M1 complete)

Add:

| Setting | Value |
|---------|-------|
| Require status checks to pass before merging | Yes |
| Require branches to be up to date before merging | Yes (strict) |

**Required checks (examples — use exact job names from Actions tab):**

| Repo | Checks to require |
|------|-------------------|
| 3scaleextract | CI job that runs `go test ./...` |
| gateforge | New `test` job (`mvn test`) |
| rhcl-ai | Optional: lint job on markdown/yaml |

### Optional (Tier 2)

- Require signed commits (only if team uses GPG/SSH signing)
- Require linear history (squash merge makes this less critical)
- Restrict who can push to matching branches (leave empty = anyone with write can open PR; only merge via PR)

---

## Merge strategy

Align with [AGENTS.md](../../AGENTS.md) git conventions:

| Strategy | RHCL recommendation |
|----------|---------------------|
| **Squash merge** | Default for feature PRs (clean history) |
| Merge commit | Avoid for small team |
| Rebase merge | OK for PO who prefer linear history |

Enable squash merge in **Settings → General → Pull Requests**.

---

## Org-level vs repo-level

If **Everything-is-Code** org has rulesets:

- Prefer [Organization rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) for consistent policy across all three repos.
- Repo-level rules OK if org admin access is limited.

---

## CLI setup (org admin)

Replace `CHECK_NAME` with the exact GitHub Actions job name once CI exists.

### 3scaleextract (`main`) — PR only, no required checks yet

```bash
gh api repos/Everything-is-Code/3scaleextract/branches/main/protection \
  --method PUT \
  --input - <<'EOF'
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
```

### rhcl-ai (`master`) — same pattern

```bash
gh api repos/Everything-is-Code/rhcl-ai/branches/master/protection \
  --method PUT \
  --input - <<'EOF'
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
```

### Add required checks later (example)

```json
"required_status_checks": {
  "strict": true,
  "checks": [
    { "context": "test" }
  ]
}
```

Job `context` must match the name shown in the PR checks UI (often `Workflow / Job`).

---

## Suggested GitHub issue (PO)

Title: `[HYGIENE] Enable branch protection on default branches`

Body:

- Enable PR-required merge on rhcl-ai (`master`), 3scaleextract (`main`), gateforge (`main`)
- Phase 1: 1 approval, no force push
- Phase 2 (after GF-3): require CI test jobs
- Document exact check names in this file

**Priority:** P1 before assigning issues to external coders.

---

## Relation to evolution backlog

Branch protection is item **#1** in [practices-evolution-backlog.md](practices-evolution-backlog.md).

Auto-merge (dependabot) and required checks depend on this being in place first.
