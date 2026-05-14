# Project Instructions: Clipboard Skill

## Clipboard Testing Protocol
We use a semi-automated verification process to populate the `tests/COMPATIBILITY.md` matrix.

### Workflow
1. **Execution**: Run `tests/verify.sh`.
2. **Verification**: When prompted, paste your clipboard content (Ctrl+V/Cmd+V). The script will automatically compare it against the expected string to determine SUCCESS/FAILURE.
3. **Reset**: Use `tests/verify.sh --clear` to reset the matrix to its baseline state.

### Compatibility Matrix Rules
- **Positioning**: The Markdown table **must** be the final element in `tests/COMPATIBILITY.md`. The script appends rows to the end of the file.
- **Categorization**: Always use the `[Category] Label` format (e.g., `[OSC 52] Direct stdout` or `[WSL] clip.exe pipe`).

## Current Focus
- **SSH Bypass Testing**: The next priority is testing the `SSH_TTY` bypass logic on remote environments (e.g., `ubuntu-dev`).
- **OSC 52 Troubleshooting**: We've confirmed that standard OSC 52 escapes are captured by the Gemini CLI subshell in local WSL2/xterm-256color environments. Testing via a direct SSH TTY is the next step to verify if we can bypass this capture.
- **WSL Success**: We have confirmed `clip.exe` and `powershell.exe` as successful fallback methods for local WSL2 sessions.

## Environment Notes
- **WSL2 (Ubuntu 24.04)**: Requires `clip.exe` or `powershell.exe` for reliable clipboard access due to subshell output capture.
