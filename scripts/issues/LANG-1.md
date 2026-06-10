## Policy

The RHCL program uses **English only** for:

- Agent context: `AGENTS.md`, `CLAUDE.md`, Cursor rules, skills
- Documentation, READMEs, GitHub issues, PR descriptions
- Code comments and user-facing CLI messages (where applicable)

## rhcl-ai status

**Done in this repo** (track in parent issue): AGENTS.md, CLAUDE.md, rules, skills, docs, templates translated to English.

## Remaining work — 3scaleextract

Primary gap: **README and docs are in Spanish**.

| File | Language | Action |
|------|----------|--------|
| `README.md` | Spanish | Full translation to English |
| `docs/SEED.md` | Mixed/Spanish | Translate to English |
| `docs/VISUALIZE.md` | Mixed/Spanish | Translate to English |
| CLI help strings | Check | English only |

Cross-link: [3scaleextract#11](https://github.com/Everything-is-Code/3scaleextract/issues/11)

## Remaining work — gateforge

| File | Action |
|------|--------|
| `README.md` | Audit for Spanish; already mostly English |
| UI strings | Audit Angular templates for i18n (future) |
| Error messages | English only in backend |

## Acceptance criteria

- [ ] All rhcl-ai agent files verified English (rules, skills, AGENTS.md)
- [ ] 3scaleextract README + docs/ in English
- [ ] `AGENTS.md` language policy linked from README in all three repos
- [ ] New contributions default to English (documented in CONTRIBUTING / AGENTS)

## Priority

**P2** — Hygiene / team onboarding. Blocks international Red Hat contributors and consistent AI agent behavior.

**Milestone:** M1 - Test foundation (or dedicated hygiene sprint)

## Related

- rhcl-ai [AGENTS.md — Language policy](https://github.com/Everything-is-Code/rhcl-ai/blob/master/AGENTS.md)
- Rule `rhcl-global.mdc`: English only for agent context
