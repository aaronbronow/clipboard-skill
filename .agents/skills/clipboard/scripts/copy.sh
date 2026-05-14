#!/bin/bash
# Gemini Skill Clipboard Bridge
# This script works across WSL, macOS, and Linux, including sandboxed environments.

encoded=$(echo -n "$*" | base64 | tr -d '\n')
osc52_sequence=$(printf "\e]52;c;%s\a" "$encoded")

# 1. Primary: Direct TTY write (works in SSH and local shells)
if [ -w "/dev/tty" ]; then
    printf "%s" "$osc52_sequence" > /dev/tty
    exit 0
fi

# 2. Fallback: Sandbox Bypass Channels
# Write to a regular file using atomic move to ensure listeners (like tail -F) detect it
printf "%s" "$osc52_sequence" > .clipboard_bypass.tmp
mv .clipboard_bypass.tmp .clipboard_bypass

# Write to a FIFO if it exists (for low-latency listeners)
if [ -p ".clipboard_pipe" ]; then
    printf "%s" "$osc52_sequence" > .clipboard_pipe &
fi

# 3. Last Resort: Stdout (likely captured by agent, but good for local debugging)
printf "%s" "$osc52_sequence"
