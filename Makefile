########################
### Makefile Helpers ###
########################

# ANSI color codes
BOLD := \033[1m
CYAN := \033[36m
RESET := \033[0m

.PHONY: help
.DEFAULT_GOAL := help
help: ## Prints all the targets in the Makefile
	@echo ""
	@echo "$(BOLD)$(CYAN)Multi-LLM Prompt Repository$(RESET)"
	@echo ""
	@echo "$(BOLD)=== Sync Commands ===$(RESET)"
	@grep -h -E '^sync.*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)=== Info ===$(RESET)"
	@grep -h -E '^(help|status):.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""

#############################
### Sync Commands         ###
#############################

.PHONY: sync-all
sync-all: sync-claude sync-gemini sync-codex ## Sync all tools

.PHONY: sync-claude
sync-claude: ## Sync from ~/.claude to claude/
	@echo "Syncing from ~/.claude..."
	@if [ -d ~/.claude/agents ]; then rsync -a --delete --exclude '.git' ~/.claude/agents claude/; else rm -rf claude/agents; fi
	@if [ -d ~/.claude/commands ]; then rsync -a --delete --exclude '.git' ~/.claude/commands claude/; else rm -rf claude/commands; fi
	@if [ -d ~/.claude/skills ]; then rsync -a --delete --exclude '.git' ~/.claude/skills claude/; else rm -rf claude/skills; fi
	@if [ -d ~/.claude/plugins ]; then rsync -a --delete --exclude '.git' ~/.claude/plugins claude/; else rm -rf claude/plugins; fi
	@[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md claude/ || true
	@[ -f ~/.claude/Makefile ] && cp ~/.claude/Makefile claude/ || true
	@[ -f ~/.claude/ideas.md ] && cp ~/.claude/ideas.md claude/ || true
	@[ -f ~/.claude/.markdownlint.json ] && cp ~/.claude/.markdownlint.json claude/ || true
	@echo "Done"

.PHONY: sync-gemini
sync-gemini: ## Sync from ~/.gemini to gemini/
	@echo "Syncing from ~/.gemini..."
	@if [ -d ~/.gemini/commands ]; then rsync -a --delete --exclude '.git' ~/.gemini/commands gemini/; else rm -rf gemini/commands; fi
	@[ -f ~/.gemini/GEMINI.md ] && cp ~/.gemini/GEMINI.md gemini/ || true
	@[ -f ~/.gemini/settings.json ] && cp ~/.gemini/settings.json gemini/ || true
	@echo "Done"

.PHONY: sync-codex
sync-codex: ## Sync from ~/.codex to codex/
	@echo "Syncing from ~/.codex..."
	@if [ -d ~/.codex/prompts ]; then rsync -a --delete --exclude '.git' ~/.codex/prompts codex/; else rm -rf codex/prompts; fi
	@if [ -d ~/.codex/rules ]; then rsync -a --delete --exclude '.git' ~/.codex/rules codex/; else rm -rf codex/rules; fi
	@[ -f ~/.codex/config.toml ] && cp ~/.codex/config.toml codex/ || true
	@[ -f ~/.codex/AGENTS.md ] && cp ~/.codex/AGENTS.md codex/ || true
	@echo "Done"

#############################
### Info                  ###
#############################

.PHONY: status
status: ## Show repository status
	@echo "Repository Status:"
	@echo "  Claude:  $$(find claude -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ') files"
	@echo "  Gemini:  $$(find gemini -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ') files"
	@echo "  Codex:   $$(find codex -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ') files"
