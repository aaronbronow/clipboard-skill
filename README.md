# Agent Bridge Clipboard

Universal clipboard synchronization for AI agent ecosystems.

This project provides the core transport logic and cross-environment compatibility (SSH, WSL, Native) required to bridge AI agent sandboxes and subshells with the host clipboard.

## Architecture

- **Upstream (`agent-bridge-clipboard`)**: This repository. Core transport protocols and compatibility drivers.
- **Downstream (`gemini-clipboard-bridge`)**: Implementation and bridge for Gemini CLI skills.

## Features

- **Multi-Transport Support**: OSC 52, Native (clip.exe, pbcopy), and SSH TTY bypass.
- **Sandbox Bypasses**: File-based and FIFO (Named Pipe) signaling for isolated environments (e.g., Docker/Gemini Sandbox).
- **Auto-Detection**: `copy.sh` automatically selects the most reliable transport for the current environment.

## Compatibility Matrix

This summary grid tracks the verified status of the `copy.sh` bridge across various user environments. Detailed test logs are maintained in [tests/COMPATIBILITY.md](tests/COMPATIBILITY.md).

| User Environment | Local (WSL/Native) | Remote (SSH) | Sandbox (Docker) |
| :--- | :---: | :---: | :---: |
| 🪟 **Windows Terminal** | ✅ | 🚧 | ✅ |
| 💻 **VS Code Terminal** | ⏳ | ⏳ | ⏳ |
| 🪟 **PowerShell** | ⏳ | ⏳ | ⏳ |
| 🍎 **iTerm2** | ⏳ | ⏳ | ⏳ |
| 🍎/🐧 **Alacritty** | ⏳ | ⏳ | ⏳ |
| 🍎/🐧 **Ghostty** | ⏳ | ⏳ | ⏳ |

**Legend:**
- ✅ : Fully Supported
- 🚧 : Testing in Progress
- ⏳ : TBD / Not yet verified
- ❌ : Known Issue / Unsupported

## Testing

To run the interactive compatibility verification script:

```bash
CLIENT_OS="Windows" CLIENT_TERM="Windows Terminal" AGENT_MODE="Default" ./tests/verify.sh
```
