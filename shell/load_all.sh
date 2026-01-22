#!/bin/bash
# ============================================================================
# Master Shell Configuration Loader
# ============================================================================
# Usage: Source this file from your .bashrc or .zshrc
# Example: source ~/Config/dotfiles/shell/load_all.sh
# ============================================================================

SHELL_CONFIG_DIR="${HOME}/Config/dotfiles/shell"

# ============================================================================
# LOAD ORDER
# ============================================================================

# Core system aliases and basic commands
[ -f "${SHELL_CONFIG_DIR}/core.sh" ] && source "${SHELL_CONFIG_DIR}/core.sh"

# Navigation shortcuts
[ -f "${SHELL_CONFIG_DIR}/navigation.sh" ] && source "${SHELL_CONFIG_DIR}/navigation.sh"

# Project management functions
[ -f "${SHELL_CONFIG_DIR}/projects.sh" ] && source "${SHELL_CONFIG_DIR}/projects.sh"

# Tmux session management
[ -f "${SHELL_CONFIG_DIR}/tmux.sh" ] && source "${SHELL_CONFIG_DIR}/tmux.sh"

# Cloud storage functions
[ -f "${SHELL_CONFIG_DIR}/cloud.sh" ] && source "${SHELL_CONFIG_DIR}/cloud.sh"

# General utility functions
[ -f "${SHELL_CONFIG_DIR}/utilities.sh" ] && source "${SHELL_CONFIG_DIR}/utilities.sh"

# Development tool aliases
[ -f "${SHELL_CONFIG_DIR}/dev.sh" ] && source "${SHELL_CONFIG_DIR}/dev.sh"

# Web shortcuts and documentation
[ -f "${SHELL_CONFIG_DIR}/web.sh" ] && source "${SHELL_CONFIG_DIR}/web.sh"

# ============================================================================
# OPTIONAL: CUSTOM LOCAL OVERRIDES
# ============================================================================
# Load local customizations that shouldn't be committed to git
[ -f "${SHELL_CONFIG_DIR}/local.sh" ] && source "${SHELL_CONFIG_DIR}/local.sh"
