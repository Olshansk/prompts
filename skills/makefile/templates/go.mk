# Go Makefile Template
# Copy this file to your project root as 'Makefile'
#
# Prerequisites:
#   - Go 1.21+ installed
#   - go.mod initialized

.DEFAULT_GOAL := help

# ============================================================================
# Configuration (adjust these)
# ============================================================================
BINARY_NAME := myapp
MAIN_PATH := ./cmd/$(BINARY_NAME)
# Or for single-file projects: MAIN_PATH := .

# Build settings
BUILD_DIR := ./build
LDFLAGS := -ldflags "-s -w"

# ============================================================================
# Colors
# ============================================================================
GREEN  := \033[0;32m
YELLOW := \033[1;33m
RED    := \033[0;31m
CYAN   := \033[0;36m
BOLD   := \033[1m
RESET  := \033[0m

# ============================================================================
# Help
# ============================================================================
.PHONY: help
help: ## Show available commands
	@printf "\n$(BOLD)$(CYAN)Go Project$(RESET)\n\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "$(CYAN)%-20s$(RESET) %s\n", $$1, $$2}'
	@printf "\n"

# ============================================================================
# Dependencies
# ============================================================================
.PHONY: deps deps-update deps-tidy

deps: ## Download dependencies
	@printf "$(CYAN)Downloading dependencies...$(RESET)\n"
	go mod download
	@printf "$(GREEN)✓ Dependencies downloaded$(RESET)\n"

deps-update: ## Update dependencies
	@printf "$(CYAN)Updating dependencies...$(RESET)\n"
	go get -u ./...
	go mod tidy
	@printf "$(GREEN)✓ Dependencies updated$(RESET)\n"

deps-tidy: ## Tidy go.mod
	@printf "$(CYAN)Tidying modules...$(RESET)\n"
	go mod tidy
	@printf "$(GREEN)✓ Done$(RESET)\n"

# ============================================================================
# Build
# ============================================================================
.PHONY: build build-all run

build: ## Build binary
	@printf "$(CYAN)Building $(BINARY_NAME)...$(RESET)\n"
	@mkdir -p $(BUILD_DIR)
	go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME) $(MAIN_PATH)
	@printf "$(GREEN)✓ Built: $(BUILD_DIR)/$(BINARY_NAME)$(RESET)\n"

build-all: ## Build for all platforms
	@printf "$(CYAN)Building for all platforms...$(RESET)\n"
	@mkdir -p $(BUILD_DIR)
	GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-amd64 $(MAIN_PATH)
	GOOS=darwin GOARCH=arm64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-darwin-arm64 $(MAIN_PATH)
	GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-linux-amd64 $(MAIN_PATH)
	GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BUILD_DIR)/$(BINARY_NAME)-windows-amd64.exe $(MAIN_PATH)
	@printf "$(GREEN)✓ Built all platforms$(RESET)\n"

run: ## Run without building
	@printf "$(CYAN)Running...$(RESET)\n"
	go run $(MAIN_PATH)

# ============================================================================
# Code Quality
# ============================================================================
.PHONY: dev-fmt dev-lint dev-vet

dev-fmt: ## Format code
	@printf "$(CYAN)Formatting...$(RESET)\n"
	go fmt ./...
	@printf "$(GREEN)✓ Formatted$(RESET)\n"

dev-lint: ## Run golangci-lint
	@printf "$(CYAN)Linting...$(RESET)\n"
	golangci-lint run ./...
	@printf "$(GREEN)✓ Linting passed$(RESET)\n"

dev-vet: ## Run go vet
	@printf "$(CYAN)Running vet...$(RESET)\n"
	go vet ./...
	@printf "$(GREEN)✓ Vet passed$(RESET)\n"

# ============================================================================
# Testing
# ============================================================================
.PHONY: test test-verbose test-coverage test-race

test: ## Run tests
	@printf "$(CYAN)Running tests...$(RESET)\n"
	go test ./...

test-verbose: ## Run tests with verbose output
	go test -v ./...

test-coverage: ## Run tests with coverage
	@printf "$(CYAN)Running tests with coverage...$(RESET)\n"
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html
	@printf "$(GREEN)✓ Coverage report: coverage.html$(RESET)\n"

test-race: ## Run tests with race detector
	@printf "$(CYAN)Running race detection...$(RESET)\n"
	go test -race ./...
	@printf "$(GREEN)✓ No races detected$(RESET)\n"

# ============================================================================
# Cleaning
# ============================================================================
.PHONY: clean

clean: ## Clean build artifacts
	@printf "$(YELLOW)Cleaning...$(RESET)\n"
	rm -rf $(BUILD_DIR)
	rm -f coverage.out coverage.html
	@printf "$(GREEN)✓ Cleaned$(RESET)\n"

# ============================================================================
# Error Handling
# ============================================================================
%:
	@echo ""
	@echo "$(RED)❌ Unknown target '$@'$(RESET)"
	@echo "   Run $(CYAN)make help$(RESET) to see available targets"
	@echo ""
	@exit 1
