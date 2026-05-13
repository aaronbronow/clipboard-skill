# Environment Compatibility Matrix

Use `tests/verify.sh` to populate this matrix.

| OS | Terminal | Connection | Multiplexer | Method | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Ubuntu 22.04 | Windows Terminal | SSH | None | SSH_TTY | SUCCESS |
| Ubuntu 22.04 | Windows Terminal | SSH | None | Direct stdout | FAILURE |
| Ubuntu 22.04 | Windows Terminal | SSH | None | /dev/tty | FAILURE |
| Arch Linux | Alacritty | Local | tmux | TMUX Wrap | ? |
| macOS | iTerm2 | Local | None | /dev/tty | ? |

## Notes
- **Windows Terminal:** Requires OSC 52 enabled in settings.
- **TMUX:** May require `set -s set-clipboard on` in `.tmux.conf`.
