# Project Instructions: Clipboard Skill

## Clipboard Testing Protocol
We use a semi-automated verification process to populate the `tests/COMPATIBILITY.md` matrix.

### Workflow
1. **Execution**: Run `tests/verify.sh`. For accurate reporting, provide client metadata via environment variables:
   ```bash
   CLIENT_OS="Windows" CLIENT_TERM="Windows Terminal" GEMINI_MODE="Default" ./tests/verify.sh
   ```
2. **Verification**: When prompted, paste your clipboard content (Ctrl+V/Cmd+V). The script compares it against the expected string.
3. **Reset**: Use `tests/verify.sh --clear` to reset the matrix to its baseline state.

### Learnings & Patterns
- **SSH Bypass**: We have confirmed that writing directly to the `SSH_TTY` device (e.g., `/dev/pts/0`) is the most reliable way to bypass Gemini CLI subshell capture in remote environments.
- **Reporting**: The compatibility matrix now distinguishes between the **User Environment** (host metadata) and **Agent Environment** (runtime context/TTY).
- **False Positives**: The script now clears the host clipboard at the start of each run to ensure stale data doesn't compromise test results.

### Compatibility Matrix Rules
- **Positioning**: The Markdown table **must** be the final element in `tests/COMPATIBILITY.md`.
- **Columns**: User Environment, Agent Environment, Agent Mode, Connection, Method, Status.

## Current Focus
- **SSH Bypass Testing**: The next priority is testing the `SSH_TTY` bypass logic on remote environments (e.g., `ubuntu-dev`).
- **OSC 52 Troubleshooting**: We've confirmed that standard OSC 52 escapes are captured by the Gemini CLI subshell in local WSL2/xterm-256color environments. Testing via a direct SSH TTY is the next step to verify if we can bypass this capture.
- **WSL Success**: We have confirmed `clip.exe` and `powershell.exe` as successful fallback methods for local WSL2 sessions.

## Environment Notes
- **WSL2 (Ubuntu 24.04)**: Requires `clip.exe` or `powershell.exe` for reliable clipboard access due to subshell output capture.
