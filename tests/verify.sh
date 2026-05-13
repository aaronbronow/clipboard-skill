#!/bin/bash
# OSC 52 Environment Verifier

echo "--- OSC 52 Compatibility Tester ---"
echo "Machine: $(hostname)"
echo "OS: $(uname -srm)"
echo "TTY: $(tty)"
echo "SSH_TTY: $SSH_TTY"
echo "TERM: $TERM"
echo "-----------------------------------"

test_copy() {
    local label=$1
    local cmd=$2
    echo -n "Testing $label... "
    eval "$cmd"
    read -p "Did 'clipboard' get updated? (y/n): " result
    if [ "$result" == "y" ]; then
        echo "[SUCCESS] $label"
    else
        echo "[FAILURE] $label"
    fi
}

# Test 1: Direct to stdout (likely to fail in Gemini CLI capture)
test_copy "Direct stdout" "printf '\e]52;c;%s\a' '$(echo -n "test-stdout" | base64)'"

# Test 2: Direct to /dev/tty
test_copy "Direct /dev/tty" "printf '\e]52;c;%s\a' '$(echo -n "test-tty" | base64)' > /dev/tty"

# Test 3: Targeted SSH_TTY (if available)
if [ -n "$SSH_TTY" ]; then
    test_copy "Targeted SSH_TTY ($SSH_TTY)" "printf '\e]52;c;%s\a' '$(echo -n "test-ssh-tty" | base64)' > $SSH_TTY"
else
    echo "Skipping SSH_TTY test (not in an SSH session)."
fi

# Test 4: TMUX wrapping (if in tmux)
if [ -n "$TMUX" ]; then
    test_copy "TMUX Wrapped" "printf '\ePtmux;\e\e]52;c;%s\a\e\\' '$(echo -n "test-tmux" | base64)' > ${SSH_TTY:-/dev/tty}"
fi

echo "-----------------------------------"
echo "Verification complete."
