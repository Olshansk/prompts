############################
### Flutter Deploy       ###
############################

# Optional: URL to view TestFlight builds after upload
TESTFLIGHT_URL ?=

#########################
### Internal Checks   ###
#########################

.PHONY: _check-asc-credentials
_check-asc-credentials:
	@if [ -z "$(ASC_API_KEY)" ] || [ -z "$(ASC_API_ISSUER)" ]; then \
		printf "$(RED)$(CROSS) Missing App Store Connect credentials$(RESET)\n"; \
		printf "$(YELLOW)Set ASC_API_KEY and ASC_API_ISSUER in your Makefile or environment$(RESET)\n"; \
		printf "$(DIM)  ASC_API_KEY=<your-key-id> ASC_API_ISSUER=<your-issuer-id> make flutter-deploy-testflight$(RESET)\n"; \
		exit 1; \
	fi

#########################
### Public Targets    ###
#########################

.PHONY: flutter-deploy-testflight
flutter-deploy-testflight: _check-asc-credentials ## Upload IPA to TestFlight
	$(call print_section,Uploading IPA to TestFlight)
	@IPA_FILE=$$(ls $(FLUTTER_DIR)/build/ios/ipa/*.ipa 2>/dev/null | head -1); \
	if [ -z "$$IPA_FILE" ]; then \
		printf "$(RED)$(CROSS) No IPA file found$(RESET)\n"; \
		printf "$(YELLOW)Run 'make flutter-build-ipa' first$(RESET)\n"; \
		exit 1; \
	fi; \
	printf "$(CYAN)Uploading: $$IPA_FILE$(RESET)\n"; \
	UPLOAD_OUTPUT=$$(xcrun altool --upload-app --type ios -f "$$IPA_FILE" --apiKey "$(ASC_API_KEY)" --apiIssuer "$(ASC_API_ISSUER)" 2>&1); \
	UPLOAD_EXIT=$$?; \
	echo "$$UPLOAD_OUTPUT"; \
	if [ $$UPLOAD_EXIT -eq 0 ] && ! echo "$$UPLOAD_OUTPUT" | grep -q "ERROR:"; then \
		printf "\n"; \
		printf "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"; \
		printf "$(GREEN)$(BOLD)  Uploaded to TestFlight!$(RESET)\n"; \
		printf "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"; \
		if [ -n "$(TESTFLIGHT_URL)" ]; then \
			printf "\n"; \
			printf "  $(DIM)Check status at:$(RESET)\n"; \
			printf "  $(CYAN)$(TESTFLIGHT_URL)$(RESET)\n"; \
		fi; \
		printf "\n"; \
		printf "$(GREEN)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"; \
		printf "\n"; \
	else \
		printf "\n"; \
		printf "$(RED)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"; \
		printf "$(RED)$(BOLD)  Upload Failed$(RESET)\n"; \
		printf "$(RED)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(RESET)\n"; \
		printf "\n"; \
		printf "  $(YELLOW)Check that your API key is in ~/.private_keys/$(RESET)\n"; \
		printf "  $(DIM)Expected: ~/.private_keys/AuthKey_$(ASC_API_KEY).p8$(RESET)\n"; \
		printf "\n"; \
		exit 1; \
	fi
