# Configs <!-- omit in toc -->

Read-only snapshots of agent configuration files, synced from local tool directories.

These are **not** the source of truth. The live configs are:

| File | Source of truth | Synced via |
|------|----------------|------------|
| `claude/CLAUDE.md` | `~/workspace/configs/agents/AGENTS.md` | `make sync-claude` |
| `codex/AGENTS.md` | Symlink to `claude/CLAUDE.md` | — |
| `gemini/GEMINI.md` | `~/workspace/configs/agents/MEMORIES.md` | `make sync-gemini` |

**To update agent instructions:** edit `~/workspace/configs/agents/AGENTS.md` directly.

**To snapshot current configs into this repo:** run `make sync-all`.
