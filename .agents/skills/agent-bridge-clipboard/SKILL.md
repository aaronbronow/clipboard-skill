---
name: agent-bridge-clipboard
description: Copies text to the host clipboard using OSC 52 sequences, optimized for SSH and nested terminal environments.
---

# Instructions
When the user wants to copy text, code blocks, or command output to their clipboard:
1. Identify the specific text to be copied.
2. **Policy Awareness (Headless Mode)**:
    - If you detect that you are running in a restricted or headless mode (e.g., `gemini -p`, one-off prompts) and `run_shell_command` is blocked by policy:
    - **Stop** and inform the user: "Clipboard operations are currently restricted by the agent's security policy for one-off prompts. To enable this, please run in interactive mode or use the `--yolo` flag to allow shell execution."
    - Do not attempt the tool call if you know it will fail.
3. **Transparent Communication**: Avoid saying "Successfully copied" without qualification. Instead, use language like "Attempting to copy to your host clipboard..." or "I've sent the clipboard sequence to your terminal...".
4. **Contextual Troubleshooting**:
    - **Sandbox**: If in a Docker sandbox, provide the host listener command: `tail -F .clipboard_bypass > $(tty)`.
    - **VS Code**: Mention that the `terminal.integrated.allowOsc52` setting must be enabled.
    - **SSH**: Remind the user that the bridge works best when an active `SSH_TTY` is present.
    - **Browser**: If the user is in a web-based terminal (like Google Cloud Shell), warn them that browsers often block clipboard writes for security.
5. Use `run_shell_command` to execute `scripts/copy.sh "the text to copy"`.
6. Provide a brief, non-intrusive tip on how they can verify or fix the connection if the paste doesn't work.

## Sandbox Setup (Action Required by User)
If you are running Gemini CLI inside a Docker sandbox, the agent cannot directly access your host clipboard. You must start a listener on your **host machine** (Windows/WSL terminal) to bridge the gap:

### Option A: Raw Stream (Recommended & Verified)
Run this in a separate terminal on your host (WSL/macOS/Linux). 
*Note: Use `tty` to find your active terminal device (e.g., `/dev/pts/22`).*
```bash
# Pipes the raw escape sequences directly to your TTY
tail -F .clipboard_bypass > $(tty)
```

### Option B: Named Pipe (Lowest Latency)
Run this in a separate terminal on your host:
```bash
mkfifo .clipboard_pipe
cat .clipboard_pipe > $(tty)
```

Once a listener is running, the `copy` command will work seamlessly from within the sandbox.
