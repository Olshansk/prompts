############################
### Flutter Build        ###
############################

.PHONY: flutter-build-ios
flutter-build-ios: _check-flutter ## Build for iOS simulator
	$(call print_section,Building Flutter for iOS simulator)
	$(Q)cd $(FLUTTER_DIR) && flutter build ios --simulator
	$(call print_success,iOS simulator build complete)

.PHONY: flutter-build-ipa
flutter-build-ipa: _check-flutter ## Build IPA for App Store distribution
	$(call print_section,Flutter IPA Build)
	@if [ -d "$(FLUTTER_DIR)/build/ios/archive/Runner.xcarchive" ]; then \
		printf "$(YELLOW)Existing archive found.$(RESET)\n"; \
		printf "Rebuild from scratch? [y/N] "; \
		read -r answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			printf "$(CYAN)Rebuilding...$(RESET)\n"; \
			cd $(FLUTTER_DIR) && flutter build ipa --release --export-options-plist=$(EXPORT_OPTIONS_PLIST); \
		else \
			printf "$(CYAN)Exporting existing archive to IPA...$(RESET)\n"; \
			cd $(FLUTTER_DIR) && flutter build ipa --release --no-build-archive --export-options-plist=$(EXPORT_OPTIONS_PLIST); \
		fi; \
	else \
		printf "$(CYAN)Building...$(RESET)\n"; \
		cd $(FLUTTER_DIR) && flutter build ipa --release --export-options-plist=$(EXPORT_OPTIONS_PLIST); \
	fi
	$(call print_success,Flutter IPA build complete)
	@IPA_FILE=$$(ls $(FLUTTER_DIR)/build/ios/ipa/*.ipa 2>/dev/null | head -1); \
	if [ -n "$$IPA_FILE" ]; then \
		IPA_SIZE=$$(du -h "$$IPA_FILE" | cut -f1); \
		printf "\n"; \
		printf "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"; \
		printf "$(GREEN)$(BOLD)  IPA Ready!$(RESET)\n"; \
		printf "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"; \
		printf "\n"; \
		printf "  $(DIM)File:$(RESET) $$IPA_FILE\n"; \
		printf "  $(DIM)Size:$(RESET) $$IPA_SIZE\n"; \
		printf "\n"; \
		printf "$(YELLOW)$(BOLD)  Next step:$(RESET)\n"; \
		printf "\n"; \
		printf "     $(CYAN)make flutter-deploy-testflight$(RESET)\n"; \
		printf "\n"; \
		printf "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"; \
		printf "\n"; \
	fi

.PHONY: flutter-build-apk
flutter-build-apk: _check-flutter ## Build debug APK for Android
	$(call print_section,Building Flutter APK)
	$(Q)cd $(FLUTTER_DIR) && flutter build apk
	$(call print_success,APK build complete)
	@APK_FILE="$(FLUTTER_DIR)/build/app/outputs/flutter-apk/app-release.apk"; \
	if [ -f "$$APK_FILE" ]; then \
		APK_SIZE=$$(du -h "$$APK_FILE" | cut -f1); \
		printf "  $(DIM)File:$(RESET) $$APK_FILE\n"; \
		printf "  $(DIM)Size:$(RESET) $$APK_SIZE\n\n"; \
	fi

.PHONY: flutter-build-aab
flutter-build-aab: _check-flutter ## Build AAB for Google Play Store
	$(call print_section,Building Flutter App Bundle)
	$(Q)cd $(FLUTTER_DIR) && flutter build appbundle
	$(call print_success,AAB build complete)
	@AAB_FILE="$(FLUTTER_DIR)/build/app/outputs/bundle/release/app-release.aab"; \
	if [ -f "$$AAB_FILE" ]; then \
		AAB_SIZE=$$(du -h "$$AAB_FILE" | cut -f1); \
		printf "  $(DIM)File:$(RESET) $$AAB_FILE\n"; \
		printf "  $(DIM)Size:$(RESET) $$AAB_SIZE\n\n"; \
	fi
