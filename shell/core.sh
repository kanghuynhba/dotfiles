#!/bin/bash
# ============================================================================
# Core Aliases - Basic System Commands
# ============================================================================

# Vi mode for command line editing
set -o vi

# ============================================================================
# MODERN CLI TOOLS
# ============================================================================

# Modern ls replacement (eza)
alias ls='eza --group-directories-first'
alias ll='eza --group-directories-first -la --git'
alias la='eza --group-directories-first -a'
alias lt='eza --tree --level=2'
alias tree='eza --tree'

# Better grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# System management
alias shutdown='systemctl poweroff'
alias reboot='systemctl reboot'

# Documentation
alias forex='tldr'
alias help='tldr'

# File operations
alias open='xdg-open >/dev/null 2>&1'
alias du='du -h'
alias df='df -h'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ============================================================================
# SYSTEM INFORMATION
# ============================================================================

alias sysinfo='neofetch'
alias ports='netstat -tulanp'
alias usage='du -sh * | sort -h'
alias path='echo $PATH | tr ":" "\n"'
