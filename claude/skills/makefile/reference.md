# Makefile Reference

Detailed patterns and conventions for creating maintainable Makefiles.

## Table of Contents

- [Python/uv Patterns](#pythonuv-patterns)
- [Preflight Checks](#preflight-checks)
- [External Tool Dependencies](#external-tool-dependencies)
- [Env File Loading](#env-file-loading)
- [Quickstart Targets](#quickstart-targets)
- [Argument Passing](#argument-passing)
- [Categorized Help Pattern](#categorized-help-pattern)
- [Naming Convention Details](#naming-convention-details)
- [Legacy Compatibility](#legacy-compatibility)
- [Global Error Handling](#global-error-handling)
- [Improving Existing Makefiles](#improving-existing-makefiles)
- [Common Refactoring Patterns](#common-refactoring-patterns)

## Python/uv Patterns

### Always Use `uv run`

Run all Python commands through `uv run` to ensure the virtual environment is used:

```makefile
# Good - uses uv run
dev-format:
	uv run black .
	uv run isort .
	uv run flake8 .

dev-test:
	uv run pytest tests/ -v

# Bad - requires manual venv activation
dev-format:
	black .
	isort .
```

### Use `uv sync` for Dependencies

```makefile
env-install: ## Install dependencies
	uv sync  # Uses pyproject.toml + uv.lock

env-install-prod: ## Install production only
	uv sync --no-dev
```

### Check for uv

```makefile
env-install:
	@command -v uv >/dev/null 2>&1 || { printf "$(RED)Missing: uv$(RESET)\n"; exit 1; }
	uv sync
```

## Preflight Checks

Use `_check-*` targets as prerequisites:

```makefile
.PHONY: _check-docker _check-postgres

_check-docker:
	@if ! docker info >/dev/null 2>&1; then \
		printf "$(RED)❌ Docker is not running$(RESET)\n"; \
		printf "$(YELLOW)💡 Please start Docker Desktop$(RESET)\n"; \
		exit 1; \
	fi

_check-postgres:
	@if ! docker ps --filter "name=$(POSTGRES_CONTAINER)" --filter "status=running" \
		--format "{{.Names}}" | grep -q "$(POSTGRES_CONTAINER)"; then \
		printf "$(RED)❌ PostgreSQL not running$(RESET)\n"; \
		printf "$(YELLOW)💡 Start with: make db-start$(RESET)\n"; \
		exit 1; \
	fi

# Usage - check runs before target
db-start: _check-docker
	docker compose up -d postgres

db-migrate: _check-postgres
	uv run alembic upgrade head
```

## External Tool Dependencies

When a target requires an external CLI tool:

**Key principles:**
- Don't create public `install-X` or `check-X` targets
- Use internal `_check-X` as a dependency (no `##` = hidden from help)
- Show the install command on failure - don't auto-install
- Name target after the action, not the tool

```makefile
# Internal check - hidden from help (no ## comment)
_check-rembg:
	@command -v rembg >/dev/null 2>&1 || { \
		printf "$(RED)$(CROSS) rembg not installed$(RESET)\n"; \
		printf "$(YELLOW)Run: uv tool install \"rembg[cli]\"$(RESET)\n"; \
		exit 1; \
	}

# Public target - named after action, not tool
.PHONY: remove-bg
remove-bg: _check-rembg ## Remove background from image
	rembg i "$(IN)" "$(OUT)"
```

**What NOT to do:**

```makefile
# Bad - too many public targets
rembg:          ## Remove background      # Named after tool
rembg-install:  ## Install rembg          # Don't expose install
rembg-check:    ## Check if installed     # Don't expose check

# Good - minimal public surface
remove-bg: _check-rembg ## Remove background from image
```

## Env File Loading

Support multiple environment files:

```makefile
# Simple: Load from E2E_ENV or default to .env
test-e2e:
	@set -a && . "$${E2E_ENV:-.env}" && set +a && uv run pytest tests/e2e/

# Usage:
# make test-e2e                    # Uses .env
# E2E_ENV=.test.env make test-e2e  # Uses .test.env
```

### Reusable Macro

```makefile
define run_with_env
	@if [ -n "$$E2E_ENV" ]; then \
		printf "$(CYAN)$(INFO) Loading: $$E2E_ENV$(RESET)\n"; \
		if [ ! -f "$$E2E_ENV" ]; then \
			printf "$(RED)❌ File not found: $$E2E_ENV$(RESET)\n"; \
			exit 1; \
		fi; \
		set -a && . "$$E2E_ENV" && set +a; \
		$(1); \
	else \
		$(1); \
	fi
endef

# Usage
api-call:
	$(call run_with_env,uv run python scripts/call_api.py)
```

## Quickstart Targets

Interactive setup guides for onboarding:

```makefile
.PHONY: quickstart-dev
quickstart-dev: ## Interactive developer setup
	@printf "\n$(BOLD)$(GREEN)🚀 Developer Setup$(RESET)\n\n"
	@printf "$(BOLD)Step 1:$(RESET) Install dependencies\n"
	@printf "   $(CYAN)make env-install$(RESET)\n\n"
	@read -p "   Press Enter when ready..." dummy
	@$(MAKE) env-install
	@printf "\n$(GREEN)✓ Done$(RESET)\n\n"
	@printf "$(BOLD)Step 2:$(RESET) Start database\n"
	@printf "   $(CYAN)make db-start$(RESET)\n\n"
	@read -p "   Press Enter when ready..." dummy
	@$(MAKE) db-start
	@printf "\n$(GREEN)✓ Setup complete!$(RESET)\n"
```

## Argument Passing

Pass arguments to make targets:

```makefile
# Method 1: filter-out MAKECMDGOALS
api-fund: ## Fund account (usage: make api-fund 0.1)
	uv run python scripts/fund.py $(filter-out $@,$(MAKECMDGOALS))

# Method 2: Named variable
db-revision: ## Create migration (usage: make db-revision MSG="description")
	uv run alembic revision --autogenerate -m "$(MSG)"

# Catchall to ignore arguments (add at END of Makefile)
%:
	@TARGET="$@"; \
	if echo "$$TARGET" | grep -qE '^([0-9]+\.?[0-9]*|0x[a-fA-F0-9]+)$$'; then \
		: ; \
	else \
		printf "$(RED)❌ Unknown target '$$TARGET'$(RESET)\n"; \
		exit 1; \
	fi
```

## Categorized Help Pattern

For 10+ targets, organize help output by category:

```makefile
.PHONY: help
help: ## Show all available targets
	@printf "\n$(BOLD)$(CYAN)📋 Project - Makefile Targets$(RESET)\n\n"

	@printf "$(BOLD)=== 🚀 Quick Start ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "setup" "First-time setup"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "run" "Run the app"
	@printf "\n"

	@printf "$(BOLD)=== 💻 Development ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "dev-run" "Run dev server"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "dev-test" "Run tests"
	@printf "\n"

	@printf "$(BOLD)=== 🌍 Environment ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "env-local" "Setup local env"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "env-prod" "Setup prod env"
	@printf "\n"
```

### Usage Examples in Help

For targets with parameters, show usage on a second line in green:

```makefile
@printf "$(CYAN)%-40s$(RESET) %s\n" "remove-bg" "Remove background from image"
@printf "%-40s $(GREEN)make remove-bg IN=logo.png [OUT=logo_nobg.png]$(RESET)\n" ""
```

**Format rules:**
- Description on first line (cyan target name, white description)
- Usage on second line in `$(GREEN)` (avoid `$(DIM)` - appears grey/unreadable)
- Include full command with realistic example values
- Show optional params in brackets with sensible defaults

**Ordering principle:** Most-used commands first

1. Quick Start (setup, run)
2. Development (dev-*)
3. Testing (test-*)
4. Environment (env-*)
5. Database (db-*)
6. CI/CD (ci-*)
7. Cleaning (clean-*)

## Naming Convention Details

### Prefix Groups

| Prefix | Purpose | Examples |
|--------|---------|----------|
| `env-` | Environment management | `env-local`, `env-prod`, `env-show` |
| `dev-` | Development tasks | `dev-run`, `dev-build`, `dev-clean` |
| `db-` | Database operations | `db-start`, `db-stop`, `db-migrate` |
| `test-` | Testing | `test-unit`, `test-integration`, `test-e2e` |
| `ci-` | CI/CD operations | `ci-test`, `ci-deploy`, `ci-trigger` |
| `clean-` | Cleanup tasks | `clean-cache`, `clean-build`, `clean-all` |
| `docker-` | Container operations | `docker-build`, `docker-push`, `docker-run` |

### Why Prefixes Matter

- **Tab completion**: Type `make dev-<TAB>` to see all dev targets
- **Visual grouping**: Related targets appear together in help
- **Clear purpose**: Name alone explains what it does
- **No conflicts**: `dev-build` vs `docker-build` are distinct

### Bad Patterns to Avoid

```makefile
# Inconsistent prefixes
run-dev          # Should be dev-run
build            # Ambiguous - dev-build? docker-build?
clean-reinstall-dev  # Too long - just dev-clean

# Mixed naming styles
localEnv         # camelCase
test_net         # snake_case
prod-env         # kebab-case
# Pick ONE style (kebab-case recommended)

# Ambiguous names
start            # Start what?
stop             # Stop what?
run              # Run what?
# Better: db-start, server-stop, app-run

# Named after tool instead of action
rembg            # What does this do? (tool name)
prettier         # Is this running or configuring?
eslint           # Unclear purpose
# Better: remove-bg, format-code, lint-check
```

## Legacy Compatibility

When refactoring, maintain backward compatibility:

```makefile
############################
### Legacy Target Aliases ##
############################

# Old name -> new name (add deprecation notice)
.PHONY: old_target_name
old_target_name: new-target-name ## (Legacy) Use new-target-name instead

# Examples from real refactoring
.PHONY: uvx_install
uvx_install: env-install ## (Legacy) Use env-install

.PHONY: py_format
py_format: dev-format ## (Legacy) Use dev-format
```

**Process for renaming:**

1. Search all references: `rg "make old-name"` in docs, CI, scripts
2. Add alias pointing old -> new
3. Update documentation
4. Keep alias for at least one release cycle

## Global Error Handling

Add at the END of root Makefile (after all includes):

```makefile
###############################
###  Global Error Handling  ###
###############################

# Catch-all for undefined targets
%:
	@echo ""
	@echo "$(RED)❌ Error: Unknown target '$(BOLD)$@$(RESET)$(RED)'$(RESET)"
	@echo ""
	@echo "$(YELLOW)💡 Available targets:$(RESET)"
	@echo "   Run $(CYAN)make help$(RESET) to see all available targets"
	@echo ""
	@exit 1
```

**With context-specific hints:**

```makefile
%:
	@echo ""
	@echo "$(RED)❌ Error: Unknown target '$(BOLD)$@$(RESET)$(RED)'$(RESET)"
	@echo ""
	@if echo "$@" | grep -q "^db"; then \
		echo "$(YELLOW)💡 Database targets require Docker running$(RESET)"; \
		echo "   Run: $(CYAN)docker ps$(RESET) to verify"; \
	elif echo "$@" | grep -q "^python\|^py"; then \
		echo "$(YELLOW)💡 Python targets require virtual environment$(RESET)"; \
		echo "   Run: $(CYAN)source .venv/bin/activate$(RESET) first"; \
	else \
		echo "$(YELLOW)💡 Run $(CYAN)make help$(RESET) to see available targets"; \
	fi
	@echo ""
	@exit 1
```

## Improving Existing Makefiles

### Workflow

1. **Read first**: `cat Makefile` - understand current state
2. **Check modules**: `ls makefiles/*.mk 2>/dev/null`
3. **Analyze patterns**: What conventions exist?
4. **Search before renaming**: `rg "make target-name"`
5. **Propose targeted changes**: Don't rewrite everything
6. **Test**: `make help`, `make -n target`
7. **Update docs**: README, CI configs, developer docs

### Questions to Ask

- What's the pain point with the current Makefile?
- Are there targets that are rarely used?
- Are there missing targets people need?
- Is the help output helpful or overwhelming?

## Common Refactoring Patterns

### Consolidating Verbose Names

```makefile
# Before
dev-clean-reinstall-deps-and-cache:

# After
dev-clean:  ## Clean and reinstall (does all cleanup)
```

### Splitting Overloaded Targets

```makefile
# Before - does too much
deploy: test build push restart-servers update-dns notify-team

# After - split into stages
deploy: test build push
	@printf "$(GREEN)Ready. Run 'make deploy-live' to continue$(RESET)\n"

deploy-live: restart-servers update-dns notify-team
	@printf "$(GREEN)✓ Deployment complete$(RESET)\n"
```

### Adding Missing Help Descriptions

```makefile
# Before - no help
clean:
	rm -rf build/

# After - documented
clean: ## Remove build artifacts
	rm -rf build/
```

### Standardizing Output

```makefile
# Before - inconsistent
test:
	echo "Running tests..."
	pytest

# After - consistent colors
test: ## Run tests
	@printf "$(CYAN)Running tests...$(RESET)\n"
	pytest
	@printf "$(GREEN)✓ Tests passed$(RESET)\n"
```
