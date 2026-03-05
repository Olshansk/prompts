########################
### Makefile Helpers ###
########################

# ANSI color codes
BOLD := \033[1m
CYAN := \033[36m
RESET := \033[0m

# Patterns for classified help categories (automatically used by help-unclassified)
HELP_PATTERNS := \
	'^(help|help-unclassified):' \
	'^agent.*:' \
	'^command.*:' \
	'^project.*:' \
	'^claude.*:'

.PHONY: help
.DEFAULT_GOAL := help
help: ## Prints all the targets in the Makefile
	@echo ""
	@echo "$(BOLD)$(CYAN)🤖 Claude Configuration Makefile Targets$(RESET)"
	@echo ""
	@echo "$(BOLD)=== 📋 Information & Discovery ===$(RESET)"
	@grep -h -E '^(help|help-unclassified):.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)=== 🔧 Agent Management ===$(RESET)"
	@grep -h -E '^agent.*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)=== 📝 Command Management ===$(RESET)"
	@grep -h -E '^command.*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)=== 📦 Project Management ===$(RESET)"
	@grep -h -E '^project.*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BOLD)=== 🤖 Claude Tools ===$(RESET)"
	@grep -h -E '^claude.*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'
	@echo ""

.PHONY: help-unclassified
help-unclassified: ## Show all unclassified targets
	@echo ""
	@echo "$(BOLD)$(CYAN)📦 Unclassified Targets$(RESET)"
	@echo ""
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sed 's/:.*//g' | sort -u > /tmp/all_targets.txt
	@( \
		for pattern in $(HELP_PATTERNS); do \
			grep -h -E "$pattern.*?## .*\$$" $(MAKEFILE_LIST) 2>/dev/null || true; \
		done \
	) | sed 's/:.*//g' | sort -u > /tmp/classified_targets.txt
	@comm -23 /tmp/all_targets.txt /tmp/classified_targets.txt | while read target; do \
		grep -h -E "^$$target:.*?## .*\$$" $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-40s$(RESET) %s\n", $$1, $$2}'; \
	done
	@rm -f /tmp/all_targets.txt /tmp/classified_targets.txt
	@echo ""

#############################
### Agent Management      ###
#############################

.PHONY: agent-list
agent-list: ## List all available agents
	@echo "Available agents:"
	@ls -1 agents/ 2>/dev/null || echo "No agents found in agents/ directory"

.PHONY: agent-validate
agent-validate: ## Validate agent configurations
	@echo "Validating agent configurations..."
	@for agent in agents/*.md; do \
		if [ -f "$$agent" ]; then \
			echo "✓ $$agent"; \
		fi \
	done

#############################
### Command Management    ###
#############################

.PHONY: command-list
command-list: ## List all slash commands
	@echo "Available slash commands:"
	@ls -1 commands/ 2>/dev/null || echo "No commands found in commands/ directory"

.PHONY: command-validate
command-validate: ## Validate command configurations
	@echo "Validating command configurations..."
	@for cmd in commands/*.md; do \
		if [ -f "$$cmd" ]; then \
			echo "✓ $$cmd"; \
		fi \
	done

#############################
### Project Management    ###
#############################

.PHONY: project-list
project-list: ## List all projects
	@echo "Available projects:"
	@ls -1 projects/ 2>/dev/null || echo "No projects found in projects/ directory"

.PHONY: project-sync
project-sync: ## Sync project configurations
	@echo "Syncing project configurations..."
	@echo "Not yet implemented"

#############################
### Claude Tools          ###
#############################

.PHONY: claude-status
claude-status: ## Show Claude configuration status
	@echo "Claude Configuration Status:"
	@echo "  Agents:   $$(ls -1 agents/ 2>/dev/null | wc -l | tr -d ' ')"
	@echo "  Commands: $$(ls -1 commands/ 2>/dev/null | wc -l | tr -d ' ')"
	@echo "  Projects: $$(ls -1 projects/ 2>/dev/null | wc -l | tr -d ' ')"

.PHONY: claude-clean
claude-clean: ## Clean temporary files and cache
	@echo "Cleaning temporary files..."
	@rm -f /tmp/all_targets.txt /tmp/classified_targets.txt
	@echo "Done"
