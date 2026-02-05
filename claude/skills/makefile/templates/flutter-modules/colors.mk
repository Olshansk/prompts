##########################
### Color Definitions  ###
##########################

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
	@printf "$(GREEN)$(BOLD)$(CHECK) %s$(RESET)\n" "$(1)"
endef

define print_error
	@printf "$(RED)$(BOLD)$(CROSS) %s$(RESET)\n" "$(1)"
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
