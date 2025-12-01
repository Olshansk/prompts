# Simple Makefile Helper <!-- omit in toc -->

## Purpose

Create or improve Makefiles with minimal complexity. Start simple, only add structure when needed.

- [Purpose](#purpose)
- [When to Use This](#when-to-use-this)
- [Core Principles](#core-principles)
- [Default Structure](#default-structure)
- [Categorized Help Pattern (10+ targets)](#categorized-help-pattern-10-targets)
- [Common Patterns](#common-patterns)
	- [Running a server](#running-a-server)
	- [Installing dependencies](#installing-dependencies)
	- [Running tests](#running-tests)
	- [Code formatting](#code-formatting)
	- [Cleaning](#cleaning)
	- [Environment Management Pattern](#environment-management-pattern)
- [Naming Convention Best Practices](#naming-convention-best-practices)
- [When to Modularize (10+ targets OR 3+ groups)](#when-to-modularize-10-targets-or-3-groups)
- [Improving Existing Makefiles Workflow](#improving-existing-makefiles-workflow)
	- [1. Read and Understand First](#1-read-and-understand-first)
	- [2. Analyze Current Patterns](#2-analyze-current-patterns)
	- [3. Search Before Renaming](#3-search-before-renaming)
	- [4. Propose Targeted Changes](#4-propose-targeted-changes)
	- [5. Test Changes](#5-test-changes)
	- [6. Update Documentation](#6-update-documentation)
- [Common Refactoring Patterns](#common-refactoring-patterns)
	- [Renaming targets for consistency](#renaming-targets-for-consistency)
	- [Reordering help sections](#reordering-help-sections)
	- [Consolidating complex targets](#consolidating-complex-targets)
	- [Splitting complex targets](#splitting-complex-targets)
- [Example Scenarios](#example-scenarios)
	- [Scenario 1: New Python Project](#scenario-1-new-python-project)
	- [Scenario 2: Add Database Target](#scenario-2-add-database-target)
	- [Scenario 3: Improve Existing Makefile](#scenario-3-improve-existing-makefile)
	- [Scenario 4: Add Environment Management](#scenario-4-add-environment-management)
- [What NOT to Do](#what-not-to-do)
- [What TO Do](#what-to-do)
- [Interaction Pattern](#interaction-pattern)
- [Quick Reference](#quick-reference)

## When to Use This

- Creating a new Makefile for a project
- Adding specific targets to an existing Makefile
- Improving an existing Makefile (only when explicitly asked)
- Refactoring existing Makefiles to follow better patterns

## Core Principles

1. **Start flat** - Single Makefile until 10+ targets OR 3+ logical groups
2. **Follow existing conventions** - Match the project's style
3. **Keep colors minimal** - Success/error/warning only
4. **Categorize when helpful** - Use sections for 10+ targets or clear groups
5. **Use consistent naming** - Prefix-based grouping (env-_, dev-_, db-\*)
6. **Don't over-engineer** - Solve the immediate need

## Default Structure

For new projects, create a single flat `Makefile`:

```makefile
.DEFAULT_GOAL := help

# Colors for essential feedback only
GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
CYAN   := \033[0;36m
BOLD   := \033[1m
RESET  := \033[0m

.PHONY: help
help: ## Show available commands
	@printf "\n$(BOLD)$(CYAN)Available Commands$(RESET)\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-20s$(RESET) %s\n", $$1, $$2}'
	@printf "\n"

# Your targets here...
```

## Categorized Help Pattern (10+ targets)

When you have 10+ targets or 3+ logical groups, organize help output:

```makefile
.PHONY: help
help: ## Show all available targets with descriptions
	@printf "\n$(BOLD)$(CYAN)📋 Project - Makefile Targets$(RESET)\n\n"

	@printf "$(BOLD)=== 🚀 Quick Start ===$(RESET)\n"
	@printf "$(CYAN)%-35s$(RESET) %s\n" "setup" "First-time setup"
	@printf "$(CYAN)%-35s$(RESET) %s\n" "run" "Run the app"
	@printf "\n"

	@printf "$(BOLD)=== 💻 Development ===$(RESET)\n"
	@printf "$(CYAN)%-35s$(RESET) %s\n" "dev-run" "Run development server"
	@printf "$(CYAN)%-35s$(RESET) %s\n" "dev-build" "Build for production"
	@printf "\n"

	@printf "$(BOLD)=== 🌍 Environment ===$(RESET)\n"
	@printf "$(CYAN)%-35s$(RESET) %s\n" "env-local" "Setup local environment"
	@printf "$(CYAN)%-35s$(RESET) %s\n" "env-testnet" "Setup testnet environment"
	@printf "\n"
```

**When to categorize:**

- 10+ total targets
- 3+ logical groups (even with fewer targets)
- Most-used commands should appear first

## Common Patterns

### Running a server

```makefile
.PHONY: run
run: ## Start the server
	@printf "$(CYAN)Starting server...$(RESET)\n"
	python app.py
```

### Installing dependencies

```makefile
.PHONY: install
install: ## Install dependencies
	@printf "$(CYAN)Installing dependencies...$(RESET)\n"
	pip install -r requirements.txt
	@printf "$(GREEN)✓ Dependencies installed$(RESET)\n"
```

### Running tests

```makefile
.PHONY: test
test: ## Run tests
	@printf "$(CYAN)Running tests...$(RESET)\n"
	pytest tests/
```

### Code formatting

```makefile
.PHONY: format
format: ## Format code
	@printf "$(CYAN)Formatting code...$(RESET)\n"
	black .
	@printf "$(GREEN)✓ Code formatted$(RESET)\n"
```

### Cleaning

```makefile
.PHONY: clean
clean: ## Clean generated files
	@printf "$(YELLOW)Cleaning...$(RESET)\n"
	rm -rf __pycache__ *.pyc
	@printf "$(GREEN)✓ Cleaned$(RESET)\n"
```

### Environment Management Pattern

Common pattern for switching between environments:

```makefile
# Environment switching targets
.PHONY: env-local env-testnet env-prod

env-local: ## Setup local environment
	@printf "$(CYAN)Setting up local environment...$(RESET)\n"
	cp .env.local.example .env.local
	@printf "$(GREEN)✓ Local environment configured$(RESET)\n"

env-testnet: ## Setup testnet environment (default)
	@printf "$(CYAN)Setting up testnet environment...$(RESET)\n"
	cp .env.testnet.example .env.local
	@printf "$(GREEN)✓ Testnet environment configured$(RESET)\n"

env-prod: ## Setup production environment
	@printf "$(CYAN)Setting up production environment...$(RESET)\n"
	cp .env.production.example .env.local
	@printf "$(YELLOW)⚠️  Production environment - use with caution$(RESET)\n"

env-show: ## Show current environment
	@[ -f .env.local ] && grep "ENV=" .env.local || echo "No environment configured"
```

## Naming Convention Best Practices

Use consistent prefixes to create natural grouping and discoverability:

**Good patterns:**

- `env-local`, `env-testnet`, `env-prod` (consistent env- prefix)
- `dev-run`, `dev-build`, `dev-clean` (consistent dev- prefix)
- `db-start`, `db-stop`, `db-migrate` (consistent db- prefix)
- `test-unit`, `test-integration`, `test-e2e` (consistent test- prefix)

**Bad patterns:**

- `run-dev`, `build`, `clean-reinstall-dev` (inconsistent)
- `localEnv`, `test_net`, `prod-env` (mixed naming styles)
- `start`, `stop`, `run` (ambiguous without context)

**Benefits of prefix grouping:**

- Easy tab completion (type `make dev-<TAB>`)
- Visual grouping in help output
- Clear purpose from the name alone
- Reduces naming conflicts

## When to Modularize (10+ targets OR 3+ groups)

If the Makefile grows beyond 10 targets or has 3+ distinct groups, consider splitting:

```
Makefile           # Main file with help + includes
makefiles/
  colors.mk       # Color definitions
  common.mk       # Shared utilities
  env.mk          # Environment management (env-*)
  dev.mk          # Development commands (dev-*)
  db.mk           # Database operations (db-*)
```

**Only create modules that are actually needed.** Don't create empty files.

**Real example:** grove-app has ~12 targets split into 4 modules:

- `colors.mk` - ANSI color codes
- `common.mk` - Helper functions
- `env.mk` - Environment switching (env-local, env-testnet, env-prod)
- `dev.mk` - Development commands (dev-run, dev-build, dev-clean)

## Improving Existing Makefiles Workflow

When asked to improve an existing Makefile, follow this workflow:

### 1. Read and Understand First

```bash
# Always start by reading the existing Makefile
cat Makefile

# Check for modular makefiles
ls makefiles/*.mk 2>/dev/null

# Understand the project structure
ls -la
```

### 2. Analyze Current Patterns

- What naming conventions are used?
- How is help formatted?
- What's the complexity level?
- Are there pain points or redundancies?

### 3. Search Before Renaming

```bash
# Find all references before renaming targets
rg "make dev-clean-reinstall" --type md
rg "dev-clean-reinstall" Makefile* makefiles/

# Check documentation
rg "dev-clean-reinstall" README.md docs/
```

### 4. Propose Targeted Changes

- Never rewrite everything from scratch
- Maintain backward compatibility when possible
- Update one aspect at a time

### 5. Test Changes

```bash
# Verify help output
make help

# Test with dry-run
make -n dev-clean

# Check that targets work
make dev-clean
```

### 6. Update Documentation

- Update README.md with new target names
- Update any CI/CD configs
- Update developer documentation

## Common Refactoring Patterns

### Renaming targets for consistency

**Before:** `dev-clean-reinstall`, `build`, `run-dev`
**After:** `dev-clean`, `dev-build`, `dev-run`

**Process:**

1. Search for all references: `rg "dev-clean-reinstall"`
2. Update Makefile target name
3. Update documentation
4. Consider alias for backward compatibility

### Reordering help sections

**Principle:** Most-used commands should appear first

**Example order:**

1. Quick Start (setup, run, status)
2. Development (dev-run, dev-build, dev-test)
3. Environment Switching (env-local, env-testnet, env-prod)
4. Maintenance (clean, update, migrate)

### Consolidating complex targets

**Before:** `dev-clean-reinstall-deps-and-cache`
**After:** `dev-clean` (does all cleanup tasks)

**Benefit:** Simpler to remember and type

### Splitting complex targets

**When a target does too much:**

```makefile
# Before - doing too much
deploy: test build push restart-servers update-dns notify-team

# After - split into logical steps
deploy: test build push
	@printf "$(GREEN)Ready to deploy. Run 'make deploy-live' to continue$(RESET)\n"

deploy-live: restart-servers update-dns notify-team
	@printf "$(GREEN)✓ Deployment complete$(RESET)\n"
```

## Example Scenarios

### Scenario 1: New Python Project

**User:** "Create a Makefile for my Python project"

**Response:** Create single Makefile with:

- `help` - Show commands
- `install` - pip install -r requirements.txt
- `test` - Run pytest
- `format` - Run black/isort
- `run` - Start the app
- `clean` - Remove **pycache**

### Scenario 2: Add Database Target

**User:** "Add a target to start my PostgreSQL database"

**Response:** Add to existing Makefile:

```makefile
.PHONY: db-start
db-start: ## Start PostgreSQL database
	@printf "$(CYAN)Starting database...$(RESET)\n"
	docker compose up -d postgres
	@printf "$(GREEN)✓ Database started$(RESET)\n"
```

### Scenario 3: Improve Existing Makefile

**User:** "Can you clean up my Makefile?"

**Response:**

1. Read existing Makefile first
2. Ask what specifically needs improvement
3. Make targeted changes (don't rewrite everything)
4. Keep existing target names unless problematic
5. Add help system if missing
6. Suggest categorization if 10+ targets

### Scenario 4: Add Environment Management

**User:** "I need to switch between local and production configs"

**Response:** Add environment pattern:

```makefile
.PHONY: env-local env-prod env-show

env-local: ## Use local development config
	cp config/local.env .env
	@printf "$(GREEN)✓ Using local environment$(RESET)\n"

env-prod: ## Use production config (careful!)
	cp config/prod.env .env
	@printf "$(YELLOW)⚠️  Using production environment$(RESET)\n"

env-show: ## Show current environment
	@grep "ENV_NAME" .env 2>/dev/null || echo "No environment set"
```

## What NOT to Do

❌ Don't create modular structure for <10 targets (unless 3+ clear groups)
❌ Don't add complex categorized help for <10 targets
❌ Don't create empty module files "for future use"
❌ Don't add decorative emojis everywhere
❌ Don't change existing target names without checking references
❌ Don't create templates unless specifically requested
❌ Don't add features the user didn't ask for
❌ Don't use inconsistent naming (mix of styles/prefixes)
❌ Don't rewrite entire Makefiles from scratch

## What TO Do

✓ Start with the simplest solution that works
✓ Read existing Makefile before suggesting changes
✓ Ask clarifying questions if unsure
✓ Match existing project conventions
✓ Add only what's needed now
✓ Keep output clean and minimal
✓ Make help output scannable with categories when appropriate
✓ Use colors only for status (success/error/warning)
✓ Use consistent prefix-based naming (env-_, dev-_, db-\*)
✓ Search codebase before renaming targets
✓ Test changes with `make -n` and `make help`
✓ Update documentation after Makefile changes

## Interaction Pattern

1. **Understand the need:** What specific problem are we solving?
2. **Check existing code:** Is there already a Makefile? Read it first!
3. **Analyze patterns:** What conventions are already in use?
4. **Start simple:** Propose the minimal solution
5. **Search before changing:** Find all references to targets
6. **Test thoroughly:** Verify help output and dry-run targets
7. **Update docs:** Keep README and other docs in sync
8. **Iterate if needed:** Only add complexity when requested

## Quick Reference

**New project with <10 commands:**

- Single flat Makefile
- Basic help system
- Common targets (install, test, run, clean)
- Use prefix groups if logical (dev-_, test-_)

**Existing project - adding targets:**

- Read existing Makefile first
- Follow existing patterns
- Keep same naming style
- Use consistent prefixes
- Don't reorganize unless asked

**Growing project (10+ targets OR 3+ groups):**

- Suggest categorized help
- Consider modularization
- Keep modules focused (colors, common, domain-specific)
- Prioritize most-used commands in help

**Refactoring existing Makefile:**

- Read and understand first
- Search for all references
- Make targeted improvements
- Test all changes
- Update documentation
