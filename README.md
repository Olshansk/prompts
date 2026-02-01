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
- `plugins/` - Local plugins
- `CLAUDE.md` - Global instructions

**Gemini** (`gemini/`)
- TBD

**Codex** (`codex/`)
- TBD

## Plugin Installation

Claude Code plugins require two steps: copying files and enabling in settings.

### 1. Copy Plugin Files

```bash
# Copy all plugins
cp -r ~/workspace/prompts/claude/plugins/* ~/.claude/plugins/
```

### 2. Enable Plugins

Add the plugin to `~/.claude/settings.json` under `enabledPlugins`:

```json
{
  "enabledPlugins": {
    "agent-session-commit": true
  }
}
```

### Available Plugins

| Plugin | Description | Command |
|--------|-------------|---------|
| `agent-session-commit` | Capture session learnings to AGENTS.md | `/session-commit` |

### Verify Installation

```bash
# Check plugin is loaded
claude --debug 2>&1 | grep -i "agent-session-commit"

# Or start Claude and run
/session-commit
```
