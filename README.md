# Agent Bridge Clipboard (ABC)

A universal clipboard synchronization bridge and testing suite for AI agents (Gemini, Claude, etc.). This project provides the core transport logic and escape sequence protocols required to bridge isolated agent environments (Docker, SSH, WSL) with the host system clipboard.

## Architecture
- **Upstream (`agent-bridge-clipboard`)**: This repository. Core transport protocols and compatibility drivers.
- **Downstream (`gemini-clipboard-bridge`)**: Implementation and bridge for Gemini CLI skills.

## Project Structure
- `.agents/skills/`: The "Skill" definitions for various agent ecosystems.
  - `agent-bridge-clipboard/`: Universal logic for Gemini CLI.
- `commands/abc/`: CLI command definitions for extension packaging.
- `tests/`: Compatibility matrix and verification scripts.

## Core Logic: `copy.sh`
The heart of the project is the `scripts/copy.sh` bridge. It prioritizes transport methods based on environment detection:
1. **Sandbox Detection**: Identifies if running in a Docker/Container environment.
2. **Native**: `clip.exe` (WSL) or `pbcopy` (macOS).
3. **SSH TTY Bypass**: Writes to `$SSH_TTY` for remote background reliability.
4. **Bypass**: File-based signaling via `.clipboard_bypass` (Mandatory for Docker sandboxes).
5. **Transport**: Direct OSC 52 escape sequences to `/dev/tty` or `stdout`.

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

## Developer Workflow

### Local Development & Testing
To avoid the `gemini extensions install` cycle, use the isolated sandbox target:

1. **Deploy to Sandbox**:
   ```bash
   make deploy-sandbox
   ```
2. **Test in Isolation**:
   ```bash
   cd ../agent-bridge-clipboard-sandbox
   gemini --sandbox
   ```

### Debugging
Enable detailed execution logging by creating a flag file:
```bash
touch .clipboard_debug
tail -f clipboard_debug.log
```

### Sandbox Bypass Setup
When testing in a Docker sandbox, run this in your **host terminal** to bridge the bypass file to your clipboard:
```bash
tail -F .clipboard_bypass > $(tty)
```

## Testing

To run the interactive compatibility verification script:

```bash
CLIENT_OS="Windows" CLIENT_TERM="Windows Terminal" AGENT_MODE="Default" make verify
```

### Headless Testing (Non-Interactive)

To test clipboard transport in non-interactive environments (e.g., within a `run_shell_command` or background task):

1. **Write token to clipboard:**
   ```bash
   make headless METHOD=osc52-ssh
   ```
2. **Validate by pasting the result:**
   ```bash
   make validate TOKEN=<paste_your_clipboard_here>
   ```

## Contributing
- **Adding a Platform**: Update `copy.sh` with the new detection logic and transport method.
- **Porting to a New Agent**: Create a new subfolder in `.agents/skills/` following the ecosystem's manifest format.
- **Updating the Matrix**: Run `./tests/verify.sh` in the target environment and update `tests/COMPATIBILITY.md`.

## License
MIT
