#!/bin/bash
# ============================================================================
# Shell Aliases & Functions - Optimized for New Directory Structure
# ============================================================================

# Vi mode for command line editing
set -o vi

# ============================================================================
# MODERN CLI TOOLS
# ============================================================================

# Modern ls replacement (eza)
alias ls='eza --group-directories-first '
alias ll='eza --group-directories-first -la --git '
alias la='eza --group-directories-first -a '
alias lt='eza --tree --level=2 '
alias tree='eza --tree '

# Better grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# System aliases
alias shutdown="systemctl poweroff"
alias reboot="systemctl reboot"

# TLDR pages (better man pages)
alias forex="tldr"
alias help="tldr"

# Open files with default application
alias open="xdg-open >/dev/null 2>&1"

# Disk usage
alias du='du -h'
alias df='df -h'

# Safety nets
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ============================================================================
# NAVIGATION ALIASES (New Structure)
# ============================================================================

# Quick directory jumps
alias home="cd ~"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias -- -="cd -"

# Work directories
alias work="cd ~/Work"
alias career="cd ~/Work/Career"
alias learn="cd ~/Work/Learning"

# Projects
alias projects="cd ~/Work/Projects"
alias lc="cd ~/Work/Projects/LeetCode/patterns/src"
alias leetcode="cd ~/Work/Projects/LeetCode/patterns/src && tmuxInit leetcode"

# University
alias uni="cd ~/University/DUT"
alias dut="cd ~/University/DUT"
alias courses="cd ~/University/DUT/Courses"

# Personal
alias personal="cd ~/Personal"
alias docs="cd ~/Personal/Documents"
alias books="cd ~/Personal/Media/Books"

# Config
alias config="cd ~/Config"
alias dotfiles="cd ~/Config/dotfiles"

# Workspace
alias workspace="cd ~/Workspace"
alias test="cd ~/Workspace/tests"

# ============================================================================
# PROJECT NAVIGATION WITH TMUX
# ============================================================================

# Base project path
PROJECT_PATH=~/Work/Projects/projects

# Language-specific project navigation
cppProject() {
    cd "$PROJECT_PATH/cpp-projects/$1"
    [ -n "$1" ] && tmuxInit "$1"
}

javaProject() {
    cd "$PROJECT_PATH/java-projects/$1"
    [ -n "$1" ] && tmuxInit "$1"
}

pyProject() {
    cd "$PROJECT_PATH/py-projects/$1"
    [ -n "$1" ] && tmuxInit "$1"
}

rustProject() {
    cd "$PROJECT_PATH/rust-projects/$1"
    [ -n "$1" ] && tmuxInit "$1"
}

swiftProject() {
    cd "$PROJECT_PATH/swift-projects/$1"
    [ -n "$1" ] && tmuxInit "$1"
}

# Quick access to specific projects
alias bustub="cd $PROJECT_PATH/cpp-projects/bustub-private"

# ============================================================================
# TMUX SESSION MANAGEMENT
# ============================================================================

# Initialize tmux sessions for development
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

# Kill all tmux sessions for a project
tmuxKill() {
    local project_name="${1:-default}"
    tmux kill-session -t "code-$project_name" 2>/dev/null
    tmux kill-session -t "exec-$project_name" 2>/dev/null
    tmux kill-session -t "git-$project_name" 2>/dev/null
    echo "✅ Killed all sessions for: $project_name"
}

# List all tmux sessions
alias tls="tmux ls"
alias ta="tmux attach-session -t"
alias tn="tmux new-session -s"

# ============================================================================
# GOOGLE DRIVE MOUNT/UNMOUNT
# ============================================================================

gdrive() {
    # Check if mount point exists
    if [ ! -d "$HOME/gdrive" ]; then
        echo "📁 Creating mount point: ~/gdrive"
        mkdir -p "$HOME/gdrive"
    fi

    # Check if already mounted
    if mountpoint -q "$HOME/gdrive"; then
        echo "✅ GDrive is already mounted"
        return 0
    fi

    echo "⏳ Mounting gdrive to ~/gdrive..."
    nohup rclone mount gdrive: ~/gdrive \
        --vfs-cache-mode writes \
        --vfs-cache-max-age 72h \
        --vfs-read-chunk-size 128M \
        --vfs-read-chunk-size-limit off \
        > ~/gdrive_mount.log 2>&1 &
    
    sleep 2
    
    if mountpoint -q "$HOME/gdrive"; then
        echo "✅ GDrive mounted successfully"
    else
        echo "❌ Mount failed. Check: ~/gdrive_mount.log"
        tail -n 10 ~/gdrive_mount.log
    fi
}

ungdrive() {
    if ! mountpoint -q "$HOME/gdrive"; then
        echo "⚠️  GDrive is not mounted"
        return 1
    fi
    
    echo "⏳ Unmounting ~/gdrive..."
    fusermount -u ~/gdrive
    
    if [ $? -eq 0 ]; then
        echo "✅ GDrive unmounted successfully"
    else
        echo "❌ Unmount failed"
    fi
}

# Check gdrive status
gstatus() {
    if mountpoint -q "$HOME/gdrive"; then
        echo "✅ GDrive is mounted"
        df -h ~/gdrive | tail -1
    else
        echo "❌ GDrive is not mounted"
    fi
}

# ============================================================================
# CONFIG FILE EDITING
# ============================================================================

CONFIG_PATH=~/Config/dotfiles

# Edit configuration files
alias aliasConfig="vim $CONFIG_PATH/shell/aliases.sh"
alias funcConfig="vim $CONFIG_PATH/shell/functions.sh"
alias vimConfig="vim $CONFIG_PATH/vimrc"
alias bashConfig="vim $CONFIG_PATH/bashrc"
alias zshConfig="vim $CONFIG_PATH/zshrc"
alias tmuxConfig="vim $CONFIG_PATH/tmux.conf"
alias gitConfig="vim $CONFIG_PATH/gitconfig"

# Reload shell configuration
alias reload="source ~/.bashrc 2>/dev/null || source ~/.zshrc"

# ============================================================================
# DEVELOPMENT TOOLS
# ============================================================================

# MySQL
alias mysql="mysql --default-character-set=utf8mb4 -u root -p"

# Python virtual environments
alias venv="source venv/bin/activate"
alias mkvenv="python3 -m venv venv"

# Debugger
alias gdb="pwndbg-lldb"

# Writing tools
alias writegood="write-good"

# Maven project initialization
mvnInit() {
    if [ -z "$1" ]; then
        echo "❌ Error: Project name required"
        echo "Usage: mvnInit project-name"
        return 1
    fi
    
    mvn archetype:generate \
        -DgroupId=com.hbk.$1 \
        -DartifactId=$1 \
        -DarchetypeArtifactId=maven-archetype-quickstart \
        -DinteractiveMode=false
    
    echo "✅ Maven project created: $1"
}

# ============================================================================
# USEFUL FUNCTIONS
# ============================================================================

# Go up [n] directories
up() {
    local count=${1:-1}
    
    if ! [[ $count =~ ^[0-9]+$ ]]; then
        echo "❌ Error: Argument must be a number"
        return 1
    fi

    local path=""
    for ((i=0; i<count; i++)); do
        path="../$path"
    done
    
    cd $path
}

# Create directory and cd into it
mcd() {
    if [ -z "$1" ]; then
        echo "❌ Error: Directory name required"
        return 1
    fi
    
    mkdir -p "$1" && cd "$1"
    echo "✅ Created and entered: $1"
}

# Jump to directory containing file
jump() {
    if [ -z "$1" ]; then
        echo "❌ Error: File path required"
        return 1
    fi
    
    cd "$(dirname "$1")"
}

# Find files by name
findfile() {
    find . -iname "*$1*" 2>/dev/null
}

# Find text in files
findtext() {
    grep -r -i "$1" . 2>/dev/null
}

# Extract any archive
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <archive>"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "❌ Error: File not found"
        return 1
    fi
    
    case "$1" in
        *.tar.bz2) tar xjf "$1" ;;
        *.tar.gz) tar xzf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.rar) unrar x "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar xf "$1" ;;
        *.tbz2) tar xjf "$1" ;;
        *.tgz) tar xzf "$1" ;;
        *.zip) unzip "$1" ;;
        *.Z) uncompress "$1" ;;
        *.7z) 7z x "$1" ;;
        *) echo "❌ Unknown archive format" ;;
    esac
}

# ============================================================================
# WEB SHORTCUTS
# ============================================================================

# Google search from terminal
google() {
    if [ -z "$*" ]; then
        open "https://www.google.com"
    else
        local query=$(echo "$*" | sed 's/ /+/g')
        open "https://www.google.com/search?q=$query"
    fi
}

# GitHub shortcuts
alias github="open https://github.com/kanghuynhba"
alias myrepos="open https://github.com/kanghuynhba?tab=repositories"

# LeetCode
alias leetweb="open https://leetcode.com/problemset/"

# Course platforms
alias bilibili="open https://space.bilibili.com/400647031/lists/389026?type=series"
alias coursera="open https://www.coursera.org"
alias udemy="open https://www.udemy.com"

# Documentation
alias javadoc="open https://docs.oracle.com/en/java/javase/17/docs/api/"
alias cppreference="open https://en.cppreference.com"
alias pythondoc="open https://docs.python.org/3/"
alias rustdoc="open https://doc.rust-lang.org/std/"

# Mirror a website
alias mirrorsite='wget -m -k -K -E -e robots=off'

# ============================================================================
# SYSTEM INFORMATION
# ============================================================================

# System info
alias sysinfo='neofetch'
alias ports='netstat -tulanp'

# Disk usage of current directory
alias usage='du -sh * | sort -h'

# Show PATH in readable format
alias path='echo $PATH | tr ":" "\n"'

# ============================================================================
# CLIPBOARD UTILITIES
# ============================================================================

# Detect OS and set copy/paste aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    alias copy='pbcopy'
    alias paste='pbpaste'
elif grep -q Microsoft /proc/version 2>/dev/null; then
    # WSL (Windows Subsystem for Linux)
    alias copy='clip.exe'
    alias paste='powershell.exe -command "Get-Clipboard"'
else
    # Linux (X11/Wayland)
    if command -v xclip &> /dev/null; then
        alias copy='xclip -selection clipboard'
        alias paste='xclip -selection clipboard -o'
    elif command -v wl-copy &> /dev/null; then
        alias copy='wl-copy'
        alias paste='wl-paste'
    fi
fi

# Copy current working directory
alias cpwd='pwd | copy && echo "✅ Copied: $(pwd)"'

# Copy file contents
copyfile() {
    if [ -z "$1" ]; then
        echo "❌ Error: File required"
        return 1
    fi
    
    cat "$1" | copy
    echo "✅ Copied contents of: $1"
}

# ============================================================================
# PRODUCTIVITY HELPERS
# ============================================================================

# Show top 10 commands
top10(){
    history | awk "{print \$2}" | sort | uniq -c | sort -rn | head -10
}

# Weather
weather() {
    curl "wttr.in/${1:-DaNang}?format=3"
}

# Quick notes
note() {
    local note_file="$HOME/Personal/Documents/quick-notes.md"
    
    if [ -z "$1" ]; then
        # Show notes
        cat "$note_file" 2>/dev/null || echo "No notes yet"
    else
        # Add note with timestamp
        echo "$(date '+%Y-%m-%d %H:%M') - $*" >> "$note_file"
        echo "✅ Note added"
    fi
}

# Timer
timer() {
    local seconds=${1:-60}
    echo "⏱️  Timer set for $seconds seconds"
    sleep $seconds
    echo "⏰ Time's up!"
    # Play sound if available
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || \
    echo -e "\a"
}

# ============================================================================
# DEVELOPMENT WORKFLOW
# ============================================================================

# Start new project
newproject() {
    local name=$1
    local type=${2:-"general"}
    
    if [ -z "$name" ]; then
        echo "❌ Error: Project name required"
        echo "Usage: newproject <name> [cpp|java|python|rust]"
        return 1
    fi
    
    case "$type" in
        cpp|c++)
            mkdir -p "$PROJECT_PATH/cpp-projects/$name"/{src,include,tests}
            echo "✅ C++ project created: $name"
            ;;
        java)
            cd "$PROJECT_PATH/java-projects"
            mvnInit "$name"
            ;;
        python|py)
            mkdir -p "$PROJECT_PATH/py-projects/$name"
            cd "$PROJECT_PATH/py-projects/$name"
            python3 -m venv venv
            echo "✅ Python project created: $name"
            ;;
        rust)
            cd "$PROJECT_PATH/rust-projects"
            cargo new "$name"
            echo "✅ Rust project created: $name"
            ;;
        *)
            mkdir -p "$PROJECT_PATH/$name"
            echo "✅ General project created: $name"
            ;;
    esac
}

# Clean build artifacts
clean() {
    echo "🧹 Cleaning build artifacts..."
    
    # C/C++
    find . -type f -name "*.o" -delete
    find . -type f -name "*.out" -delete
    find . -type d -name "build" -exec rm -rf {} + 2>/dev/null
    
    # Java
    find . -type d -name "target" -exec rm -rf {} + 2>/dev/null
    find . -type f -name "*.class" -delete
    
    # Python
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
    find . -type f -name "*.pyc" -delete
    find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null
    
    # Rust
    find . -type d -name "target" -exec rm -rf {} + 2>/dev/null
    
    # Node
    find . -type d -name "node_modules" -exec rm -rf {} + 2>/dev/null
    
    echo "✅ Cleanup complete"
}
