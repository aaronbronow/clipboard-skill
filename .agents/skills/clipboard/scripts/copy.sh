#!/bin/bash
# Gemini Skill Clipboard Bridge
# This script is managed by chezmoi and works across WSL, macOS, and Linux.

# Standard Linux: Use OSC 52 escape sequence for terminal-based copy
# Targeted at $SSH_TTY to ensure it reaches the host terminal over SSH
encoded=$(echo -n "$*" | base64 | tr -d '\n')
printf "\e]52;c;%s\a" "$encoded" > "${SSH_TTY:-/dev/tty}"
