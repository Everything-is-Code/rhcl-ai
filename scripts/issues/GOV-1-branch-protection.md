## Context

Default branches are **not protected** today. Anyone with write access can push directly to `main`/`master` and skip PR review.

PO draft: [docs/drafts/branch-protection.md](https://github.com/Everything-is-Code/rhcl-ai/blob/master/docs/drafts/branch-protection.md)

## Scope

| Repo | Default branch |
|------|----------------|
| rhcl-ai | `master` |
| 3scaleextract | `main` |
| gateforge | `main` |

## Phase 1 — Before onboarding coders (now)

Enable via GitHub Settings or org ruleset:

- [ ] Require pull request before merge
- [ ] Require 1 approval
- [ ] Dismiss stale reviews on new commits
- [ ] Block force push and branch deletion
- [ ] Allow admin bypass for PO hotfixes

Apply to all three repos.

## Phase 2 — After M1 CI (GF-3, EXT-4)

- [ ] Require status checks to pass
- [ ] Require branch up to date
- [ ] Document exact job names in branch-protection draft

## Acceptance criteria

- [ ] Direct push to default branch blocked for non-admin (or all devs)
- [ ] PO documents check names when CI jobs exist
- [ ] Team notified in Red Hat channel

## Priority

**P1** — enable Phase 1 before assigning work to external coders.

## Related

- [practices-evolution-backlog.md](https://github.com/Everything-is-Code/rhcl-ai/blob/master/docs/drafts/practices-evolution-backlog.md) item #1
