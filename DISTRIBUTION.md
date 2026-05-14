# Downstream Integration Guide

This guide describes how downstream Gemini CLI extensions (like `gemini-clipboard-bridge`) should consume the artifacts produced by this project.

## Overview
This project provides a "distributable" structure in the `dist/` directory (and as a `.tar.gz` in GitHub Releases). Downstream projects should avoid manual modification of the transport logic and instead "link" or "import" these files.

---

## Method A: Git Submodules (Recommended for Development)
If you are actively developing both the upstream and downstream projects, use a submodule to maintain a live link.

1. **Add the submodule**:
   ```bash
   git submodule add https://github.com/aaronbronow/agent-bridge-clipboard.git .vendor/agent-bridge-clipboard
   ```

2. **Configure Gemini Skill**:
   Point your `gemini-extension.json` or skill symlink to the submodule path:
   ```json
   {
     "skills": ["./.vendor/agent-bridge-clipboard/dist/gemini/skills/agent-bridge-clipboard"]
   }
   ```

3. **Automation**:
   Add a `make update-vendor` target to your downstream Makefile:
   ```makefile
   update-vendor:
   	git submodule update --remote --merge
   	cd .vendor/agent-bridge-clipboard && make build
   ```

---

## Method B: GitHub Release Download (Recommended for CI/CD)
For stable, versioned production usage, download the release asset during your build or setup phase.

1. **Download the latest release**:
   ```bash
   # Using GitHub CLI
   gh release download --repo aaronbronow/agent-bridge-clipboard --pattern "*.tar.gz" --output upstream.tar.gz
   tar -xzvf upstream.tar.gz -C .vendor/clipboard
   ```

2. **Integration**:
   Your extension should then reference the extracted files in `.vendor/clipboard/gemini/...`.

---

## Method C: Direct File Sync (Simplest)
If you prefer zero dependencies, you can manually copy the `dist/` contents into your repo.

1. Create a `vendor/` or `assets/` folder.
2. Copy `dist/gemini/skills/agent-bridge-clipboard` to `your-repo/skills/agent-bridge-clipboard`.
3. Copy `dist/gemini/commands/abc` to `your-repo/commands/abc`.

*Note: This makes it harder to track upstream updates and fixes.*

---

## Path Normalization Rules
When importing, ensure your `gemini-extension.json` correctly maps the skill paths. The `copy.sh` script inside the skill expects to be executed relative to the skill's root or via an absolute path if registered globally.

### Example `gemini-extension.json` for Downstream:
```json
{
  "name": "my-custom-bridge",
  "skills": ["./vendor/clipboard/gemini/skills/agent-bridge-clipboard"],
  "commands": ["./vendor/clipboard/gemini/commands/abc"]
}
```

## Verification
After importing, always run the upstream verification script from within your downstream environment to ensure the transport is still working:
```bash
bash ./vendor/clipboard/tests/verify.sh
```
