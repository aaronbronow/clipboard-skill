# Environment Compatibility Matrix

## Notes
- **Windows Terminal:** Requires OSC 52 enabled in settings.
- **TMUX:** May require `set -s set-clipboard on` in `.tmux.conf`.

Use `tests/verify.sh` to populate this matrix.

| OS | Terminal | Connection | Multiplexer | Method | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Ubuntu 24.04.4 LTS | xterm-256color | Local | None | [OSC 52] Direct stdout | FAILURE |
| Ubuntu 24.04.4 LTS | xterm-256color | Local | None | [OSC 52] Direct /dev/tty | FAILURE |
| Ubuntu 24.04.4 LTS | xterm-256color | Local | None | [WSL] clip.exe pipe | SUCCESS |
| Ubuntu 24.04.4 LTS | xterm-256color | Local | None | [WSL] powershell.exe | FAILURE |
