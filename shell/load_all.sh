#!/bin/bash
# ============================================================================
# load_all.sh - Master Shell Configuration Loader
# ============================================================================
# Source this from your .bashrc or .zshrc:
#   source ~/Config/dotfiles/shell/load_all.sh
# ============================================================================

SHELL_CONFIG_DIR="${HOME}/Config/dotfiles/shell"

_load() {
    [ -f "$1" ] && source "$1"
}

# Load order matters — core first, then layered on top
_load "${SHELL_CONFIG_DIR}/core.sh"        # Core aliases & safety nets
_load "${SHELL_CONFIG_DIR}/navigation.sh"  # Directory shortcuts
_load "${SHELL_CONFIG_DIR}/tmux.sh"        # Tmux session engine (needed by projects)
_load "${SHELL_CONFIG_DIR}/projects.sh"    # Project navigation & creation
_load "${SHELL_CONFIG_DIR}/cloud.sh"       # Cloud storage (gdrive, rclone)
_load "${SHELL_CONFIG_DIR}/utilities.sh"   # General helpers
_load "${SHELL_CONFIG_DIR}/dev.sh"         # Dev tools & config editing
_load "${SHELL_CONFIG_DIR}/web.sh"         # Web shortcuts & docs
_load "${SHELL_CONFIG_DIR}/git.sh"         # Git workflow
_load "${SHELL_CONFIG_DIR}/courses.sh"     # Course shortcuts

# Local overrides (not committed to git)
_load "${SHELL_CONFIG_DIR}/local.sh"

unset -f _load
