#!/bin/bash
# ============================================================================
# Development Tool Aliases & Functions
# ============================================================================

# ============================================================================
# CONFIGURATION FILE EDITING
# ============================================================================

CONFIG_PATH=~/Config/dotfiles
SHELL_PATH=$CONFIG_PATH/shell

# Shell configuration files (modular)
alias editCore="vim $SHELL_PATH/core.sh"
alias editNav="vim $SHELL_PATH/navigation.sh"
alias editProjects="vim $SHELL_PATH/projects.sh"
alias editTmux="vim $SHELL_PATH/tmux.sh"
alias editCloud="vim $SHELL_PATH/cloud.sh"
alias editUtils="vim $SHELL_PATH/utilities.sh"
alias editDev="vim $SHELL_PATH/dev.sh"
alias editWeb="vim $SHELL_PATH/web.sh"
alias editLocal="vim $SHELL_PATH/local.sh"
alias editLoader="vim $SHELL_PATH/load_all.sh"

# Legacy aliases for compatibility
alias aliasConfig="vim $SHELL_PATH/02_navigation.sh"
alias funcConfig="vim $SHELL_PATH/06_utilities.sh"

# Other dotfiles
alias vimConfig="vim $CONFIG_PATH/vimrc"
alias bashConfig="vim $CONFIG_PATH/bashrc"
alias zshConfig="vim $CONFIG_PATH/zshrc"
alias tmuxConfig="vim $CONFIG_PATH/tmux.conf"
alias gitConfig="vim $CONFIG_PATH/gitconfig"

# Reload shell configuration
alias reload='source ~/.bashrc 2>/dev/null || source ~/.zshrc'

# Quick reference: show all edit commands
alias editHelp='cat << EOF
Shell Configuration Editing Commands:
=====================================
editCore      - Core system aliases (eza, grep, safety nets)
editNav       - Navigation shortcuts (work, uni, personal)
editProjects  - Project management functions
editTmux      - Tmux session management
editCloud     - Cloud storage (gdrive, rclone)
editUtils     - Utility functions (up, mcd, extract)
editDev       - Development tools (this file)
editWeb       - Web shortcuts & documentation
editLocal     - Local machine-specific settings
editLoader    - Master loader script

Other Dotfiles:
===============
vimConfig     - Vim configuration
bashConfig    - Bash configuration
zshConfig     - Zsh configuration
tmuxConfig    - Tmux configuration
gitConfig     - Git configuration

Reload:
=======
reload        - Reload shell configuration
EOF
'

# ============================================================================
# DEVELOPMENT TOOLS
# ============================================================================

# MySQL
alias mysql='mysql --default-character-set=utf8mb4 -u root -p'

# Python virtual environments
alias venv='source venv/bin/activate'
alias mkvenv='python3 -m venv venv'

# Debugger
alias gdb='pwndbg-lldb'

# Writing tools
alias writegood='write-good'

# ============================================================================
# MAVEN PROJECT INITIALIZATION
# ============================================================================

mvnInit() {
    if [ -z "$1" ]; then
        echo "Error: Project name required"
        echo "Usage: mvnInit project-name"
        return 1
    fi
    
    mvn archetype:generate \
        -DgroupId=com.hbk.$1 \
        -DartifactId=$1 \
        -DarchetypeArtifactId=maven-archetype-quickstart \
        -DinteractiveMode=false
    
    echo "Maven project created: $1"
}

























































