# Agent Bridge Clipboard Makefile

VERSION ?= $(shell jq -r .version gemini-extension.json)
DIST_DIR = dist
SKILL_SRC = .agents/skills/agent-bridge-clipboard
COMMANDS_SRC = commands/abc

.PHONY: all build clean test release verify headless validate matrix-clear

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

# --- Testing & Verification ---

test: verify

verify:
	@if [ -z "$$CLIENT_OS" ] || [ -z "$$CLIENT_TERM" ]; then \
		echo "TIP: Set CLIENT_OS and CLIENT_TERM for accurate matrix reporting."; \
		echo "     Example: CLIENT_OS=\"macOS\" CLIENT_TERM=\"iTerm2\" make verify"; \
		echo ""; \
	fi
	./tests/verify.sh

headless:
	./tests/verify.sh --headless --method=$(or $(METHOD),bridge)

validate:
	@if [ -z "$(TOKEN)" ]; then echo "Error: Use 'make validate TOKEN=<token>'"; exit 1; fi
	./tests/verify.sh --validate=$(TOKEN)

matrix-clear:
	./tests/verify.sh --clear

release: matrix-clear build
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
