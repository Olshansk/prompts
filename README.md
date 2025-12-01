# Prompts <!-- omit in toc -->

Centralized repository for LLM prompts across Claude, Gemini, and Codex.

- [Structure](#structure)
- [Setup](#setup)
- [Syncing](#syncing)
- [What's Included](#whats-included)

## Structure

```
prompts/
├── Makefile        # Sync commands
├── README.md
├── claude/         # Claude Code configs
│   ├── agents/
│   ├── commands/
│   └── CLAUDE.md
├── gemini/         # Gemini configs
└── codex/          # Codex configs
```

<!-- TODO: Add shared/ directory for prompts that work across all tools -->

## Setup

Clone and copy configs to your local tool directories:

```bash
# Clone
git clone https://github.com/olshansky/prompts.git ~/workspace/prompts

# Copy Claude configs
cp -r ~/workspace/prompts/claude/* ~/.claude/

# Copy Gemini configs
cp -r ~/workspace/prompts/gemini/* ~/.gemini/

# Copy Codex configs
cp -r ~/workspace/prompts/codex/* ~/.codex/
```

## Syncing

This repo mirrors your local configs. Source of truth is your local `~/.<tool>/` directories.

```bash
# Sync all tools
make sync-all

# Or sync individually
make sync-claude
make sync-gemini
make sync-codex

# Check status
make status

# Then commit
git add -A && git commit -m "Update configs" && git push
```

## What's Included

**Claude** (`claude/`)
- `agents/` - Custom Claude Code agents
- `commands/` - Slash commands
- `CLAUDE.md` - Global instructions

**Gemini** (`gemini/`)
- TBD

**Codex** (`codex/`)
- TBD
