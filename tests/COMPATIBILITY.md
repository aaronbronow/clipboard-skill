# Environment Compatibility Matrix

## Notes
- **Windows Terminal:** Requires OSC 52 enabled in settings.
- **TMUX:** May require `set -s set-clipboard on` in `.tmux.conf`.

Use `tests/verify.sh` to populate this matrix.

| User Environment | Agent Environment | Agent Mode | Connection | Method | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/22) | Default | Local | [OSC 52] Direct stdout | FAILURE |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/22) | Default | Local | [OSC 52] Direct /dev/tty | FAILURE |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/22) | Default | Local | [WSL] clip.exe pipe | SUCCESS |
| Windows / Windows Terminal | Ubuntu 24.04.4 LTS (xterm-256color on /dev/pts/22) | Default | Local | [WSL] powershell.exe | FAILURE |
