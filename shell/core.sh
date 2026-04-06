#!/bin/bash
# ============================================================================
# core.sh - Core Aliases & System Commands
# ============================================================================

# Vi keybindings in the shell
set -o vi

# ============================================================================
# MODERN CLI TOOLS
# ============================================================================

# eza (modern ls replacement)
alias ls='eza --group-directories-first'
alias ll='eza --group-directories-first -la --git'
alias la='eza --group-directories-first -a'
alias lt='eza --tree --level=2'
alias tree='eza --tree'

# Better grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ============================================================================
# FILE OPERATIONS
# ============================================================================

alias du='du -h'
alias df='df -h'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ============================================================================
# SYSTEM
# ============================================================================

alias shutdown='systemctl poweroff'
alias reboot='systemctl reboot'
alias path='echo $PATH | tr ":" "\n"'
alias sysinfo='neofetch'

# ============================================================================
# DOCUMENTATION
# ============================================================================

alias forex='tldr'
alias help='tldr'
