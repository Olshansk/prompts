##########################
### Common Utilities   ###
##########################

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

# Package manager
NPM := npm

# Directories
TIMESTAMP := $(shell date '+%Y-%m-%d %H:%M:%S')
ROOT_DIR := $(shell pwd)
BUILD_DIR := $(ROOT_DIR)/build
DIST_DIR := $(ROOT_DIR)/dist
TMP_DIR := $(ROOT_DIR)/tmp

$(BUILD_DIR) $(DIST_DIR) $(TMP_DIR):
	$(Q)mkdir -p $@

# Guards & checks
define check_command
	@command -v $(1) >/dev/null 2>&1 || { \
		printf "$(RED)$(CROSS) Missing tool: $(1)$(RESET)\n"; \
		exit 1; \
	}
endef

define require-%
	@if [ -z "$($*)" ]; then \
		printf "$(RED)$(CROSS) Missing required variable: $*$(RESET)\n"; \
		exit 1; \
	fi
endef

.PHONY: prompt_confirm
prompt_confirm: ## Prompt before continuing
	@printf "$(YELLOW)Continue? [y/N] $(RESET)"; read ans; [ $${ans:-N} = y ]
