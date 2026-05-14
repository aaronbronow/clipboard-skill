# Roadmap: Universal Agent Clipboard

This project serves as the centralized development hub and benchmarking suite for cross-environment clipboard synchronization. 

## Vision
To provide a seamless, persistent, and portable clipboard history that allows various AI agents (Gemini, Claude, Copilot) to interact with a user's physical host clipboard and shared session history across SSH, WSL, and native environments.

---

## Phase 1: Transport (Completed)
**Goal:** Establish a reliable "Write" path from a remote AI subshell to a local host.
- [x] Implement OSC 52 escape sequence transport.
- [x] Solve the "Agent Buffer Interception" via TTY Bypassing.
- [x] Create the first port: `agent-bridge-clipboard`.
- [x] Automate release process via `Makefile` (`make build`).
- [x] Automate environment orchestration via `chezmoi`.

## Phase 2: Session History & Logging (Near Term)
**Goal:** Create a persistent record of agent "copy" actions.
- [ ] Modify the bridge logic to append all copied text to a local `~/.cache/agent_clipboard.yaml`.
- [ ] Implement a `clipboard-history` tool to list and retrieve previous clips.
- [ ] Add metadata to clips (Timestamp, Agent Name, Source Host).

## Phase 3: The Universal Agent Portfolio (Mid Term)
**Goal:** Port the bridge logic to other AI ecosystems.
- [ ] **Claude Port:** `claude-clipboard-bridge` (MCP Server implementation).
- [ ] **Copilot Port:** `copilot-clipboard-bridge` (VS Code Extension hook).
- [ ] **OpenAI Port:** Custom Action / GPT implementation.

## Phase 4: Persistence & Sync (Long Term)
**Goal:** Synchronize history across the entire developer loop.
- [ ] Use an MCP (Model Context Protocol) server to share history between local and remote agents.
- [ ] Encrypted git-backed sync for `agent_clipboard.yaml`.
- [ ] Secure "Read" access: Allow agents to request the current host clipboard content with user approval.

---

## Technical Debt & Verification (Current)

### Environment Compatibility Matrix
Test each combination and update `tests/COMPATIBILITY.md`.

#### Host Terminals
- [ ] Windows Terminal
- [ ] iTerm2
- [ ] Ghostty
- [ ] Warp
- [ ] Alacritty
- [ ] Kitty

#### Shells
- [ ] Bash
- [ ] Zsh

#### Contexts
- [x] Local Execution
- [x] Default Gemini CLI Sandbox (AMD64)
- [ ] Custom ARM64 Sandbox (Built from `.gemini/sandbox.Dockerfile`)
- [ ] Sandbox with `xsel` / `wl-clipboard` (Containerized)
- [x] Sandbox with File-Based Bypass (`.clipboard_bypass` via host listener)
- [x] Sandbox with Named Pipe (FIFO) Bypass (`mkfifo .clipboard_pipe`)
- [ ] Sandbox with SSH Pipe (`ssh host.docker.internal`)
- [ ] Sandbox with HTTP Socket listener (`curl` to host port)
- [ ] SSH to Remote VM (Ubuntu, Arch, etc.)
- [ ] Nested: SSH within a Sandbox Container

### Test Scenarios to Verify
1.  **Plain OSC 52:** `printf` to stdout.
2.  **TTY Redirection:** `printf` to `/dev/tty`.
3.  **SSH Redirection:** `printf` to `$SSH_TTY`.
4.  **TMUX Wrapping:** Escaping for tmux pass-through (`\ePtmux;...`).
5.  **Platform Specifics:** `clip.exe` for WSL, `pbcopy` for macOS.

### Environment-Specific Notes
- **Arch Linux:** Test with `base64` flags (some versions differ in line wrapping).
- **Ghostty:** Verify native OSC 52 support levels.
- **Warp:** Check if its block-based rendering interferes with escape sequences.
