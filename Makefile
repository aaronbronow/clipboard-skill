# Agent Bridge Clipboard Makefile

VERSION ?= $(shell jq -r .version gemini-extension.json)
DIST_DIR = dist
SKILL_SRC = .agents/skills/agent-bridge-clipboard
COMMANDS_SRC = commands/abc

.PHONY: all build clean test release

all: build

clean:
	@echo "Cleaning $(DIST_DIR)..."
	rm -rf $(DIST_DIR)

build: clean
	@echo "Building release v$(VERSION)..."
	mkdir -p $(DIST_DIR)/gemini/skills/agent-bridge-clipboard/scripts
	mkdir -p $(DIST_DIR)/gemini/commands/abc
	
	# Copy Skill files
	cp $(SKILL_SRC)/SKILL.md $(DIST_DIR)/gemini/skills/agent-bridge-clipboard/
	cp $(SKILL_SRC)/scripts/copy.sh $(DIST_DIR)/gemini/skills/agent-bridge-clipboard/scripts/
	chmod +x $(DIST_DIR)/gemini/skills/agent-bridge-clipboard/scripts/copy.sh
	
	# Copy CLI Commands
	cp $(COMMANDS_SRC)/*.toml $(DIST_DIR)/gemini/commands/abc/
	
	# Metadata
	echo $(VERSION) > $(DIST_DIR)/VERSION
	cp gemini-extension.json $(DIST_DIR)/
	cp LICENSE $(DIST_DIR)/
	cp GEMINI.md $(DIST_DIR)/

test:
	@echo "Running verification tests..."
	@./tests/verify.sh --clear
	@# Note: verify.sh is interactive, this just ensures it can start and clear.
	@# Full interactive test requires manual execution.

release: test build
	@echo "Release v$(VERSION) prepared in $(DIST_DIR)/"

# Target for downstream projects to consume this repository
# Usage: UPSTREAM_DIR=../path/to/agent-bridge-clipboard make import-skill
import-skill:
	@if [ -z "$(UPSTREAM_DIR)" ]; then echo "Error: UPSTREAM_DIR is not set. Usage: UPSTREAM_DIR=../path/to/agent-bridge-clipboard make import-skill"; exit 1; fi
	@echo "Importing artifacts from $(UPSTREAM_DIR)..."
	@if [ ! -d "$(UPSTREAM_DIR)/dist" ]; then echo "Error: dist directory not found in $(UPSTREAM_DIR). Run 'make build' in the upstream first."; exit 1; fi
	mkdir -p .vendor/agent-bridge-clipboard
	cp -rv $(UPSTREAM_DIR)/dist/* .vendor/agent-bridge-clipboard/
	@echo "Successfully imported to .vendor/agent-bridge-clipboard/"
