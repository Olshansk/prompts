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
	@[ -d ~/.claude/agents ] && cp -r ~/.claude/agents claude/ || true
	@[ -d ~/.claude/commands ] && cp -r ~/.claude/commands claude/ || true
	@[ -d ~/.claude/skills ] && cp -r ~/.claude/skills claude/ || true
	@[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md claude/ || true
	@[ -f ~/.claude/Makefile ] && cp ~/.claude/Makefile claude/ || true
	@[ -f ~/.claude/ideas.md ] && cp ~/.claude/ideas.md claude/ || true
	@[ -f ~/.claude/.markdownlint.json ] && cp ~/.claude/.markdownlint.json claude/ || true
	@echo "Done"

.PHONY: sync-gemini
sync-gemini: ## Sync from ~/.gemini to gemini/
	@echo "Syncing from ~/.gemini..."
	@[ -d ~/.gemini/commands ] && cp -r ~/.gemini/commands gemini/ || true
	@[ -f ~/.gemini/GEMINI.md ] && cp ~/.gemini/GEMINI.md gemini/ || true
	@[ -f ~/.gemini/settings.json ] && cp ~/.gemini/settings.json gemini/ || true
	@echo "Done"

.PHONY: sync-codex
sync-codex: ## Sync from ~/.codex to codex/
	@echo "Syncing from ~/.codex..."
	@[ -d ~/.codex/prompts ] && cp -r ~/.codex/prompts codex/ || true
	@[ -d ~/.codex/rules ] && cp -r ~/.codex/rules codex/ || true
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
