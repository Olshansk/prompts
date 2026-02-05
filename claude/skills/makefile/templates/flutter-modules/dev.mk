############################
### Flutter Development  ###
############################

#########################
### Internal Checks   ###
#########################

.PHONY: _check-flutter
_check-flutter:
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

.PHONY: flutter-setup
flutter-setup: _check-flutter ## Get Flutter deps and install iOS pods
	$(call print_section,Setting up Flutter project)
	$(Q)cd $(FLUTTER_DIR) && flutter pub get
	@if [ -d "$(FLUTTER_DIR)/ios" ]; then \
		printf "$(CYAN)Installing CocoaPods dependencies...$(RESET)\n"; \
		cd $(FLUTTER_DIR)/ios && pod install; \
	fi
	$(call print_success,Flutter setup complete)

.PHONY: flutter-run-ios
flutter-run-ios: _check-flutter ## Run on iOS simulator (auto-boots if needed)
	$(call print_section,Starting Flutter on iOS simulator)
	@open -a Simulator
	@SIMULATOR_NAME=$$(xcrun simctl list devices booted -j 2>/dev/null | python3 -c "import sys,json; data=json.load(sys.stdin); booted=[d['name'] for devs in data.get('devices',{}).values() for d in devs if d.get('state')=='Booted']; print(booted[0] if booted else '')" 2>/dev/null); \
	if [ -z "$$SIMULATOR_NAME" ]; then \
		printf "$(YELLOW)Waiting for simulator to boot...$(RESET)\n"; \
		sleep 5; \
		while true; do \
			SIMULATOR_NAME=$$(xcrun simctl list devices booted -j 2>/dev/null | python3 -c "import sys,json; data=json.load(sys.stdin); booted=[d['name'] for devs in data.get('devices',{}).values() for d in devs if d.get('state')=='Booted']; print(booted[0] if booted else '')" 2>/dev/null); \
			if [ -n "$$SIMULATOR_NAME" ]; then break; fi; \
			printf "$(DIM).$(RESET)"; \
			sleep 2; \
		done; \
		printf "\n$(GREEN)$(CHECK) Simulator ready$(RESET)\n"; \
	fi; \
	printf "$(CYAN)Running on: $$SIMULATOR_NAME$(RESET)\n"; \
	cd $(FLUTTER_DIR) && flutter run -d "$$SIMULATOR_NAME"

.PHONY: flutter-run-android
flutter-run-android: _check-flutter ## Run on Android emulator (auto-launches if needed)
	$(call print_section,Starting Flutter on Android emulator)
	@AVAIL_EMU=$$(flutter emulators 2>/dev/null | grep "android" | awk '{print $$1}' | head -1); \
	if [ -z "$$AVAIL_EMU" ]; then \
		printf "$(RED)$(CROSS) No Android emulators found$(RESET)\n"; \
		printf "$(YELLOW)Create one in Android Studio: Tools > Device Manager > Create Device$(RESET)\n"; \
		exit 1; \
	fi; \
	printf "$(CYAN)Launching emulator: $$AVAIL_EMU$(RESET)\n"; \
	flutter emulators --launch "$$AVAIL_EMU"; \
	printf "$(YELLOW)Waiting for emulator to boot...$(RESET)\n"; \
	sleep 10; \
	while true; do \
		EMULATOR_ID=$$(flutter devices --machine 2>/dev/null | python3 -c "import sys,json; devices=json.load(sys.stdin); emu=[d['id'] for d in devices if 'android' in d.get('targetPlatform','').lower() and 'emulator' in d.get('id','').lower()]; print(emu[0] if emu else '')" 2>/dev/null); \
		if [ -n "$$EMULATOR_ID" ]; then break; fi; \
		printf "$(DIM).$(RESET)"; \
		sleep 3; \
	done; \
	printf "\n$(GREEN)$(CHECK) Emulator ready$(RESET)\n"; \
	printf "$(CYAN)Running on: $$EMULATOR_ID$(RESET)\n"; \
	cd $(FLUTTER_DIR) && flutter run -d "$$EMULATOR_ID"

.PHONY: flutter-run-device
flutter-run-device: _check-flutter ## Run on physical device (auto-detects or uses FLUTTER_IOS_DEVICE)
	$(call print_section,Starting Flutter on physical device)
	@if [ -n "$(FLUTTER_IOS_DEVICE)" ]; then \
		DEVICE_ID="$(FLUTTER_IOS_DEVICE)"; \
	elif [ -n "$(FLUTTER_ANDROID_DEVICE)" ]; then \
		DEVICE_ID="$(FLUTTER_ANDROID_DEVICE)"; \
	else \
		DEVICE_ID=$$(flutter devices --machine 2>/dev/null | python3 -c "import sys,json; devices=json.load(sys.stdin); phys=[d['id'] for d in devices if not d.get('emulator',True)]; print(phys[0] if phys else '')" 2>/dev/null); \
		if [ -z "$$DEVICE_ID" ]; then \
			printf "$(RED)$(CROSS) No physical device connected$(RESET)\n"; \
			printf "$(YELLOW)Connect a device or set FLUTTER_IOS_DEVICE / FLUTTER_ANDROID_DEVICE$(RESET)\n"; \
			exit 1; \
		fi; \
	fi; \
	printf "$(CYAN)Running on device: $$DEVICE_ID$(RESET)\n"; \
	cd $(FLUTTER_DIR) && flutter run -d "$$DEVICE_ID"

.PHONY: flutter-run-device-release
flutter-run-device-release: _check-flutter ## Run on physical device in release mode
	$(call print_section,Starting Flutter on physical device (release))
	@if [ -n "$(FLUTTER_IOS_DEVICE)" ]; then \
		DEVICE_ID="$(FLUTTER_IOS_DEVICE)"; \
	elif [ -n "$(FLUTTER_ANDROID_DEVICE)" ]; then \
		DEVICE_ID="$(FLUTTER_ANDROID_DEVICE)"; \
	else \
		DEVICE_ID=$$(flutter devices --machine 2>/dev/null | python3 -c "import sys,json; devices=json.load(sys.stdin); phys=[d['id'] for d in devices if not d.get('emulator',True)]; print(phys[0] if phys else '')" 2>/dev/null); \
		if [ -z "$$DEVICE_ID" ]; then \
			printf "$(RED)$(CROSS) No physical device connected$(RESET)\n"; \
			printf "$(YELLOW)Connect a device or set FLUTTER_IOS_DEVICE / FLUTTER_ANDROID_DEVICE$(RESET)\n"; \
			exit 1; \
		fi; \
	fi; \
	printf "$(CYAN)Running on device: $$DEVICE_ID (release)$(RESET)\n"; \
	cd $(FLUTTER_DIR) && flutter run --release -d "$$DEVICE_ID"

.PHONY: flutter-devices
flutter-devices: _check-flutter ## List all available Flutter devices
	$(call print_section,Available Flutter devices)
	$(Q)flutter devices

.PHONY: flutter-clean
flutter-clean: _check-flutter ## Clean Flutter build artifacts
	$(call print_section,Cleaning Flutter build artifacts)
	$(Q)cd $(FLUTTER_DIR) && flutter clean
	$(call print_success,Flutter clean complete)
