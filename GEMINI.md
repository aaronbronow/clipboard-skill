# Project Instructions: Clipboard Skill

## Clipboard Testing Protocol
The verification process for the `tests/COMPATIBILITY.md` matrix is handled **strictly** by the `tests/verify.sh` script.

### Protocol Rules
- **Interactive Requirement**: The script is interactive and **must** be run in a live, interactive subshell (e.g., `gemini --shell` or a direct terminal). It will exit immediately if executed as a non-interactive command (especially in Sandbox mode).
- **Mandatory Metadata**: You MUST provide client metadata via environment variables for accurate matrix reporting.
- **Workflow**:
  ```bash
  CLIENT_OS="Windows" CLIENT_TERM="Windows Terminal" GEMINI_MODE="Default" ./tests/verify.sh
  ```
- **Manual testing bypass**: Do NOT attempt to run manual tests or individual commands for the purpose of updating the matrix. Use the script to ensure consistent logging.
- **Verification**: When prompted by the script, paste your clipboard content (Ctrl+V/Cmd+V) to verify the result.
- **Reset**: Use `tests/verify.sh --clear` to reset the matrix to its baseline state.

### Learnings & Patterns
- **SSH Bypass**: We have confirmed that writing directly to the `SSH_TTY` device (e.g., `/dev/pts/0`) is the most reliable way to bypass Gemini CLI subshell capture in remote environments.
- **Reporting**: The compatibility matrix now distinguishes between the **User Environment** (host metadata) and **Agent Environment** (runtime context/TTY).
- **False Positives**: The script now performs a robust clipboard clear before every test case. In WSL2 environments where OSC 52 is captured, automated clearing must use fallbacks like `clip.exe` to prevent stale data from compromising results.

### Compatibility Matrix Rules
- **Positioning**: The Markdown table **must** be the final element in `tests/COMPATIBILITY.md`.
- **Columns**: User Environment, Agent Environment, Agent Mode, Connection, Method, Status.

## Current Focus
- **SSH Bypass Testing**: The next priority is testing the `SSH_TTY` bypass logic on remote environments (e.g., `ubuntu-dev`).
- **OSC 52 Troubleshooting**: We've confirmed that standard OSC 52 escapes are captured by the Gemini CLI subshell in local WSL2/xterm-256color environments. Testing via a direct SSH TTY is the next step to verify if we can bypass this capture.
- **WSL Success**: We have confirmed `clip.exe` and `powershell.exe` as successful fallback methods for local WSL2 sessions.

## Sandboxing on ARM/WSL2
If you encounter an `Exec format error` when running `gemini --sandbox` on an ARM64 host (like Surface Pro 9/11 or Apple Silicon), it is because the official sandbox image is `amd64`.

### Solution: Build a local ARM image
1. **Build the image**:
   ```bash
   docker build -t gemini-sandbox-arm64 -f .gemini/sandbox.Dockerfile .
   ```
2. **Configure Gemini to use it**:
   Add this to your `.env` or run it in your shell:
   ```bash
   export GEMINI_SANDBOX_IMAGE="gemini-sandbox-arm64"
   ```

## Sandbox Clipboard Limitations & Bypasses
Direct clipboard access from the Docker sandbox is restricted by environment isolation and the headless nature of the container.

### Findings
- **Tooling Failure**: Traditional tools like `xsel` and `wl-clipboard` fail because the sandbox lacks an X11 or Wayland display server.
- **OSC 52 Capture**: Standard OSC 52 escape sequences sent to `stdout` are captured and neutralized by the Gemini CLI subshell buffer, preventing them from reaching the host terminal.
- **TTY Absence**: Writing to `/dev/tty` fails within the sandbox as no TTY is allocated for the agent's shell.

### The "File-Based Bypass" Strategy
To bridge the sandbox and host clipboard, use the `.clipboard_bypass` file as a signaling channel.
1. **Agent Action**: The agent writes an OSC 52 sequence to the `.clipboard_bypass` file in the project root.
2. **Host Listener**: A separate process on the host (WSL/Windows) monitors this file and echoes its content to a real TTY.
   ```bash
   # Host-side listener example (run on host)
   tail -F .clipboard_bypass > $(tty)
   ```

### Network-Based Sandbox Bypasses (Proposed)
For real-time synchronization without disk I/O, several networking strategies are viable via `host.docker.internal`:

- **Named Pipe (FIFO)**: Create a `mkfifo .clipboard_pipe` in the workspace. The host runs a listener (`cat .clipboard_pipe > /dev/tty`), and the agent writes directly to the pipe. This provides a zero-config, low-latency stream.
- **SSH Pipe**: Use `ssh host.docker.internal "clip.exe"` (or `pbcopy`). Requires SSH key orchestration but provides the most secure and native-feeling transport.
- **HTTP Socket**: A tiny listener on the host (e.g., via `nc` or a simple Go/Node server) accepts `POST` requests from the agent via `curl`.

## Environment Notes
- **WSL2 (Ubuntu 24.04)**: Requires `clip.exe` or `powershell.exe` for reliable clipboard access due to subshell output capture.
- **ARM64 Compatibility**: Use the local Dockerfile in `.gemini/` to build a native sandbox image. This image includes `xsel` and `wl-clipboard` to support built-in clipboard commands like `/copy`.
