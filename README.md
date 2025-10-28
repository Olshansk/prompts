# Prompts <!-- omit in toc -->

If you're reading this, it's like you came here from my post on [My Claude Code Agent for Writing Prompts](https://olshansky.info/posts/2025-09-29-prompt-writer-agent).

I'll be using this repo to centralize all my prompts across various Desktop Apps IDEs, CLIs and other tools.

Leave a :star: to follow along :)

- [Setup](#setup)
- [What's Included](#whats-included)

## Setup

**Source of Truth:** Your `~/.claude` directory contains the actual files. This repo contains symlinks to those files for version control.

Clone this repo and symlink items from your `~/.claude` directory into it:

```bash
# Clone the repo wherever you want
git clone https://github.com/olshansky/prompts.git ~/workspace/prompts

# From the cloned repo, create symlinks pointing to your Claude config
cd ~/workspace/prompts

# Create symlinks from repo to your ~/.claude directory
ln -sf ~/.claude/agents agents
ln -sf ~/.claude/commands commands
ln -sf ~/.claude/CLAUDE.md CLAUDE.md
```

Now when you edit files in `~/.claude`, changes are automatically reflected in this repo via symlinks. Commit and push from this repo to version control your configs.

## What's Included

- `agents/` - Custom Claude Code agents
- `commands/` - Slash commands
- `CLAUDE.md` - Global instructions for Claude Code
