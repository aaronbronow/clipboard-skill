# Downstream Integration Guide

This guide describes how downstream Gemini CLI extensions (like `gemini-clipboard-bridge`) should consume the artifacts produced by this project.

## Overview
This project provides a "distributable" structure in the `dist/` directory. Downstream projects should import these artifacts into a vendored directory.

---

## Method A: Makefile Import (Recommended for Local Dev)
The most reliable way to sync artifacts locally is to use the provided `import-skill` target. This avoids the complexity of Git submodules while ensuring you get the full `dist/` bundle.

1. **In the downstream project**, run:
   ```bash
   # Point to the directory where you have agent-bridge-clipboard cloned
   UPSTREAM_DIR=../agent-bridge-clipboard make -f ../agent-bridge-clipboard/Makefile import-skill
   ```

2. **What this does**:
   - Creates a `.vendor/agent-bridge-clipboard/` directory in your downstream project.
   - Copies the contents of the upstream `dist/` directory.

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
