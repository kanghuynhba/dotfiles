#!/bin/bash
# ============================================================================
# dev.sh - Development Tools & Config Editing
# ============================================================================

CONFIG_PATH=~/Config/dotfiles
SHELL_PATH=$CONFIG_PATH/shell

# ============================================================================
# SHELL CONFIG EDITING
# ============================================================================

alias editCore="vim $SHELL_PATH/core.sh"
alias editCourses="vim $SHELL_PATH/courses.sh"
alias editNav="vim $SHELL_PATH/navigation.sh"
alias editProjects="vim $SHELL_PATH/projects.sh"
alias editTmux="vim $SHELL_PATH/tmux.sh"
alias editCloud="vim $SHELL_PATH/cloud.sh"
alias editUtils="vim $SHELL_PATH/utilities.sh"
alias editDev="vim $SHELL_PATH/dev.sh"
alias editWeb="vim $SHELL_PATH/web.sh"
alias editLocal="vim $SHELL_PATH/local.sh"
alias editGit="vim $SHELL_PATH/git.sh"
alias editLoader="vim $SHELL_PATH/load_all.sh"

# ============================================================================
# DOTFILE EDITING
# ============================================================================

alias vimConfig="vim $CONFIG_PATH/vimrc"
alias bashConfig="vim $CONFIG_PATH/bashrc"
alias zshConfig="vim $CONFIG_PATH/zshrc"
alias tmuxConfig="vim $CONFIG_PATH/tmux.conf"
alias gitConfig="vim $CONFIG_PATH/gitconfig"
alias myclirc='vim ~/.myclirc'

# ============================================================================
# RELOAD
# ============================================================================

alias reload='source ~/.bashrc 2>/dev/null || source ~/.zshrc'

# ============================================================================
# QUICK REFERENCE
# ============================================================================

editHelp() {
    cat << 'EOF'
Shell Config Editing Commands
==============================
editCore      Core aliases (eza, grep, safety nets)
editCourses   Course shortcuts (cmu15445, mit6006...)
editNav       Navigation shortcuts (work, uni, personal)
editProjects  Project management functions
editTmux      Tmux session management
editCloud     Cloud storage (gdrive, rclone)
editUtils     Utility functions (up, mcd, extract...)
editDev       Development tools (this file)
editWeb       Web shortcuts & documentation
editLocal     Local machine-specific settings
editGit       Git workflow functions
editLoader    Master loader script

Dotfiles
=========
vimConfig     Vim configuration
bashConfig    Bash configuration
zshConfig     Zsh configuration
tmuxConfig    Tmux configuration
gitConfig     Git configuration

Other
======
reload        Reload shell configuration
editHelp      Show this help
EOF
}

# ============================================================================
# DEVELOPMENT TOOLS
# ============================================================================

# Python
alias py='python3'
alias pip='uv pip'
alias venv='source .venv/bin/activate'
alias mkvenv='uv venv'
alias rmvenv='deactivate 2>/dev/null; rm -rf venv && echo "venv removed"'

envpy() {
    local name="${1:-venv}"
    if [ -d "$name" ]; then
        echo "venv '$name' already exists"
        return 1
    fi
    uv venv "$name"
    source "$name/bin/activate"
    uv pip install pytest ruff mypy
}

# Node
alias ni='npm install'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'

# MySQL
alias mysql='mycli -u root'

# Writing tools
alias writegood='write-good'

# ============================================================================
# MAVEN PROJECT INITIALIZATION
# ============================================================================

# Initialize a Maven quickstart project. Usage: mvnInit <project-name>
mvnInit() {
    if [ -z "$1" ]; then
        echo "Error: Project name required"
        echo "Usage: mvnInit <project-name>"
        return 1
    fi
    mvn archetype:generate \
        -DgroupId=com.hbk."$1" \
        -DartifactId="$1" \
        -DarchetypeArtifactId=maven-archetype-quickstart \
        -DinteractiveMode=false
    echo "Maven project created: $1"
}
