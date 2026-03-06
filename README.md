# Agent Skills <!-- omit in toc -->

Reusable skills for Claude Code, Gemini, and Codex.

- [Architecture](#architecture)
- [Install](#install)
- [Skills](#skills)
- [Local Development](#local-development)
- [Makefile Targets](#makefile-targets)

## Architecture

Three repos and one third-party directory work together:

| Location | What it holds | Role |
|----------|--------------|------|
| `~/workspace/personal-agent-skills/` (this repo) | `skills/` — 19 reusable skills | **SoT for skills** |
| `~/workspace/configs/agents/` | `AGENTS.md`, `MEMORIES.md` | **SoT for agent instructions** |
| `~/.agents/skills/` | Third-party skills (find-skills, vercel-*, etc.) | Managed by `skills.sh` |
| `~/workspace/personal-agent-skills/configs/` | Snapshots of tool configs | Read-only reference (not SoT) |

### Skills — symlink flow

Every agent tool directory symlinks directly to this repo (single hop):

```
~/workspace/personal-agent-skills/skills/cmd-foo/SKILL.md     ← source of truth
    ↑
    ├── ~/.claude/skills/cmd-foo
    ├── ~/.gemini/antigravity/skills/cmd-foo
    └── ~/.codex/skills/cmd-foo
```

Third-party skills symlink separately to `~/.agents/skills/` — this repo doesn't manage those.

### Agent instructions — symlink flow

Agent instruction files live in a separate repo and are already symlinked:

```
~/workspace/configs/agents/AGENTS.md    ← source of truth
    ↑
    ├── ~/.claude/CLAUDE.md
    └── ~/.codex/AGENTS.md

~/workspace/configs/agents/MEMORIES.md  ← source of truth
    ↑
    └── ~/.gemini/GEMINI.md
```

### Configs snapshots

`configs/` in this repo contains read-only copies of tool configs, synced via `make sync-all`. These are for reference and git history — not the live SoT. See [`configs/README.md`](configs/README.md).

## Install

**All skills:**

```bash
npx skills add olshansky/personal-agent-skills
```

**Individual skill:**

```bash
npx skills add olshansky/personal-agent-skills/skills/cmd-pr-description
```

## Skills

| Skill | Description |
|-------|-------------|
| `cmd-chain-halt-code-reviewer` | Review protocol code for chain halt risks, non-determinism, and onchain behavior bugs |
| `cmd-clean-code` | Improve code readability without altering functionality using idiomatic best practices |
| `cmd-code-cleanup` | Remove dead code and duplication pragmatically with a 5-phase systematic approach |
| `cmd-code-review-sweep` | Review changes for test gaps, simplification, naming consistency, reuse opportunities, and TODO quality |
| `cmd-gh-issue` | Create structured GitHub issues from conversation context using gh CLI |
| `cmd-idiot-proof-docs` | Simplify documentation for clarity and scannability with approval-gated edits |
| `cmd-mermaid-diagram` | Generate and edit Mermaid flowcharts and sequence diagrams with syntax validation and style guidance |
| `cmd-pr-build-context` | Build high-signal PR context for review with diff analysis, risk assessment, and discussion questions |
| `cmd-pr-conflict-resolver` | Resolve merge conflicts systematically with context-aware 3-tier classification and escalation protocol |
| `cmd-pr-description` | Generate concise PR descriptions by analyzing the diff against a base branch |
| `cmd-pr-review-prepare` | Prepare branch for code review by building context, identifying issues, and suggesting improvements |
| `cmd-pr-test-plan` | Generate manual test plans for PR changes with verified commands and pass/fail criteria |
| `cmd-productionize` | Transform applications into production-ready deployments with systematic analysis and framework-specific optimization |
| `cmd-python-stylizer` | Analyze Python code for style improvements including naming, structure, nesting, and cognitive load reduction |
| `cmd-rfc-review` | Review RFCs for problem clarity, compliance, security, and performance using SCQA framework |
| `cmd-rss-feed-generator` | Generate Python RSS feed scrapers from blog websites, integrated with hourly GitHub Actions |
| `cmd-scope-sweep` | Final pass to identify missed items, edge cases, and risks before considering a scope done |
| `debug-timeouts` | Systematically analyze and debug timeout hierarchies across application layers to identify conflicts and root causes |
| `makefile` | Create or improve Makefiles with minimal complexity. Templates for python-uv, python-fastapi, nodejs, go, chrome-extension, flutter |

All `cmd-*` skills are slash commands — invoke with `/cmd-pr-description`, `/cmd-code-cleanup`, etc.

## Local Development

**First-time setup** — replaces real dirs with repo symlinks for all agents:

```bash
make setup
```

**Link skills to Claude only:**

```bash
make link-skills
```

**Share skills to Gemini and Codex:**

```bash
make share-skills
```

## Makefile Targets

| Target | Description |
|--------|-------------|
| `make setup` | First-time setup: replace real dirs with repo symlinks for all agents |
| `make link-skills` | Symlink repo skills into `~/.claude/skills/` |
| `make share-skills` | Symlink repo skills into Gemini and Codex |
| `make list-skills` | List all skills with descriptions |
| `make sync-all` | Sync all tool configs into `configs/` |
| `make test` | Validate skill frontmatter and repo consistency |
| `make status` | Show repository status |
