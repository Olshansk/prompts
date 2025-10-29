# Modular Makefile System <!-- omit in toc -->

## Purpose <!-- omit in toc -->

You (the assistant) will **create or update Makefiles** using a consistent, modular structure with pretty output, self-documenting targets, and domain-prefixed naming conventions.

This approach is based on successful patterns from real projects like the RSS feed generator where we organized ~30 targets across 6 modules with categorized help output.

- [Makefile Baseline Structure](#makefile-baseline-structure)
- [Makefile Targets Baseline Rules](#makefile-targets-baseline-rules)
- [Domain Prefix Convention](#domain-prefix-convention)
- [Legacy Compatibility Pattern](#legacy-compatibility-pattern)
- [Templates](#templates)
  - [`Makefile` Root Template](#makefile-root-template)
  - [`Makefile` Root with Categorized Help (RSS Feeds Example)](#makefile-root-with-categorized-help-rss-feeds-example)
  - [`makefiles/colors.mk` Template](#makefilescolorsmk-template)
  - [`makefiles/common.mk` Template](#makefilescommonmk-template)
  - [Domain Module Examples](#domain-module-examples)
    - [`makefiles/env.mk` (Python Environment Management)](#makefilesenvmk-python-environment-management)
    - [`makefiles/feeds.mk` (RSS Feed Generation)](#makefilesfeedsmk-rss-feed-generation)
    - [`makefiles/dev.mk` (Development Tools)](#makefilesdevmk-development-tools)
    - [`makefiles/ci.mk` (CI/CD Integration)](#makefilescimk-cicd-integration)

## Makefile Baseline Structure

Create the following modular structure:

- `Makefile` at repo root (minimal: help + includes + legacy aliases)
- `makefiles/` folder with:
  - `colors.mk` (ANSI colors + print helpers)
  - `common.mk` (shell flags, variables, guard/check helpers)
  - Domain-specific modules as separate `*.mk` files based on project needs:
    - `env.mk` (environment setup for Python/Node/Go/etc)
    - `feeds.mk` (domain-specific operations like RSS generation)
    - `dev.mk` (development tools: formatting, linting, testing)
    - `ci.mk` (CI/CD workflows and automation)
    - `docker.mk` (containerization if needed)
    - `build.mk` (compilation if needed)

## Makefile Targets Baseline Rules

- **Naming Convention**: Use domain prefixes (`env_*`, `feeds_*`, `dev_*`, `ci_*`, `clean_*`)
- **Legacy Support**: Create backward-compatible aliases for existing targets
- **Help Organization**: Group targets by domain with emojis and sections
- **Color Output**: Use `printf` over `echo` for color safety; always include `\n`
- **Documentation**: Public targets must include `## description` for help
- **Modularity**: Keep root `Makefile` minimal; domain logic in `makefiles/*.mk`
- **Silent Mode**: Use `$(Q)` prefix for quiet execution (controlled by VERBOSE)

## Domain Prefix Convention

Establish consistent naming patterns based on functionality:

```makefile
# Environment: env_*
env_create        # Create virtual environment
env_install       # Install dependencies
env_source        # Source activation command

# Domain Operations: <domain>_*
feeds_generate_all     # Generate all RSS feeds
feeds_anthropic_news   # Generate specific feed

# Development: dev_*
dev_format        # Format code
dev_lint          # Run linters
dev_test          # Run tests

# CI/CD: ci_*
ci_test_workflow_local    # Test CI locally
ci_trigger_workflow       # Trigger remote CI

# Cleaning: clean_*
clean_env         # Clean environment
clean_feeds       # Clean generated files
clean_all         # Clean everything
```

## Legacy Compatibility Pattern

When refactoring existing Makefiles, maintain backward compatibility:

```makefile
############################
### Legacy Target Aliases ##
############################

# Maintain backwards compatibility with existing targets

.PHONY: uvx_install
uvx_install: env_install ## (Legacy) Install dependencies

.PHONY: py_format
py_format: dev_format ## (Legacy) Format Python code

.PHONY: generate_all_feeds
generate_all_feeds: feeds_generate_all ## (Legacy) Generate all RSS feeds
```

## Templates

### `Makefile` Root Template

```makefile
#########################
### Makefile (root)   ###
#########################

.DEFAULT_GOAL := help

# Patterns for classified help categories
HELP_PATTERNS := \
	'^help:' \
	'^env_.*:' \
	'^feeds_.*:' \  # Replace with your domain
	'^dev_.*:' \
	'^ci_.*:' \
	'^clean_.*:' \
	'^debug_vars:'

.PHONY: help
help: ## Show all available targets with descriptions
	@printf "\n"
	@printf "$(BOLD)$(CYAN)📋 Project Makefile Targets$(RESET)\n"
	@printf "\n"
	@printf "$(YELLOW)Usage:$(RESET) make <target>\n\n"
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-30s$(RESET) %s\n", $$1, $$2}'

.PHONY: help-unclassified
help-unclassified: ## Show all unclassified targets
	# Implementation as shown in full template below

################
### Imports  ###
################

include ./makefiles/colors.mk
include ./makefiles/common.mk
include ./makefiles/env.mk      # Environment setup
include ./makefiles/feeds.mk    # Domain-specific (adjust per project)
include ./makefiles/dev.mk      # Development tools
include ./makefiles/ci.mk       # CI/CD integration

# Add legacy aliases section if refactoring existing Makefile

###############################
###  Global Error Handling  ###
###############################

# Catch-all for undefined targets - MUST be at END after all includes
%:
	@echo ""
	@echo "$(RED)❌ Error: Unknown target '$(BOLD)$@$(RESET)$(RED)'$(RESET)"
	@echo ""
	@echo "$(YELLOW)💡 Available targets:$(RESET)"
	@echo "   Run $(CYAN)make help$(RESET) to see all available targets"
	@echo ""
	@exit 1
```

### `Makefile` Root with Categorized Help (RSS Feeds Example)

This real-world example from the RSS feeds project shows categorized help with emojis:

```makefile
#########################
### Makefile (root)   ###
#########################

.DEFAULT_GOAL := help

# Patterns for classified help categories
HELP_PATTERNS := \
	'^help:' \
	'^env_.*:' \
	'^feeds_.*:' \
	'^dev_.*:' \
	'^ci_.*:' \
	'^clean_.*:' \
	'^debug_vars:'

.PHONY: help
help: ## Show all available targets with descriptions
	@printf "\n"
	@printf "$(BOLD)$(CYAN)📋 RSS Feed Generator - Makefile Targets$(RESET)\n"
	@printf "\n"
	@printf "$(BOLD)=== 📋 Information & Discovery ===$(RESET)\n"
	@grep -h -E '^(help|help-unclassified):.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@printf "\n"
	@printf "$(BOLD)=== 🐍 Environment Setup ===$(RESET)\n"
	@grep -h -E '^env_.*:.*?## .*$$' $(MAKEFILE_LIST) ./makefiles/*.mk 2>/dev/null | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}' | sort -u
	@printf "\n"
	@printf "$(BOLD)=== 📡 RSS Feed Generation ===$(RESET)\n"
	@grep -h -E '^feeds_.*:.*?## .*$$' $(MAKEFILE_LIST) ./makefiles/*.mk 2>/dev/null | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}' | sort -u
	@printf "\n"
	@printf "$(BOLD)=== 🛠️ Development ===$(RESET)\n"
	@grep -h -E '^dev_.*:.*?## .*$$' $(MAKEFILE_LIST) ./makefiles/*.mk 2>/dev/null | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}' | sort -u
	@printf "\n"
	@printf "$(BOLD)=== 🚀 CI/CD ===$(RESET)\n"
	@grep -h -E '^ci_.*:.*?## .*$$' $(MAKEFILE_LIST) ./makefiles/*.mk 2>/dev/null | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}' | sort -u
	@printf "\n"
	@printf "$(BOLD)=== 🧹 Cleaning ===$(RESET)\n"
	@grep -h -E '^clean_.*:.*?## .*$$' $(MAKEFILE_LIST) ./makefiles/*.mk 2>/dev/null | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}' | sort -u
	@printf "\n"
	@printf "$(YELLOW)Usage:$(RESET) make <target>\n"
	@printf "\n"

.PHONY: help-unclassified
help-unclassified: ## Show all unclassified targets
	@printf "\n"
	@printf "$(BOLD)$(CYAN)📦 Unclassified Targets$(RESET)\n"
	@printf "\n"
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) ./makefiles/*.mk 2>/dev/null | sed 's/:.*//g' | sort -u > /tmp/all_targets.txt
	@( \
		for pattern in $(HELP_PATTERNS); do \
			grep -h -E "$pattern.*?## .*\$$" $(MAKEFILE_LIST) ./makefiles/*.mk 2>/dev/null || true; \
		done \
	) | sed 's/:.*//g' | sort -u > /tmp/classified_targets.txt
	@comm -23 /tmp/all_targets.txt /tmp/classified_targets.txt | while read target; do \
		grep -h -E "^$$target:.*?## .*\$$" $(MAKEFILE_LIST) ./makefiles/*.mk 2>/dev/null | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'; \
	done
	@rm -f /tmp/all_targets.txt /tmp/classified_targets.txt
	@printf "\n"

################
### Imports  ###
################

include ./makefiles/colors.mk
include ./makefiles/common.mk
include ./makefiles/env.mk
include ./makefiles/feeds.mk
include ./makefiles/dev.mk
include ./makefiles/ci.mk

############################
### Legacy Target Aliases ##
############################

# Maintain backwards compatibility with existing targets

.PHONY: uvx_install
uvx_install: env_install ## (Legacy) Install dependencies

.PHONY: py_format
py_format: dev_format ## (Legacy) Format Python code

.PHONY: generate_all_feeds
generate_all_feeds: feeds_generate_all ## (Legacy) Generate all RSS feeds

# ... additional legacy aliases as needed

###############################
###  Global Error Handling  ###
###############################

# Catch-all for undefined targets - MUST be at END after all includes
%:
	@echo ""
	@echo "$(RED)❌ Error: Unknown target '$(BOLD)$@$(RESET)$(RED)'$(RESET)"
	@echo ""
	@echo "$(YELLOW)💡 Available targets:$(RESET)"
	@echo "   Run $(CYAN)make help$(RESET) to see all available targets"
	@echo ""
	@exit 1
```

### `makefiles/colors.mk` Template

```makefile
# Basic ANSI colors & print helpers

GREEN := \033[0;32m
YELLOW := \033[1;33m
BLUE := \033[0;34m
CYAN := \033[0;36m
RED := \033[0;31m
MAGENTA := \033[0;35m
BOLD := \033[1m
DIM := \033[2m
RESET := \033[0m

CHECK := ✓
CROSS := ✗
WARN := ⚠️
INFO := ℹ️
ARROW := →

define print_success
	@printf "$(GREEN)$(BOLD) $(CHECK) %s$(RESET)\n" "$(1)"
endef

define print_error
	@printf "$(RED)$(BOLD) $(CROSS) %s$(RESET)\n" "$(1)"
endef

define print_warning
	@printf "$(YELLOW)$(WARN) %s$(RESET)\n" "$(1)"
endef

define print_info
	@printf "$(CYAN)$(INFO) %s$(RESET)\n" "$(1)"
endef

define print_info_section
	@printf "\n$(CYAN)$(BOLD)%s$(RESET)\n" "$(1)"
endef
```

### `makefiles/common.mk` Template

```makefile
# Strict shell + sane make defaults

SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# VERBOSE=1 to show commands

ifdef VERBOSE
	Q :=
else
	Q := @
endif

# Timestamp & common dirs

TIMESTAMP := $(shell date '+%Y-%m-%d %H:%M:%S')
ROOT_DIR := $(shell pwd)
BUILD_DIR := $(ROOT_DIR)/build
DIST_DIR := $(ROOT_DIR)/dist
DOCS_DIR := $(ROOT_DIR)/docs
TMP_DIR := $(ROOT_DIR)/tmp

$(BUILD_DIR) $(DIST_DIR) $(TMP_DIR):
	$(Q)mkdir -p $@

# Guards & checks

define check_command
	@command -v $(1) >/dev/null 2>&1 || { \
		printf "$(RED)Missing tool: $(1)$(RESET)\n"; \
		exit 1; \
	}
endef

define check_venv
	@if [ -z "$$VIRTUAL_ENV" ]; then \
		printf "$(RED)$(CROSS) Virtual environment not activated!$(RESET)\n"; \
		printf "$(YELLOW)  Run: $$(make env_source)$(RESET)\n"; \
		exit 1; \
	fi
endef

define require-%
	@if [ -z "$($*)" ]; then \
		printf "$(RED)Missing required variable: $*$(RESET)\n"; \
		exit 1; \
	fi
endef

.PHONY: prompt_confirm
prompt_confirm: ## Prompt before continuing
	@printf "$(YELLOW)Continue? [y/N] $(RESET)"; read ans; [ $${ans:-N} = y ]

.PHONY: debug_vars
debug_vars: ## Print key vars
	$(call print_info_section,Debug variables)
	$(Q)printf "ROOT_DIR=%s\nBUILD_DIR=%s\nDIST_DIR=%s\nTMP_DIR=%s\n" "$(ROOT_DIR)" "$(BUILD_DIR)" "$(DIST_DIR)" "$(TMP_DIR)"
```

## Domain Module Examples

### `makefiles/env.mk` (Python Environment Management)

Real example from RSS feeds project using `uv`:

```makefile
##########################
### Environment Setup  ###
##########################

.PHONY: env_create
env_create: ## Create the virtual environment
	$(call print_info_section,Creating virtual environment)
	$(Q)uv venv
	$(call print_success,Virtual environment created at .venv)

.PHONY: env_source
env_source: ## Source the env; must be executed like: $$(make env_source)
	@echo 'source .venv/bin/activate'

.PHONY: env_install
env_install: ## Install dependencies using uv
	$(call print_info_section,Installing dependencies)
	$(Q)uv venv
	$(Q)uv pip install -r requirements.txt
	$(call print_success,Dependencies installed)

.PHONY: clean_env
clean_env: ## Clean virtual environment
	$(call print_warning,Removing virtual environment)
	$(Q)rm -rf venv .venv
	$(call print_success,Virtual environment removed)
```

### `makefiles/feeds.mk` (RSS Feed Generation)

Domain-specific module example:

```makefile
##########################
### RSS Feed Generation ##
##########################

.PHONY: feeds_generate_all
feeds_generate_all: ## Generate all RSS feeds
	$(call check_venv)
	$(call print_info_section,Generating all RSS feeds)
	$(Q)python feed_generators/run_all_feeds.py
	$(call print_success,All feeds generated)

.PHONY: feeds_anthropic_news
feeds_anthropic_news: ## Generate RSS feed for Anthropic News
	$(call check_venv)
	$(call print_info,Generating Anthropic News feed)
	$(Q)python feed_generators/anthropic_news_blog.py
	$(call print_success,Anthropic News feed generated)

# Additional feed targets...

.PHONY: clean_feeds
clean_feeds: ## Clean generated RSS feed files
	$(call print_warning,Removing generated RSS feeds)
	$(Q)rm -rf feeds/*.xml
	$(call print_success,RSS feeds removed)
```

### `makefiles/dev.mk` (Development Tools)

```makefile
####################
### Development  ###
####################

.PHONY: dev_format
dev_format: ## Format Python code with black and isort
	$(call check_venv)
	$(call print_info_section,Formatting Python code)
	$(Q)black .
	$(Q)isort .
	$(call print_success,Code formatted)

.PHONY: dev_lint
dev_lint: ## Run linting checks
	$(call check_venv)
	$(call print_info_section,Running linters)
	$(Q)flake8 . --extend-ignore=E203
	$(Q)mypy . --ignore-missing-imports
	$(call print_success,Linting complete)

.PHONY: dev_test_feed
dev_test_feed: ## Run test feed generator
	$(call check_venv)
	$(call print_info,Running test feed generator)
	$(Q)python feed_generators/test_feed_generator.py
	$(call print_success,Test feed generated)
```

### `makefiles/ci.mk` (CI/CD Integration)

```makefile
################
### CI/CD    ###
################

.PHONY: ci_test_workflow_local
ci_test_workflow_local: ## Test CI workflow locally using act
	$(call check_command,act)
	$(call print_info_section,Testing workflow locally)
	$(Q)act -W .github/workflows/run_feeds.yml

.PHONY: ci_run_feeds_workflow_local
ci_run_feeds_workflow_local: ## Run feeds workflow locally
	$(call check_command,act)
	$(call print_info_section,Running feeds workflow locally)
	$(Q)act -j generate-feeds -W .github/workflows/run_feeds.yml

.PHONY: ci_trigger_feeds_workflow
ci_trigger_feeds_workflow: ## Trigger feeds workflow on GitHub
	$(call check_command,gh)
	$(call print_info_section,Triggering workflow on GitHub)
	$(Q)gh workflow run run_feeds.yml
	$(call print_success,Workflow triggered)
```

## Global Error Handling Pattern

When working with Makefiles that have subdirectories or multiple included modules, add a catch-all error handler to provide helpful feedback for undefined targets.

### Implementation

Add this section at the **END** of your root `Makefile` (after all includes):

```makefile
###############################
###  Global Error Handling  ###
###############################

# Catch-all rule for undefined targets
# This must be defined AFTER includes so color variables are available
# and it acts as a fallback for any undefined target
%:
	@echo ""
	@echo "$(RED)❌ Error: Unknown target '$(BOLD)$@$(RESET)$(RED)'$(RESET)"
	@echo ""
	@if echo "$@" | grep -q "^postgrest"; then \
		echo "$(YELLOW)💡 Hint: Portal DB targets should be run from the portal-db directory:$(RESET)"; \
		echo "   $(CYAN)cd ./portal-db && make $@$(RESET)"; \
		echo "   Or see: $(CYAN)make portal_db_help$(RESET)"; \
	else \
		echo "$(YELLOW)💡 Available targets:$(RESET)"; \
		echo "   Run $(CYAN)make help$(RESET) to see all available targets"; \
		echo "   Run $(CYAN)make help-unclassified$(RESET) to see unclassified targets"; \
	fi
	@echo ""
	@exit 1
```

### Key Principles

1. **Placement**: Must be at the END of the Makefile (after includes) so color variables are available
2. **Pattern Matching**: Use `grep -q` to detect specific target patterns and provide context-specific hints
3. **Non-Zero Exit**: Always `exit 1` to ensure CI/CD failures are properly detected
4. **Helpful Messages**: Guide users to the correct directory or command instead of silent failure
5. **Color Formatting**: Use color variables from `colors.mk` for clear visual feedback

### Common Use Cases

Detect subdirectory targets:
```makefile
@if echo "$@" | grep -q "^portal"; then \
    echo "$(YELLOW)💡 Hint: Portal targets should be run from portal/ directory$(RESET)"; \
    echo "   $(CYAN)cd ./portal && make $@$(RESET)"; \
```

Detect service-specific targets:
```makefile
@if echo "$@" | grep -q "^docker"; then \
    echo "$(YELLOW)💡 Hint: Docker targets require Docker to be running$(RESET)"; \
    echo "   $(CYAN)docker ps$(RESET) to verify Docker is running"; \
```

Detect language-specific targets:
```makefile
@if echo "$@" | grep -q "^python"; then \
    echo "$(YELLOW)💡 Hint: Python targets require virtual environment$(RESET)"; \
    echo "   Run: $(CYAN)make env_source$(RESET) first"; \
```

### Why This Matters

Without this pattern, Make silently exits with code 0 when encountering undefined targets, which:
- Causes CI/CD pipelines to pass incorrectly
- Confuses users who don't realize the command failed
- Makes debugging difficult without clear error messages
- Wastes time when subdirectory targets are called from the wrong location

With this pattern:
- Clear error messages guide users to the correct action
- Non-zero exit codes ensure CI/CD failures are caught
- Context-specific hints reduce confusion
- Pattern matching provides intelligent suggestions

## Best Practices Summary

1. **Start with Structure**: Create `makefiles/` directory with `colors.mk` and `common.mk` first
2. **Use Domain Prefixes**: Organize targets with consistent prefixes (`env_*`, `dev_*`, `ci_*`)
3. **Maintain Compatibility**: Add legacy aliases when refactoring existing Makefiles
4. **Categorize Help**: Group targets in help output with emojis and sections
5. **Keep Root Minimal**: Only help, imports, and legacy aliases in root `Makefile`
6. **Use Print Helpers**: Leverage `print_*` functions for consistent, colorful output
7. **Silent by Default**: Use `$(Q)` prefix, controlled by VERBOSE variable
8. **Check Prerequisites**: Use `check_venv`, `check_command`, etc. for safety
9. **Add Error Handler**: Always include the catch-all `%:` rule at the END for undefined targets

## Example Usage

When creating a new Makefile system for a project:

```bash
# User request
"Create a modular Makefile for my Python RSS feed generator project"

# Assistant creates:
# 1. Root Makefile with categorized help
# 2. makefiles/colors.mk for output formatting
# 3. makefiles/common.mk for utilities
# 4. makefiles/env.mk for Python environment
# 5. makefiles/feeds.mk for RSS generation
# 6. makefiles/dev.mk for development tools
# 7. makefiles/ci.mk for CI/CD integration

# Result: Clean, organized, discoverable commands
$ make help
📋 RSS Feed Generator - Makefile Targets

=== 🐍 Environment Setup ===
env_create                              Create the virtual environment
env_install                             Install dependencies using uv
env_source                              Source the env; must be executed like: $$(make env_source)

=== 📡 RSS Feed Generation ===
feeds_generate_all                      Generate all RSS feeds
feeds_anthropic_news                    Generate RSS feed for Anthropic News
...
```