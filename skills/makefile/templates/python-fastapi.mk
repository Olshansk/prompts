# FastAPI Makefile Template (using uv)
# Copy this file to your project root as 'Makefile'
#
# Full-featured template inspired by grove_api2 patterns:
#   - Quickstart guides for developers and users
#   - Database operations with Docker PostgreSQL
#   - E2E testing with env file support
#   - Preflight checks for prerequisites
#
# Prerequisites:
#   - uv installed (https://github.com/astral-sh/uv)
#   - Docker (for PostgreSQL)
#   - pyproject.toml with FastAPI, uvicorn, alembic

.DEFAULT_GOAL := help

# ============================================================================
# Configuration (adjust these for your project)
# ============================================================================
APP_MODULE := app.main:app
HOST := 0.0.0.0
PORT := 8000
POSTGRES_CONTAINER := postgres_dev
DB_NAME := app_dev
DB_USER := postgres

# Docker Compose (supports both old and new syntax)
DOCKER_COMPOSE := $(shell command -v docker-compose 2>/dev/null || echo "docker compose")

# ============================================================================
# Colors & Symbols
# ============================================================================
GREEN   := \033[0;32m
YELLOW  := \033[1;33m
RED     := \033[0;31m
CYAN    := \033[0;36m
MAGENTA := \033[0;35m
BOLD    := \033[1m
DIM     := \033[2m
RESET   := \033[0m

CHECK := ✓
CROSS := ✗
WARN  := ⚠️
INFO  := ℹ️

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
# Env File Loading Helper
# Usage: $(call run_with_env,uv run python script.py)
# ============================================================================
define run_with_env
	@if [ -n "$$E2E_ENV" ]; then \
		printf "$(CYAN)$(INFO) Loading environment from: $$E2E_ENV$(RESET)\n"; \
		if [ ! -f "$$E2E_ENV" ]; then \
			printf "$(RED)❌ Error: E2E_ENV file not found: $$E2E_ENV$(RESET)\n"; \
			exit 1; \
		fi; \
		set -a && . "$$E2E_ENV" && set +a; \
		$(1); \
	else \
		$(1); \
	fi
endef

# E2E test runner with env file
define run_e2e_test
	@( \
		E2E_ENV_FILE=$${E2E_ENV:-$(1)}; \
		if [ ! -f "$$E2E_ENV_FILE" ]; then \
			printf "$(RED)❌ Error: $$E2E_ENV_FILE not found$(RESET)\n\n"; \
			printf "$(YELLOW)To fix:$(RESET)\n"; \
			printf "  1. Copy template: $(CYAN)cp .template.env $$E2E_ENV_FILE$(RESET)\n"; \
			printf "  2. Fill in required values\n\n"; \
			exit 1; \
		fi; \
		export E2E_ENV="$$E2E_ENV_FILE"; \
		set -a && . "$$E2E_ENV_FILE" && set +a; \
		$(2) \
	)
endef

# ============================================================================
# Help (manually organized for better UX)
# ============================================================================
.PHONY: help
help: ## Show all available targets
	@printf "\n$(BOLD)$(CYAN)📋 FastAPI Project$(RESET)\n\n"
	@printf "$(BOLD)=== 🚀 Quick Start ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "quickstart-dev" "Developer setup guide"
	@printf "\n"
	@printf "$(BOLD)=== 🚀 API Operations ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "api-run" "Run API server with auto-reload"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "api-docs" "Open API documentation in browser"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "api-health" "Check API health endpoint"
	@printf "\n"
	@printf "$(BOLD)=== 🗄️  Database ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "db-start" "Start PostgreSQL via Docker"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "db-stop" "Stop PostgreSQL"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "db-migrate" "Run database migrations"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "db-reset" "Reset database (drop + recreate + migrate)"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "db-shell" "Open psql shell"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "db-revision" "Create new migration (MSG=\"description\")"
	@printf "\n"
	@printf "$(BOLD)=== 🧪 Testing ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "test-unit" "Run unit tests"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "test-integration" "Run integration tests (requires db)"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "test-e2e" "Run E2E tests (uses .env)"
	@printf "$(DIM)%-30s$(RESET) Usage: $(CYAN)E2E_ENV=.test.env make test-e2e$(RESET)\n" ""
	@printf "\n"
	@printf "$(BOLD)=== 🛠️  Development ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "dev-check" "Run all checks (ruff + mypy)"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "dev-format" "Auto-fix and format code"
	@printf "\n"
	@printf "$(BOLD)=== 🐍 Environment ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "env-install" "Install dependencies"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "env-sync" "Sync with lock file"
	@printf "\n"
	@printf "$(BOLD)=== 🧹 Cleaning ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "clean" "Clean cache files"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "clean-all" "Clean everything"
	@printf "\n"

# ============================================================================
# Quick Start
# ============================================================================
.PHONY: quickstart-dev
quickstart-dev: ## Interactive developer setup guide
	@printf "\n$(BOLD)$(GREEN)🚀 Developer Quick Start$(RESET)\n\n"
	@printf "$(BOLD)Step 1:$(RESET) Install dependencies\n"
	@printf "   $(CYAN)make env-install$(RESET)\n\n"
	@read -p "   Press Enter when ready..." dummy
	@$(MAKE) env-install
	@printf "\n$(GREEN)✓ Dependencies installed$(RESET)\n\n"
	@printf "$(BOLD)Step 2:$(RESET) Start PostgreSQL\n"
	@printf "   $(CYAN)make db-start$(RESET)\n\n"
	@read -p "   Press Enter when ready..." dummy
	@$(MAKE) db-start
	@printf "\n$(GREEN)✓ Database started$(RESET)\n\n"
	@printf "$(BOLD)Step 3:$(RESET) Run migrations\n"
	@printf "   $(CYAN)make db-migrate$(RESET)\n\n"
	@read -p "   Press Enter when ready..." dummy
	@$(MAKE) db-migrate
	@printf "\n$(GREEN)✓ Migrations applied$(RESET)\n\n"
	@printf "$(BOLD)Step 4:$(RESET) Start the API server\n"
	@printf "   $(CYAN)make api-run$(RESET)\n\n"
	@printf "$(BOLD)$(GREEN)✓ Setup complete!$(RESET)\n"
	@printf "   API docs: $(CYAN)http://localhost:$(PORT)/docs$(RESET)\n\n"

# ============================================================================
# Preflight Checks
# ============================================================================
.PHONY: _check-docker _check-postgres

_check-docker:
	@if ! docker info >/dev/null 2>&1; then \
		printf "$(RED)❌ Docker is not running$(RESET)\n"; \
		printf "$(YELLOW)💡 Please start Docker Desktop$(RESET)\n"; \
		exit 1; \
	fi

_check-postgres:
	@if ! docker ps --filter "name=$(POSTGRES_CONTAINER)" --filter "status=running" --format "{{.Names}}" | grep -q "$(POSTGRES_CONTAINER)"; then \
		printf "$(RED)❌ PostgreSQL container '$(POSTGRES_CONTAINER)' is not running$(RESET)\n"; \
		printf "$(YELLOW)💡 Start it with: make db-start$(RESET)\n"; \
		exit 1; \
	fi

# ============================================================================
# Environment
# ============================================================================
.PHONY: env-install env-sync clean-env

env-install: ## Install dependencies
	$(call print_section,Installing dependencies)
	@command -v uv >/dev/null 2>&1 || { printf "$(RED)Missing: uv$(RESET)\n"; exit 1; }
	uv sync
	$(call print_success,Dependencies installed)

env-sync: ## Sync dependencies with lock file
	$(call print_section,Syncing dependencies)
	uv sync
	$(call print_success,Dependencies synced)

clean-env: ## Remove virtual environment
	$(call print_warning,Removing virtual environment)
	rm -rf .venv venv
	$(call print_success,Virtual environment removed)

# ============================================================================
# API Server
# ============================================================================
.PHONY: api-run api-docs api-health

api-run: ## Run API server with auto-reload
	$(call print_section,Starting API server)
	@printf "\n$(BOLD)$(GREEN)🚀 API Server$(RESET)\n\n"
	@printf "$(BOLD)Endpoints:$(RESET) $(CYAN)http://localhost:$(PORT)$(RESET)\n"
	@printf "$(BOLD)Swagger:$(RESET)   $(CYAN)http://localhost:$(PORT)/docs$(RESET)\n"
	@printf "$(BOLD)ReDoc:$(RESET)     $(CYAN)http://localhost:$(PORT)/redoc$(RESET)\n\n"
	@printf "$(YELLOW)$(INFO) Auto-reload enabled$(RESET)\n"
	@printf "$(DIM)Press Ctrl+C to stop$(RESET)\n\n"
	uv run uvicorn $(APP_MODULE) --host $(HOST) --port $(PORT) --reload

api-docs: ## Open API documentation in browser
	$(call print_info,Opening API docs)
	@if curl -s -f http://localhost:$(PORT)/health > /dev/null 2>&1; then \
		printf "$(GREEN)✓ Server running, opening browser...$(RESET)\n"; \
		if command -v open > /dev/null 2>&1; then \
			open http://localhost:$(PORT)/docs; \
		elif command -v xdg-open > /dev/null 2>&1; then \
			xdg-open http://localhost:$(PORT)/docs; \
		else \
			printf "$(CYAN)Open: http://localhost:$(PORT)/docs$(RESET)\n"; \
		fi; \
	else \
		printf "$(RED)❌ Server not running$(RESET)\n"; \
		printf "$(YELLOW)💡 Start with: make api-run$(RESET)\n"; \
		exit 1; \
	fi

api-health: ## Check API health
	$(call print_info,Checking API health)
	@curl -s http://localhost:$(PORT)/health | python3 -m json.tool

# ============================================================================
# Database
# ============================================================================
.PHONY: db-start db-stop db-migrate db-reset db-shell db-revision

db-start: _check-docker ## Start PostgreSQL via Docker
	$(call print_section,Starting PostgreSQL)
	@if docker ps -a --filter "name=$(POSTGRES_CONTAINER)" --format "{{.Names}}" | grep -q "$(POSTGRES_CONTAINER)"; then \
		if docker ps --filter "name=$(POSTGRES_CONTAINER)" --filter "status=running" --format "{{.Names}}" | grep -q "$(POSTGRES_CONTAINER)"; then \
			printf "$(YELLOW)$(INFO) PostgreSQL already running$(RESET)\n"; \
		else \
			$(DOCKER_COMPOSE) up -d postgres; \
		fi; \
	else \
		$(DOCKER_COMPOSE) up -d postgres; \
	fi
	@echo "Waiting for PostgreSQL..."
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		if docker exec $(POSTGRES_CONTAINER) pg_isready -U $(DB_USER) >/dev/null 2>&1; then \
			printf "$(GREEN)$(BOLD) $(CHECK) PostgreSQL ready$(RESET)\n"; \
			exit 0; \
		fi; \
		sleep 2; \
	done; \
	printf "$(RED)$(CROSS) PostgreSQL failed to start$(RESET)\n"; \
	exit 1

db-stop: ## Stop PostgreSQL
	$(call print_info,Stopping PostgreSQL)
	$(DOCKER_COMPOSE) down

db-migrate: _check-postgres ## Run migrations
	$(call print_info,Running migrations)
	uv run alembic upgrade head
	$(call print_success,Migrations complete)

db-reset: db-start ## Reset database (drop + recreate + migrate)
	$(call print_warning,Resetting database)
	docker exec -i $(POSTGRES_CONTAINER) psql -U $(DB_USER) -d postgres -c "DROP DATABASE IF EXISTS $(DB_NAME);" || true
	docker exec -i $(POSTGRES_CONTAINER) psql -U $(DB_USER) -d postgres -c "CREATE DATABASE $(DB_NAME);"
	$(MAKE) db-migrate
	$(call print_success,Database reset complete)

db-shell: _check-postgres ## Open psql shell
	@if [ -t 0 ]; then \
		docker exec -it $(POSTGRES_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME); \
	else \
		docker exec -i $(POSTGRES_CONTAINER) psql -U $(DB_USER) -d $(DB_NAME); \
	fi

db-revision: ## Create new migration (usage: make db-revision MSG="description")
	uv run alembic revision --autogenerate -m "$(MSG)"

# ============================================================================
# Testing
# ============================================================================
.PHONY: test-unit test-integration test-e2e

test-unit: ## Run unit tests
	$(call print_section,Running unit tests)
	uv run pytest tests/unit/ -v
	$(call print_success,Unit tests passed)

test-integration: _check-postgres ## Run integration tests
	$(call print_section,Running integration tests)
	@printf "$(YELLOW)$(WARN) Requires PostgreSQL$(RESET)\n"
	uv run pytest tests/integration/ -v
	$(call print_success,Integration tests passed)

test-e2e: _check-postgres ## Run E2E tests (override with E2E_ENV=)
	$(call print_section,Running E2E tests)
	@printf "$(YELLOW)$(WARN) This may use real resources$(RESET)\n"
	@printf "$(CYAN)$(INFO) Using: $${E2E_ENV:-.env}$(RESET)\n"
	$(call run_e2e_test,.env,uv run pytest tests/e2e/ -v)
	$(call print_success,E2E tests passed)

# ============================================================================
# Development
# ============================================================================
.PHONY: dev-check dev-format dev-todo

dev-check: ## Run all checks (ruff + mypy)
	$(call print_section,Running checks)
	@printf "$(BOLD)Linting...$(RESET)\n"
	uv run ruff check src/ tests/
	@printf "$(BOLD)Format check...$(RESET)\n"
	uv run ruff format --check src/ tests/
	@printf "$(BOLD)Type checking...$(RESET)\n"
	uv run mypy src/
	$(call print_success,All checks passed)

dev-format: ## Auto-fix and format code
	$(call print_section,Formatting code)
	@printf "$(BOLD)Fixing lint issues...$(RESET)\n"
	uv run ruff check --fix src/ tests/
	@printf "$(BOLD)Formatting...$(RESET)\n"
	uv run ruff format src/ tests/
	$(call print_success,Formatting complete)

dev-todo: ## Find TODO/FIXME comments
	$(call print_section,Searching for TODOs)
	@grep -rn --color=always \
		--exclude-dir={.venv,__pycache__,.pytest_cache,.mypy_cache,.git} \
		--exclude={"*.pyc","uv.lock"} \
		-E "(TODO|FIXME|XXX|HACK):" . || printf "$(GREEN)No TODOs found!$(RESET)\n"

# ============================================================================
# Cleaning
# ============================================================================
.PHONY: clean clean-all

clean: ## Clean cache files
	$(call print_warning,Cleaning cache)
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	$(call print_success,Cleaned)

clean-all: clean clean-env ## Clean everything
	$(call print_success,All cleanup complete)

# ============================================================================
# Error Handling (keep at end)
# ============================================================================
# Silently ignore arguments that look like values (numbers, addresses, domains)
%:
	@TARGET="$@"; \
	if echo "$$TARGET" | grep -qE '^([0-9]+\.?[0-9]*|[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$$'; then \
		: ; \
	else \
		printf "\n$(RED)❌ Unknown target '$$TARGET'$(RESET)\n"; \
		printf "   Run $(CYAN)make help$(RESET) to see available targets\n\n"; \
		exit 1; \
	fi
