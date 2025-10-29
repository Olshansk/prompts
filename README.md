# Prompts <!-- omit in toc -->

If you're reading this, it's like you came here from my post on [My Claude Code Agent for Writing Prompts](https://olshansky.info/posts/2025-09-29-prompt-writer-agent).

I'll be using this repo to centralize all my prompts across various Desktop Apps IDEs, CLIs and other tools.

Leave a :star: to follow along :)

- [Setup](#setup)
- [What's Included](#whats-included)

## Setup

**Source of Truth:** Your `~/.claude` directory contains the actual files you use with Claude Code. This repo is a public mirror of those configs.

To use these configs:

```bash
# Clone the repo
git clone https://github.com/olshansky/prompts.git ~/workspace/prompts

# Copy items you want to your ~/.claude directory
cp -r ~/workspace/prompts/agents ~/.claude/
cp -r ~/workspace/prompts/commands ~/.claude/
cp ~/workspace/prompts/CLAUDE.md ~/.claude/
```

### Syncing Your Own Configs

If you're maintaining your own fork and want to sync changes from `~/.claude` to your repo:

```bash
# From the repo directory
./sync-from-claude.sh

# Then commit and push
git add -A
git commit -m "Update configs"
git push
```

The `sync-from-claude.sh` script copies public configs from `~/.claude` to this repo.

## What's Included

- `agents/` - Custom Claude Code agents
- `commands/` - Slash commands
- `CLAUDE.md` - Global instructions for Claude Code
