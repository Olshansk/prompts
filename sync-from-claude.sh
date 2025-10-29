#!/bin/bash
# Sync public configs from ~/.claude to this repo

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Syncing from ~/.claude to $REPO_DIR..."

# Copy directories
if [ -d ~/.claude/agents ]; then
  echo "  Copying agents/"
  cp -r ~/.claude/agents "$REPO_DIR/"
fi

if [ -d ~/.claude/commands ]; then
  echo "  Copying commands/"
  cp -r ~/.claude/commands "$REPO_DIR/"
fi

# Copy files
if [ -f ~/.claude/CLAUDE.md ]; then
  echo "  Copying CLAUDE.md"
  cp ~/.claude/CLAUDE.md "$REPO_DIR/"
fi

if [ -f ~/.claude/Makefile ]; then
  echo "  Copying Makefile"
  cp ~/.claude/Makefile "$REPO_DIR/"
fi

if [ -f ~/.claude/.markdownlint.json ]; then
  echo "  Copying .markdownlint.json"
  cp ~/.claude/.markdownlint.json "$REPO_DIR/"
fi

echo "Sync complete!"
echo ""
echo "Next steps:"
echo "  cd $REPO_DIR"
echo "  git status"
echo "  git add -A"
echo "  git commit -m 'Update configs'"
echo "  git push"
