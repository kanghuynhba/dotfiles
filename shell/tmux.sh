#!/bin/bash
# ============================================================================
# Tmux Session Management
# ============================================================================

# ============================================================================
# SESSION INITIALIZATION
# ============================================================================

tmuxInit() {
    local project_name="${1:-default}"
    
    # Create sessions only if they don't exist
    tmux has-session -t "code-$project_name" 2>/dev/null || \
        tmux new-session -d -s "code-$project_name"
    
    tmux has-session -t "exec-$project_name" 2>/dev/null || \
        tmux new-session -d -s "exec-$project_name"
    
    tmux has-session -t "git-$project_name" 2>/dev/null || \
        tmux new-session -d -s "git-$project_name"
    
    # Attach to code session
    tmux attach-session -t "code-$project_name"
}

# ============================================================================
# SESSION CLEANUP
# ============================================================================

tmuxKill() {
    local project_name="${1:-default}"
    tmux kill-session -t "code-$project_name" 2>/dev/null
    tmux kill-session -t "exec-$project_name" 2>/dev/null
    tmux kill-session -t "git-$project_name" 2>/dev/null
    echo "Killed all sessions for: $project_name"
}

# ============================================================================
# QUICK ALIASES
# ============================================================================

alias tls='tmux ls'
alias ta='tmux attach-session -t'
alias tn='tmux new-session -s'
