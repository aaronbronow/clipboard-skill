# Environment Compatibility Matrix

## Notes
- **Windows Terminal:** Requires OSC 52 enabled in settings.
- **VS Code Terminal:** Requires `terminal.integrated.allowOsc52` (or `terminal.integrated.allowClipboardOperations`) enabled in settings.
- **TMUX:** May require `set -s set-clipboard on` in `.tmux.conf`.

Use `tests/verify.sh` to populate this matrix.

| User Environment | Agent Environment | Agent Mode | Connection | Method | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Windows / VS Code Terminal | PENDING | Default | Local | [OSC 52] Direct stdout | PENDING |
| Windows / VS Code Terminal | PENDING | Default | Local | [Bridge] copy.sh wrapper | PENDING |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/23) | Default | Local | [OSC 52] Direct stdout | FAILURE |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/23) | Default | Local | [OSC 52] Direct /dev/tty | FAILURE |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/23) | Default | Local | [WSL] clip.exe pipe | SUCCESS |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/23) | Default | Local | [WSL] powershell.exe | FAILURE |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/23) | Default | Local | [Bypass] File (.clipboard_bypass) | SUCCESS |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/23) | Default | Local | [Bypass] Named Pipe (.clipboard_pipe) | SUCCESS |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/23) | Default | Local | [Bridge] copy.sh wrapper | SUCCESS |
