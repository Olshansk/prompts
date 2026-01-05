# Python Makefile Template (using uv)
# Copy this file to your project root as 'Makefile'
#
# Prerequisites:
#   - uv installed (https://github.com/astral-sh/uv)
#   - pyproject.toml (preferred) or requirements.txt

.DEFAULT_GOAL := help

# ============================================================================
# Configuration
# ============================================================================
-include .env
.EXPORT_ALL_VARIABLES:

FIX ?= false

# ============================================================================
# Colors & Symbols
# ============================================================================
GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
CYAN   := \033[0;36m
BOLD   := \033[1m
RESET  := \033[0m

CHECK := ✓
CROSS := ✗

# ============================================================================
# Print Helpers
# ============================================================================
define print_success
	@printf "$(GREEN)$(BOLD) $(CHECK) %s$(RESET)\n" "$(1)"
endef

define print_warning
	@printf "$(YELLOW) %s$(RESET)\n" "$(1)"
endef

define print_section
	@printf "\n$(CYAN)$(BOLD)%s$(RESET)\n" "$(1)"
endef

# ============================================================================
# Environment
# ============================================================================
.PHONY: env-install env-sync clean-env

env-install: ## Install dependencies (uv sync)
	$(call print_section,Installing dependencies)
	@command -v uv >/dev/null 2>&1 || { printf "$(RED)$(CROSS) uv not installed$(RESET)\n"; exit 1; }
	uv sync --all-extras
	$(call print_success,Dependencies installed)

env-sync: ## Sync dependencies (uv sync)
	$(call print_section,Syncing dependencies)
	uv sync
	$(call print_success,Dependencies synced)

clean-env: ## Remove virtual environment
	$(call print_warning,Removing virtual environment)
	rm -rf .venv venv
	$(call print_success,Virtual environment removed)

# ============================================================================
# Development
# ============================================================================
.PHONY: dev-run dev-check dev-format dev-test

dev-run: ## Run the application
	$(call print_section,Running application)
	uv run python main.py  # <- Adjust to your entry point

dev-check: ## Run linting and type checks (FIX=false: check only)
	$(call print_section,Running checks)
ifeq ($(FIX),true)
	uv run ruff check --fix src/ tests/
	uv run ruff format src/ tests/
else
	uv run ruff check src/ tests/
	uv run ruff format --check src/ tests/
endif
	uv run mypy src/
	$(call print_success,All checks passed)

dev-format: ## Format code (FIX=false: check only)
	$(call print_section,Formatting code)
ifeq ($(FIX),true)
	uv run ruff check --fix src/ tests/
	uv run ruff format src/ tests/
else
	uv run ruff check src/ tests/
	uv run ruff format --check src/ tests/
endif
	$(call print_success,Formatting complete)

dev-test: ## Run tests (pytest)
	$(call print_section,Running tests)
	uv run pytest tests/ -v
	$(call print_success,Tests passed)

# ============================================================================
# Cleaning
# ============================================================================
.PHONY: clean clean-all

clean: ## Clean Python cache files
	$(call print_warning,Cleaning Python cache)
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	$(call print_success,Cleaned)

clean-all: clean clean-env ## Clean everything

# ============================================================================
# Help (keep near end, before catch-all)
# ============================================================================
.PHONY: help help-unclassified

help: ## Show available commands
	@printf "\n"
	@printf "$(BOLD)$(CYAN)╔═══════════════════════════╗$(RESET)\n"
	@printf "$(BOLD)$(CYAN)║     Python Project        ║$(RESET)\n"
	@printf "$(BOLD)$(CYAN)╚═══════════════════════════╝$(RESET)\n\n"
	@printf "$(BOLD)=== 🐍 Environment ===$(RESET)\n"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "env-install" "Install dependencies (uv sync)"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "env-sync" "Sync dependencies (uv sync)"
	@printf "\n"
	@printf "$(BOLD)=== 🛠️  Development ===$(RESET)\n"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "dev-run" "Run the application"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "dev-check" "Run linting and type checks (FIX=false: check only)"
	@printf "%-25s $(GREEN)make dev-check FIX=true$(RESET)  <- auto-fix issues\n" ""
	@printf "$(CYAN)%-25s$(RESET) %s\n" "dev-format" "Format code (FIX=false: check only)"
	@printf "%-25s $(GREEN)make dev-format FIX=true$(RESET) <- apply fixes\n" ""
	@printf "$(CYAN)%-25s$(RESET) %s\n" "dev-test" "Run tests (pytest)"
	@printf "\n"
	@printf "$(BOLD)=== 🧹 Cleaning ===$(RESET)\n"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "clean" "Clean Python cache files"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "clean-env" "Remove virtual environment"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "clean-all" "Clean everything"
	@printf "\n"
	@printf "$(BOLD)=== ❓ Help ===$(RESET)\n"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "help" "Show this help"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "help-unclassified" "Show targets not in categorized help"
	@printf "\n"

help-unclassified: ## Show targets not in categorized help
	@printf "$(BOLD)Targets not in main help:$(RESET)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		sed 's/^[^:]*://' | \
		grep -v -E '^(env-|dev-|clean|help)' | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-25s$(RESET) %s\n", $$1, $$2}' || \
		printf "  (none)\n"

# ============================================================================
# Error Handling (keep at end)
# ============================================================================
%:
	@printf "$(RED)$(CROSS) Unknown target '$@'$(RESET)\n"
	@printf "   Run $(CYAN)make help$(RESET) to see available targets\n"
	@exit 1
