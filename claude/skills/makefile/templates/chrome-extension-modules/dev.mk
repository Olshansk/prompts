####################
### Development  ###
####################

.PHONY: dev-start
dev-start: ## Show instructions to load extension in Chrome
	$(call print_section,Loading Extension in Chrome)
	@printf "$(CYAN)$(INFO) 1. Open chrome://extensions/ in Chrome$(RESET)\n"
	@printf "$(CYAN)$(INFO) 2. Enable Developer mode (top right toggle)$(RESET)\n"
	@printf "$(CYAN)$(INFO) 3. Click Load unpacked and select this directory$(RESET)\n"
	@printf "$(CYAN)$(INFO) 4. Click refresh icon on extension card after changes$(RESET)\n"

.PHONY: dev-test
dev-test: ## Run unit tests with Vitest
	$(call print_section,Running tests)
	$(Q)$(NPM) run test

.PHONY: dev-test-watch
dev-test-watch: ## Run tests in watch mode for development
	$(call print_section,Running tests in watch mode)
	$(Q)$(NPM) run test:watch

.PHONY: dev-test-coverage
dev-test-coverage: ## Run tests and generate coverage report
	$(call print_section,Running tests with coverage)
	$(Q)$(NPM) run test:coverage

.PHONY: dev-test-e2e
dev-test-e2e: ## Run end-to-end tests with Playwright
	$(call print_section,Running E2E tests)
	$(Q)$(NPM) run test:e2e

.PHONY: dev-lint
dev-lint: ## Check code for linting errors
	$(call print_section,Running linter)
	$(Q)$(NPM) run lint

.PHONY: dev-format
dev-format: ## Format code with Prettier
	$(call print_section,Formatting code)
	$(Q)$(NPM) run format

.PHONY: dev-clean
dev-clean: ## Remove all build artifacts and temp files
	$(call print_warning,Removing build artifacts)
	$(Q)rm -rf $(BUILD_DIR) $(DIST_DIR) $(TMP_DIR)
	$(call print_success,Cleaned)

.PHONY: dev-install
dev-install: ## Install npm dependencies
	$(call print_section,Installing dependencies)
	$(Q)$(NPM) install
	$(call print_success,Dependencies installed)

.PHONY: dev-debug
dev-debug: ## Print debug info (directories, version)
	$(call print_section,Debug variables)
	$(Q)printf "ROOT_DIR=%s\nBUILD_DIR=%s\n" "$(ROOT_DIR)" "$(BUILD_DIR)"
	$(Q)printf "VERSION=%s\n" "$$(grep '"version"' manifest.json | sed 's/.*: "\([^"]*\)".*/\1/')"
