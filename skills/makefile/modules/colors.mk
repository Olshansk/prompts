# colors.mk - ANSI colors and print helpers
# Include this in complex projects: include ./makefiles/colors.mk

# ============================================================================
# ANSI Color Codes
# ============================================================================
GREEN   := \033[0;32m
YELLOW  := \033[1;33m
BLUE    := \033[0;34m
CYAN    := \033[0;36m
RED     := \033[0;31m
MAGENTA := \033[0;35m
BOLD    := \033[1m
DIM     := \033[2m
RESET   := \033[0m

# ============================================================================
# Status Symbols
# ============================================================================
CHECK := ✓
CROSS := ✗
WARN  := ⚠️
INFO  := ℹ️
ARROW := →

# ============================================================================
# Print Helpers
# Usage: $(call print_success,Your message here)
# ============================================================================
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

define print_section
	@printf "\n$(CYAN)$(BOLD)%s$(RESET)\n" "$(1)"
endef

# Alias for consistency with grove_api2 style
define print_info_section
	@printf "\n$(CYAN)$(BOLD)%s$(RESET)\n" "$(1)"
endef
