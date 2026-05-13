# TODO: Clipboard Skill Evolution & Compatibility Testing

## High-Level Plan
- [x] Initial research and OSC 52 fix for SSH environments.
- [x] Create hybrid repository structure (.agents/skills, MCP, OpenAI).
- [x] Integrate with `chezmoi` for dotfile persistence.
- [x] Publish to GitHub (aaronbronow/clipboard-skill).
- [ ] Exhaustive environment compatibility testing.
- [ ] Refine MCP server implementation for non-terminal agents.
- [ ] Clean up `tests/` before final version 1.0 release.

## Environment Compatibility Matrix
Test each combination and update `tests/COMPATIBILITY.md`.

### Host Terminals
- [ ] Windows Terminal
- [ ] iTerm2
- [ ] Ghostty
- [ ] Warp
- [ ] Alacritty
- [ ] Kitty

### Shells
- [ ] Bash
- [ ] Zsh

### Contexts
- [ ] Local Execution
- [ ] Sandbox (e.g., Nix or containerized sandbox)
- [ ] Docker Container
- [ ] SSH to Remote VM (Ubuntu, Arch, etc.)

## Test Scenarios to Verify
1.  **Plain OSC 52:** `printf` to stdout.
2.  **TTY Redirection:** `printf` to `/dev/tty`.
3.  **SSH Redirection:** `printf` to `$SSH_TTY`.
4.  **TMUX Wrapping:** Escaping for tmux pass-through (`\ePtmux;...`).
5.  **Platform Specifics:** `clip.exe` for WSL, `pbcopy` for macOS.

## Environment-Specific Notes
- **Arch Linux:** Test with `base64` flags (some versions differ in line wrapping).
- **Ghostty:** Verify native OSC 52 support levels.
- **Warp:** Check if its block-based rendering interferes with escape sequences.
