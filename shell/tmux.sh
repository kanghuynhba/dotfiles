#!/bin/bash
# ============================================================================
# tmux.sh - The Session Engine
# ============================================================================

# Internal engine used by other scripts
_tmux_switch() {
    local folder="$1"
    local name="$2"

    if ! tmux has-session -t "$name" 2>/dev/null; then
        tmux new-session -d -s "$name" -c "$folder" -n "code"
        tmux new-window -t "$name" -c "$folder" -n "exec"
        tmux new-window -t "$name" -c "$folder" -n "git"
        tmux send-keys -t "$name:code" "nvim ." C-m
    fi

    [[ -z "$TMUX" ]] && tmux attach -t "$name" || tmux switch-client -t "$name"
}

# The Fuzzy Teleporter
tp() {
    # Use $HOME for reliability
    local search_dir="$HOME/Work/Projects/projects"
    
    # Ensure fzf is in the PATH for the popup
    export PATH="$PATH:$HOME/Config/dotfiles/zsh/plugins/fzf/bin"

    local selected=$(find "$search_dir" -mindepth 2 -maxdepth 2 -type d | fzf)
    [[ -z "$selected" ]] && return
    
    local name=$(basename "$selected" | tr . _)
    _tmux_switch "$selected" "$name"
}

tkill() {
    tmux kill-session -t "$(tmux display-message -p '#S')"
}

alias tls='tmux ls'
