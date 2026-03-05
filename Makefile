########################
### Makefile Helpers ###
########################

BOLD := \033[1m
CYAN := \033[36m
RESET := \033[0m

REPO_SKILLS := $(CURDIR)/skills
SHARE_TARGETS := $(HOME)/.gemini/antigravity/skills $(HOME)/.codex/skills

.PHONY: help
.DEFAULT_GOAL := help
help: ## Prints all the targets in the Makefile
	@echo ""
	@echo "$(BOLD)$(CYAN)Agent Skills Repository$(RESET)"
	@echo ""
	@echo "$(BOLD)=== Skills ===$(RESET)"
	@grep -h -E '^(link|share|list).*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)=== Sync Configs ===$(RESET)"
	@grep -h -E '^sync.*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)=== Setup ===$(RESET)"
	@grep -h -E '^setup.*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)=== Info ===$(RESET)"
	@grep -h -E '^(help|status|test).*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""

########################
### Setup            ###
########################

.PHONY: setup
setup: ## First-time setup: replace real dirs with repo symlinks for all agents
	@echo "Setting up symlinks for all agents..."
	@echo ""
	@echo "=== Claude ==="
	@mkdir -p $(HOME)/.claude/skills
	@for skill in $(REPO_SKILLS)/*/; do \
		name=$$(basename "$$skill"); \
		target="$(HOME)/.claude/skills/$$name"; \
		if [ -d "$$target" ] && ! [ -L "$$target" ]; then \
			rm -rf "$$target"; \
			echo "  removed real dir $$name"; \
		fi; \
		if [ -L "$$target" ]; then \
			current=$$(readlink "$$target"); \
			if [ "$$current" != "$$skill" ]; then \
				rm "$$target"; \
				ln -s "$$skill" "$$target"; \
				echo "  ~ $$name (repointed)"; \
			else \
				echo "  skip $$name (already correct)"; \
			fi; \
		else \
			ln -s "$$skill" "$$target"; \
			echo "  + $$name"; \
		fi; \
	done
	@echo ""
	@echo "=== Gemini & Codex ==="
	@for target_dir in $(SHARE_TARGETS); do \
		mkdir -p "$$target_dir"; \
		for skill in $(REPO_SKILLS)/*/; do \
			name=$$(basename "$$skill"); \
			link="$$target_dir/$$name"; \
			if [ -L "$$link" ]; then \
				current=$$(readlink "$$link"); \
				if [ "$$current" != "$$skill" ]; then \
					rm "$$link"; \
					ln -s "$$skill" "$$link"; \
					echo "  ~ $$name -> $$target_dir (repointed)"; \
				fi; \
			elif [ -e "$$link" ]; then \
				echo "  WARN $$name in $$target_dir (real dir, skipped)"; \
			else \
				ln -s "$$skill" "$$link"; \
				echo "  + $$name -> $$target_dir"; \
			fi; \
		done; \
	done
	@echo ""
	@echo "Done. All agents share skills from this repo."

########################
### Skills           ###
########################

.PHONY: link-skills
link-skills: ## Symlink repo skills into ~/.claude/skills/
	@echo "Linking skills to ~/.claude/skills/..."
	@mkdir -p $(HOME)/.claude/skills
	@for skill in $(REPO_SKILLS)/*/; do \
		name=$$(basename "$$skill"); \
		target="$(HOME)/.claude/skills/$$name"; \
		if [ -L "$$target" ]; then \
			echo "  skip $$name (symlink exists)"; \
		elif [ -e "$$target" ]; then \
			echo "  WARN $$name (real dir exists, remove manually to link)"; \
		else \
			ln -s "$$skill" "$$target"; \
			echo "  + $$name"; \
		fi; \
	done
	@# Prune stale symlinks pointing into this repo's skills/
	@for link in $(HOME)/.claude/skills/*; do \
		[ -L "$$link" ] || continue; \
		readlink "$$link" | grep -q "$(REPO_SKILLS)" || continue; \
		[ -e "$$link" ] || { echo "  - $$(basename $$link) (stale)"; rm -f "$$link"; }; \
	done
	@echo "Done"

.PHONY: share-skills
share-skills: ## Symlink repo skills into gemini and codex
	@echo "Sharing skills across agents..."
	@for target_dir in $(SHARE_TARGETS); do \
		mkdir -p "$$target_dir"; \
		for skill in $(REPO_SKILLS)/*/; do \
			name=$$(basename "$$skill"); \
			[ -e "$$target_dir/$$name" ] && continue; \
			ln -s "$$skill" "$$target_dir/$$name"; \
			echo "  + $$name -> $$target_dir"; \
		done; \
		for link in "$$target_dir"/*; do \
			[ -L "$$link" ] || continue; \
			readlink "$$link" | grep -q "$(REPO_SKILLS)" || continue; \
			[ -e "$$link" ] || { echo "  - $$(basename $$link) (stale)"; rm -f "$$link"; }; \
		done; \
	done
	@echo "Done"

.PHONY: list-skills
list-skills: ## List all skills with descriptions
	@echo ""
	@echo "$(BOLD)$(CYAN)Published Skills$(RESET)"
	@echo ""
	@for skill in $(REPO_SKILLS)/*/SKILL.md; do \
		name=$$(grep "^name:" "$$skill" | sed 's/name: *//'); \
		desc=$$(grep "^description:" "$$skill" | sed 's/description: *//; s/^"//; s/"$$//'); \
		printf "  $(CYAN)%-35s$(RESET) %s\n" "$$name" "$$desc"; \
	done
	@echo ""

#############################
### Sync Configs           ###
#############################

.PHONY: sync-all
sync-all: sync-claude sync-gemini sync-codex ## Sync all tool configs

.PHONY: sync-claude
sync-claude: ## Sync from ~/.claude to configs/claude/ (excludes skills, plugins, commands)
	@echo "Syncing from ~/.claude (configs only)..."
	@mkdir -p configs/claude
	@if [ -d ~/.claude/agents ]; then rsync -a --delete --exclude '.git' ~/.claude/agents configs/claude/; else rm -rf configs/claude/agents; fi
	@[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md configs/claude/ || true
	@[ -f ~/.claude/Makefile ] && cp ~/.claude/Makefile configs/claude/ || true
	@[ -f ~/.claude/ideas.md ] && cp ~/.claude/ideas.md configs/claude/ || true
	@[ -f ~/.claude/.markdownlint.json ] && cp ~/.claude/.markdownlint.json configs/claude/ || true
	@echo "Done"

.PHONY: sync-gemini
sync-gemini: ## Sync from ~/.gemini to configs/gemini/
	@echo "Syncing from ~/.gemini..."
	@mkdir -p configs/gemini
	@if [ -d ~/.gemini/commands ]; then rsync -a --delete --exclude '.git' ~/.gemini/commands configs/gemini/; else rm -rf configs/gemini/commands; fi
	@[ -f ~/.gemini/GEMINI.md ] && cp ~/.gemini/GEMINI.md configs/gemini/ || true
	@# NOTE: settings.json is gitignored (may contain tokens) but synced for local backup
	@[ -f ~/.gemini/settings.json ] && cp ~/.gemini/settings.json configs/gemini/ || true
	@echo "Done"

.PHONY: sync-codex
sync-codex: ## Sync from ~/.codex to configs/codex/
	@echo "Syncing from ~/.codex..."
	@mkdir -p configs/codex
	@if [ -d ~/.codex/prompts ]; then rsync -a --delete --exclude '.git' ~/.codex/prompts configs/codex/; else rm -rf configs/codex/prompts; fi
	@if [ -d ~/.codex/rules ]; then rsync -a --delete --exclude '.git' ~/.codex/rules configs/codex/; else rm -rf configs/codex/rules; fi
	@[ -f ~/.codex/config.toml ] && cp ~/.codex/config.toml configs/codex/ || true
	@# NOTE: configs/codex/AGENTS.md is a symlink to configs/claude/CLAUDE.md — not synced separately
	@echo "Done"

########################
### Info             ###
########################

.PHONY: status
status: ## Show repository status
	@echo "Repository Status:"
	@echo "  Skills:  $$(find skills -maxdepth 1 -mindepth 1 -type d 2>/dev/null | wc -l | tr -d ' ') skills"
	@echo "  Claude:  $$(find configs/claude -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ') config files"
	@echo "  Gemini:  $$(find configs/gemini -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ') config files"
	@echo "  Codex:   $$(find configs/codex -type f -name '*.md' 2>/dev/null | wc -l | tr -d ' ') config files"

.PHONY: test
test: ## Validate skill frontmatter and repo consistency
	@echo "Running checks..."
	@errors=0; \
	for skill in $(REPO_SKILLS)/*/SKILL.md; do \
		name=$$(grep "^name:" "$$skill" | sed 's/name: *//'); \
		desc=$$(grep "^description:" "$$skill" | sed 's/description: *//'); \
		dir_name=$$(basename $$(dirname "$$skill")); \
		if [ -z "$$name" ]; then \
			echo "  FAIL $$dir_name: missing 'name' in frontmatter"; errors=$$((errors+1)); \
		elif [ "$$name" != "$$dir_name" ]; then \
			echo "  FAIL $$dir_name: name '$$name' doesn't match directory"; errors=$$((errors+1)); \
		fi; \
		if [ -z "$$desc" ]; then \
			echo "  FAIL $$dir_name: missing 'description' in frontmatter"; errors=$$((errors+1)); \
		fi; \
	done; \
	skill_count=$$(find skills -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' '); \
	skillmd_count=$$(find skills -name SKILL.md | wc -l | tr -d ' '); \
	if [ "$$skill_count" != "$$skillmd_count" ]; then \
		echo "  FAIL skill dir count ($$skill_count) != SKILL.md count ($$skillmd_count)"; errors=$$((errors+1)); \
	fi; \
	echo "  $$skill_count skills checked"; \
	if [ $$errors -gt 0 ]; then \
		echo "FAILED: $$errors error(s)"; exit 1; \
	else \
		echo "All checks passed"; \
	fi
