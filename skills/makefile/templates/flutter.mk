# Flutter App Makefile Template
#
# Features:
#   - Modular structure (colors, common, dev, build, deploy, lint)
#   - iOS simulator auto-boot + wait loop
#   - Android emulator auto-detect + launch
#   - Physical device auto-detect or explicit FLUTTER_IOS_DEVICE/FLUTTER_ANDROID_DEVICE
#   - IPA build with rebuild/re-export prompt
#   - TestFlight upload with ASC credential validation
#   - Dart linting with FIX=true pattern
#
# Structure:
#   Makefile                    # This file - config + help + includes
#   makefiles/
#     colors.mk                 # ANSI colors & print helpers
#     common.mk                 # Shell flags, VERBOSE mode, guards
#     dev.mk                    # Setup, run simulator/device, devices, clean
#     build.mk                  # iOS/Android builds (IPA, APK, AAB)
#     deploy.mk                 # TestFlight upload
#     lint.mk                   # Dart analyze & format

.DEFAULT_GOAL := help

#########################
### Configuration     ###
#########################

# Flutter project directory (default: current dir; override for monorepos)
FLUTTER_DIR ?= .

# Device IDs (leave blank for auto-detect)
FLUTTER_IOS_DEVICE ?=
FLUTTER_ANDROID_DEVICE ?=

# App Store Connect credentials (for TestFlight uploads)
ASC_API_KEY ?=
ASC_API_ISSUER ?=

# iOS build config
EXPORT_OPTIONS_PLIST ?= ios/ExportOptions.plist

# Linting
FIX ?= false

# Export env vars to sub-processes
.EXPORT_ALL_VARIABLES:

# Help pattern matching (must match grep patterns in help target)
HELP_PATTERNS := \
	'^help' \
	'^flutter-' \
	'^quickstart'

###############
### Imports ###
###############

include ./makefiles/colors.mk
include ./makefiles/common.mk
include ./makefiles/dev.mk
include ./makefiles/build.mk
include ./makefiles/deploy.mk
include ./makefiles/lint.mk

##################
### Utilities  ###
##################

.PHONY: quickstart
quickstart: ## Show instructions to get started
	@printf "\n$(YELLOW)$(BOLD)Flutter App Quickstart:$(RESET)\n"
	@printf "  $(MAGENTA)1.$(RESET) Run: $(GREEN)make flutter-setup$(RESET)\n"
	@printf "  $(MAGENTA)2.$(RESET) Run: $(GREEN)make flutter-run-ios$(RESET) (simulator)\n"
	@printf "     or: $(GREEN)make flutter-run-device$(RESET) (physical device)\n\n"

##############
### Help   ###
##############

.PHONY: help
help: ## Show all available targets
	@printf "\n"
	@printf "$(BOLD)$(CYAN)╔════════════════════════════════╗$(RESET)\n"
	@printf "$(BOLD)$(CYAN)║       Flutter App               ║$(RESET)\n"
	@printf "$(BOLD)$(CYAN)╚════════════════════════════════╝$(RESET)\n\n"
	@printf "$(BOLD)=== 📱 Flutter Development ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-setup" "Get Flutter deps and install iOS pods"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-run-ios" "Run on iOS simulator (auto-boots)"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-run-android" "Run on Android emulator (auto-launches)"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-run-device" "Run on physical device (auto-detects)"
	@printf "%-30s $(GREEN)make flutter-run-device FLUTTER_IOS_DEVICE=<id>$(RESET)\n" ""
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-run-device-release" "Run on physical device in release mode"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-devices" "List all available devices"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-clean" "Clean build artifacts"
	@printf "\n"
	@printf "$(BOLD)=== 🏗️  Flutter Build ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-build-ios" "Build for iOS simulator"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-build-ipa" "Build IPA for App Store"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-build-apk" "Build debug APK for Android"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-build-aab" "Build AAB for Google Play Store"
	@printf "\n"
	@printf "$(BOLD)=== 🚀 Flutter Deploy ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-deploy-testflight" "Upload IPA to TestFlight"
	@printf "%-30s $(GREEN)make flutter-deploy-testflight ASC_API_KEY=<key> ASC_API_ISSUER=<issuer>$(RESET)\n" ""
	@printf "\n"
	@printf "$(BOLD)=== 🔍 Linting ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "flutter-lint" "Run Dart analyze and format check"
	@printf "%-30s $(GREEN)make flutter-lint FIX=true$(RESET)\n" ""
	@printf "\n"
	@printf "$(BOLD)=== ❓ Help ===$(RESET)\n"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "help" "Show this help"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "help-unclassified" "Show targets not in categorized help"
	@printf "$(CYAN)%-30s$(RESET) %s\n" "quickstart" "Show instructions to get started"
	@printf "\n"

.PHONY: help-unclassified
help-unclassified: ## Show targets not in categorized help
	@printf "$(BOLD)Targets not in main help:$(RESET)\n"
	@result=$$(grep -h -E '^[a-zA-Z][a-zA-Z0-9-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		grep -v -E '^(flutter-|help|quickstart)'); \
	if [ -z "$$result" ]; then \
		printf "  (none)\n"; \
	else \
		echo "$$result" | sed 's/^[^:]*://' | awk 'BEGIN {FS = ":.*?## "} {printf "$(CYAN)%-30s$(RESET) %s\n", $$1, $$2}'; \
	fi

################
### Catch-all ##
################

%:
	@if [ "$@" != "Makefile" ] && ! echo "$@" | grep -qE '^\.|^makefiles/'; then \
		printf "$(RED)Unknown target '$@'$(RESET)\n"; \
		$(MAKE) --no-print-directory help; \
	fi
