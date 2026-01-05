# Node.js Makefile Template
# Copy this file to your project root as 'Makefile'
#
# Features:
#   - Environment switching (local, testnet, prod)
#   - Node.js version validation
#   - Status dashboard
#   - Quick start workflow
#
# Works with npm, pnpm, or yarn (adjust PKG_MANAGER below)

.DEFAULT_GOAL := help

# ============================================================================
# Configuration (adjust these)
# ============================================================================
PKG_MANAGER := npm
# PKG_MANAGER := pnpm
# PKG_MANAGER := yarn

# Required Node.js version (from package.json engines field)
REQUIRED_NODE_VERSION := 20.0.0

# ============================================================================
# Colors & Symbols
# ============================================================================
GREEN   := \033[0;32m
YELLOW  := \033[1;33m
RED     := \033[0;31m
CYAN    := \033[0;36m
BLUE    := \033[0;34m
MAGENTA := \033[0;35m
BOLD    := \033[1m
DIM     := \033[2m
RESET   := \033[0m

CHECK := ✓
CROSS := ✗
WARN  := ⚠️
INFO  := ℹ️
ARROW := →

# ============================================================================
# Print Helpers
# ============================================================================
define print_success
	@printf "$(GREEN)$(BOLD) $(CHECK) %s$(RESET)\n" "$(1)"
endef

define print_warning
	@printf "$(YELLOW)$(WARN) %s$(RESET)\n" "$(1)"
endef

define print_info
	@printf "$(CYAN)$(INFO) %s$(RESET)\n" "$(1)"
endef

define print_section
	@printf "\n$(CYAN)$(BOLD)%s$(RESET)\n" "$(1)"
endef

# ============================================================================
# Guard Helpers
# ============================================================================
define check_command
	@command -v $(1) >/dev/null 2>&1 || { \
		printf "$(RED)$(CROSS) Missing tool: $(1)$(RESET)\n"; \
		exit 1; \
	}
endef

define check_file
	@if [ ! -f "$(1)" ]; then \
		printf "$(RED)$(CROSS) Missing file: $(1)$(RESET)\n"; \
		exit 1; \
	fi
endef

define check_node_version
	@command -v node >/dev/null 2>&1 || { \
		printf "$(RED)$(CROSS) Node.js is not installed$(RESET)\n"; \
		exit 1; \
	}; \
	NODE_VERSION=$$(node -v | sed 's/v//'); \
	REQUIRED="$(REQUIRED_NODE_VERSION)"; \
	if ! printf '%s\n%s\n' "$$REQUIRED" "$$NODE_VERSION" | sort -V -C 2>/dev/null; then \
		printf "$(RED)$(CROSS) Node.js $$NODE_VERSION is too old (need >= $$REQUIRED)$(RESET)\n"; \
		exit 1; \
	fi
endef

# ============================================================================
# Help
# ============================================================================
.PHONY: help
help: ## Show available commands
	@printf "\n$(BOLD)$(CYAN)📋 Node.js Project$(RESET)\n\n"
	@printf "$(BOLD)=== 🚀 Quick Start ===$(RESET)\n"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "setup" "First-time setup (deps + env)"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "run" "Run the app"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "status" "Show environment and system info"
	@printf "\n"
	@printf "$(BOLD)=== 💻 Development ===$(RESET)\n"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "dev-run" "Start development server"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "dev-build" "Build for production"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "dev-format" "Format code (Prettier)"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "dev-lint" "Run ESLint"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "dev-typecheck" "TypeScript type check"
	@printf "\n"
	@printf "$(BOLD)=== 🌍 Environment ===$(RESET)\n"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "env-show" "Show current environment"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "env-local" "Setup local environment"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "env-testnet" "Setup testnet environment"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "env-prod" "Setup production environment"
	@printf "\n"
	@printf "$(BOLD)=== 🧹 Cleaning ===$(RESET)\n"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "clean" "Clean build artifacts"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "clean-deps" "Remove node_modules"
	@printf "$(CYAN)%-25s$(RESET) %s\n" "clean-all" "Clean everything"
	@printf "\n"

# ============================================================================
# Quick Start
# ============================================================================
.PHONY: setup run status

setup: deps-check dev-install env-local ## First-time setup
	@printf "\n"
	$(call print_success,Setup complete!)
	@printf "\n$(BOLD)Next steps:$(RESET)\n"
	@printf "  1. Run $(CYAN)make status$(RESET) to see your environment\n"
	@printf "  2. Run $(CYAN)make run$(RESET) to start the app\n"
	@printf "\n"

run: dev-run ## Run the app (alias for dev-run)

status: ## Show environment and system info
	@printf "\n$(BOLD)$(CYAN)Project Status$(RESET)\n"
	@printf "\n$(BOLD)System:$(RESET)\n"
	@command -v node >/dev/null 2>&1 && printf "  $(GREEN)$(CHECK) Node.js $$(node -v)$(RESET)\n" || printf "  $(RED)$(CROSS) Node.js not found$(RESET)\n"
	@command -v $(PKG_MANAGER) >/dev/null 2>&1 && printf "  $(GREEN)$(CHECK) $(PKG_MANAGER) $$($(PKG_MANAGER) -v)$(RESET)\n" || printf "  $(RED)$(CROSS) $(PKG_MANAGER) not found$(RESET)\n"
	@[ -d node_modules ] && printf "  $(GREEN)$(CHECK) Dependencies installed$(RESET)\n" || printf "  $(YELLOW)$(WARN) Dependencies not installed (run: make dev-install)$(RESET)\n"
	@if [ -f .env.local ]; then \
		printf "\n"; \
		make --no-print-directory env-show; \
	else \
		printf "\n$(YELLOW)$(WARN) No environment configured$(RESET)\n"; \
		printf "$(CYAN)$(INFO) Run 'make setup' to get started$(RESET)\n\n"; \
	fi

# ============================================================================
# Dependencies
# ============================================================================
.PHONY: deps-check dev-install

deps-check: ## Check Node.js and npm versions
	$(call print_section,Checking dependencies)
	$(call check_command,node)
	$(call check_node_version)
	@printf "$(GREEN)$(CHECK) Node.js $$(node -v)$(RESET)\n"
	$(call check_command,$(PKG_MANAGER))
	@printf "$(GREEN)$(CHECK) $(PKG_MANAGER) $$($(PKG_MANAGER) -v)$(RESET)\n"
	$(call print_success,All dependencies available)

dev-install: deps-check ## Install npm dependencies
	$(call print_section,Installing dependencies)
	$(PKG_MANAGER) install
	$(call print_success,Dependencies installed)

# ============================================================================
# Development
# ============================================================================
.PHONY: dev-run dev-build dev-start dev-format dev-lint dev-typecheck

dev-run: env-validate ## Start development server
	$(call print_section,Starting development server)
	@make --no-print-directory env-show
	$(call print_info,Server will be available at http://localhost:3000)
	$(PKG_MANAGER) run dev

dev-build: env-validate ## Build for production
	$(call print_section,Building for production)
	@make --no-print-directory env-show
	$(PKG_MANAGER) run build
	$(call print_success,Build complete)

dev-start: ## Start production server (requires build first)
	$(call print_section,Starting production server)
	$(call print_info,Ensure you've run 'make dev-build' first)
	$(PKG_MANAGER) start

dev-format: ## Format code with Prettier
	$(call print_section,Formatting code)
	$(PKG_MANAGER) run format
	$(call print_success,Code formatted)

dev-lint: ## Run ESLint
	$(call print_section,Running linter)
	$(PKG_MANAGER) run lint
	$(call print_success,Linting complete)

dev-typecheck: ## Run TypeScript type checking
	$(call print_section,Type checking)
	npx tsc --noEmit
	$(call print_success,Type checking complete)

# ============================================================================
# Testing
# ============================================================================
.PHONY: test test-watch test-coverage

test: ## Run tests
	$(call print_section,Running tests)
	$(PKG_MANAGER) test

test-watch: ## Run tests in watch mode
	$(PKG_MANAGER) test -- --watch

test-coverage: ## Run tests with coverage
	$(call print_section,Running tests with coverage)
	$(PKG_MANAGER) test -- --coverage

# ============================================================================
# Environment Switching
# ============================================================================
.PHONY: env-local env-testnet env-prod env-show env-validate clean-env

env-local: ## Setup local environment
	$(call print_section,Setting up LOCAL environment)
	$(call check_file,.env.local.example)
	@cp .env.local.example .env.local
	$(call print_success,Local environment configured)

env-testnet: ## Setup testnet environment
	$(call print_section,Setting up TESTNET environment)
	$(call check_file,.env.testnet.example)
	@cp .env.testnet.example .env.local
	$(call print_success,Testnet environment configured)

env-prod: ## Setup production environment
	$(call print_section,Setting up PRODUCTION environment)
	$(call check_file,.env.production.example)
	@cp .env.production.example .env.local
	$(call print_success,Production environment configured)
	$(call print_warning,Use with caution - real resources!)

env-show: ## Show current environment
	$(call check_file,.env.local)
	@printf "\n$(BOLD)Current Environment:$(RESET)\n"
	@if grep -q "ENV=local" .env.local 2>/dev/null; then \
		printf "  $(BLUE)$(BOLD)$(ARROW) LOCAL$(RESET)\n"; \
	elif grep -q "ENV=testnet" .env.local 2>/dev/null; then \
		printf "  $(CYAN)$(BOLD)$(ARROW) TESTNET$(RESET)\n"; \
	elif grep -q "ENV=production" .env.local 2>/dev/null; then \
		printf "  $(MAGENTA)$(BOLD)$(ARROW) PRODUCTION$(RESET)\n"; \
	else \
		printf "  $(YELLOW)$(WARN) Unknown$(RESET)\n"; \
	fi
	@printf "\n$(BOLD)API Endpoints:$(RESET)\n"
	@grep "_URL=" .env.local 2>/dev/null | head -5 | sed 's/^/  /' || true
	@printf "\n"

env-validate: ## Validate environment configuration
	$(call check_file,.env.local)
	@# Add your required env var checks here
	@# Example:
	@# if ! grep -q "API_URL=" .env.local; then \
	@#     printf "$(RED)$(CROSS) Missing API_URL$(RESET)\n"; \
	@#     exit 1; \
	@# fi

clean-env: ## Remove .env.local
	$(call print_warning,Removing .env.local)
	@rm -f .env.local
	$(call print_success,Environment file removed)

# ============================================================================
# Cleaning
# ============================================================================
.PHONY: clean clean-deps clean-build clean-all

clean: clean-build ## Clean build artifacts

clean-build: ## Clean build directories
	$(call print_warning,Cleaning build artifacts)
	@rm -rf dist build .next out coverage
	$(call print_success,Build artifacts cleaned)

clean-deps: ## Remove node_modules and lock file
	$(call print_warning,Removing node_modules)
	@rm -rf node_modules package-lock.json
	$(call print_success,Dependencies cleaned)

clean-all: clean-build clean-deps clean-env ## Clean everything
	$(call print_success,All cleaned)

# ============================================================================
# Convenience Targets
# ============================================================================
.PHONY: dev-run-local dev-run-testnet dev-clean

dev-run-local: ## Run against local backend
	@if [ ! -f .env.local ] || ! grep -q "ENV=local" .env.local; then \
		printf "$(YELLOW)$(WARN) Switching to local environment$(RESET)\n"; \
		make --no-print-directory env-local; \
	fi
	@make --no-print-directory dev-run

dev-run-testnet: ## Run against testnet backend
	@if [ ! -f .env.local ] || ! grep -q "ENV=testnet" .env.local; then \
		printf "$(YELLOW)$(WARN) Switching to testnet environment$(RESET)\n"; \
		make --no-print-directory env-testnet; \
	fi
	@make --no-print-directory dev-run

dev-clean: clean-deps dev-install ## Clean and reinstall dependencies

# ============================================================================
# Error Handling (keep at end)
# ============================================================================
%:
	@echo ""
	@echo "$(RED)❌ Unknown target '$@'$(RESET)"
	@echo "   Run $(CYAN)make help$(RESET) to see available targets"
	@echo ""
	@exit 1
