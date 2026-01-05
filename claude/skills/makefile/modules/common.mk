# common.mk - Shell settings, variables, and guard helpers
# Include this in complex projects: include ./makefiles/common.mk

# ============================================================================
# Shell Settings (strict mode)
# ============================================================================
SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# ============================================================================
# Verbose Mode
# Usage: make target VERBOSE=1
# ============================================================================
ifdef VERBOSE
	Q :=
else
	Q := @
endif

# ============================================================================
# Common Variables
# ============================================================================
TIMESTAMP := $(shell date '+%Y-%m-%d %H:%M:%S')
ROOT_DIR  := $(shell pwd)
BUILD_DIR := $(ROOT_DIR)/build
DIST_DIR  := $(ROOT_DIR)/dist
TMP_DIR   := $(ROOT_DIR)/tmp

# Create directories if needed
$(BUILD_DIR) $(DIST_DIR) $(TMP_DIR):
	$(Q)mkdir -p $@

# ============================================================================
# Guard Helpers
# Usage: $(call check_command,docker)
# ============================================================================
define check_command
	@command -v $(1) >/dev/null 2>&1 || { \
		printf "$(RED)Missing required tool: $(1)$(RESET)\n"; \
		exit 1; \
	}
endef

# Check if virtual environment is active
define check_venv
	@if [ -z "$$VIRTUAL_ENV" ]; then \
		printf "$(RED)$(CROSS) Virtual environment not activated!$(RESET)\n"; \
		printf "$(YELLOW)  Tip: Use 'uv run <command>' or manually activate: source .venv/bin/activate$(RESET)\n"; \
		exit 1; \
	fi
endef

# Check required variable is set
# Usage: $(call require,VAR_NAME)
define require
	@if [ -z "$($1)" ]; then \
		printf "$(RED)Missing required variable: $1$(RESET)\n"; \
		exit 1; \
	fi
endef

# ============================================================================
# Utility Targets
# ============================================================================
.PHONY: prompt-confirm
prompt-confirm: ## Prompt for confirmation before continuing
	@printf "$(YELLOW)Continue? [y/N] $(RESET)"; read ans; [ $${ans:-N} = y ]

.PHONY: debug-vars
debug-vars: ## Print debug variables
	$(call print_section,Debug Variables)
	$(Q)printf "ROOT_DIR  = %s\n" "$(ROOT_DIR)"
	$(Q)printf "BUILD_DIR = %s\n" "$(BUILD_DIR)"
	$(Q)printf "DIST_DIR  = %s\n" "$(DIST_DIR)"
	$(Q)printf "TMP_DIR   = %s\n" "$(TMP_DIR)"

# ============================================================================
# Preflight Checks (use as prerequisites)
# Usage: my-target: _check-docker _check-postgres
# ============================================================================

.PHONY: _check-docker
_check-docker: ## Check if Docker is running
	@if ! docker info >/dev/null 2>&1; then \
		printf "$(RED)❌ Error: Docker is not running$(RESET)\n"; \
		printf "$(YELLOW)💡 Please start Docker Desktop and try again$(RESET)\n"; \
		exit 1; \
	fi

.PHONY: _check-postgres
_check-postgres: ## Check if PostgreSQL container is running
	@CONTAINER_NAME="$${POSTGRES_CONTAINER:-postgres}"; \
	if ! docker ps --filter "name=$$CONTAINER_NAME" --filter "status=running" --format "{{.Names}}" | grep -q "$$CONTAINER_NAME"; then \
		printf "$(RED)❌ Error: PostgreSQL container '$$CONTAINER_NAME' is not running$(RESET)\n"; \
		printf "$(YELLOW)💡 Start it with: make db-start$(RESET)\n"; \
		exit 1; \
	fi

# ============================================================================
# Env File Loading Helper
# Usage: $(call run_with_env,uv run python script.py)
# Loads E2E_ENV file if set, preserves CLI overrides
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
