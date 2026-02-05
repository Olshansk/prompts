############################
### Flutter Linting      ###
############################

#########################
### Internal Checks   ###
#########################

.PHONY: _check-dart
_check-dart:
	@command -v flutter >/dev/null 2>&1 || { \
		printf "$(RED)$(CROSS) Flutter not installed$(RESET)\n"; \
		printf "$(YELLOW)Install from: https://flutter.dev/docs/get-started/install$(RESET)\n"; \
		exit 1; \
	}
	@test -d $(FLUTTER_DIR) || { \
		printf "$(RED)$(CROSS) Flutter directory not found: $(FLUTTER_DIR)$(RESET)\n"; \
		exit 1; \
	}

#########################
### Public Targets    ###
#########################

.PHONY: flutter-lint
flutter-lint: _check-dart ## Run Dart analyze and format check (FIX=true to auto-fix)
	$(call print_section,Running Dart linting)
ifeq ($(FIX),true)
	@cd $(FLUTTER_DIR) && dart format .
	$(call print_success,Dart code formatted)
else
	@cd $(FLUTTER_DIR) && flutter analyze
	@cd $(FLUTTER_DIR) && dart format --output=none --set-exit-if-changed .
	$(call print_success,Dart linting passed)
endif
