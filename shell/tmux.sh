#!/bin/bash
# ============================================================================
# tmux.sh - Session Management
# ============================================================================

# ============================================================================
# INTERNAL ENGINE
# ============================================================================

# Create or attach to a tmux session with standard windows (code, exec, git)
# Usage: _tmux_switch <directory> <session-name>
_tmux_switch() {
    local folder="$1"
    local name="$2"

    if ! tmux has-session -t "$name" 2>/dev/null; then
        tmux new-session -d -s "$name" -c "$folder" -n "code"
        tmux new-window  -t "$name"    -c "$folder" -n "exec"
        tmux new-window  -t "$name"    -c "$folder" -n "git"
        tmux send-keys   -t "$name:code" "nvim ." C-m
    fi

    if [[ -z "$TMUX" ]]; then
        tmux attach -t "$name"
    else
        tmux switch-client -t "$name"
    fi
}

# ============================================================================
# SESSION COMMANDS
# ============================================================================

# Fuzzy-find and jump to a project session
tp() {
    local search_dir="$HOME/Work/Projects/projects"
    export PATH="$PATH:$HOME/Config/dotfiles/zsh/plugins/fzf/bin"

    local selected
    selected=$(find "$search_dir" -mindepth 2 -maxdepth 2 -type d | fzf)
    [[ -z "$selected" ]] && return

    local name
    name=$(basename "$selected" | tr . _)
    _tmux_switch "$selected" "$name"
}

# Create or attach to a session for the current directory
# Usage: tnew [session-name]
tnew() {
    local name="${1:-$(basename "$PWD" | tr . _)}"
    _tmux_switch "$PWD" "$name"
}
alias tn='tnew'

# Kill the current tmux session
tkill() {
    local session
    session=$(tmux display-message -p '#S')
    tmux kill-session -t "$session"
    echo "Session '$session' killed."
}

# Rename current session. Usage: trename <new-name>
trename() {
    if [ -z "$1" ]; then
        echo "Usage: trename <new-name>"
        return 1
    fi
    tmux rename-session "$1"
}

# ============================================================================
# ALIASES
# ============================================================================

alias tls='tmux ls'
alias ta='tmux a'
alias tks='tmux kill-server'
