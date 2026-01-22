#!/bin/bash
# ============================================================================
# Utility Functions - General Purpose Helpers
# ============================================================================

# ============================================================================
# DIRECTORY OPERATIONS
# ============================================================================

up() {
    local count=${1:-1}
    
    if ! [[ $count =~ ^[0-9]+$ ]]; then
        echo "Error: Argument must be a number"
        return 1
    fi

    local path=""
    for ((i=0; i<count; i++)); do
        path="../$path"
    done
    
    cd $path
}

mcd() {
    if [ -z "$1" ]; then
        echo "Error: Directory name required"
        return 1
    fi
    
    mkdir -p "$1" && cd "$1"
    echo "Created and entered: $1"
}

jump() {
    if [ -z "$1" ]; then
        echo "Error: File path required"
        return 1
    fi
    
    cd "$(dirname "$1")"
}

# ============================================================================
# SEARCH OPERATIONS
# ============================================================================

findfile() {
    find . -iname "*$1*" 2>/dev/null
}

findtext() {
    grep -r -i "$1" . 2>/dev/null
}

# ============================================================================
# ARCHIVE EXTRACTION
# ============================================================================

extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <archive>"
        return 1
    fi
    
    if [ ! -f "$1" ]; then
        echo "Error: File not found"
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
        *) echo "Unknown archive format" ;;
    esac
}

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

alias cpwd='pwd | copy && echo "Copied: $(pwd)"'

copyfile() {
    if [ -z "$1" ]; then
        echo "Error: File required"
        return 1
    fi
    
    cat "$1" | copy
    echo "Copied contents of: $1"
}

# ============================================================================
# PRODUCTIVITY HELPERS
# ============================================================================

top10() {
    history | awk "{print \$2}" | sort | uniq -c | sort -rn | head -10
}

weather() {
    curl "wttr.in/${1:-DaNang}?format=3"
}

note() {
    local note_file="$HOME/Personal/Documents/quick-notes.md"
    
    if [ -z "$1" ]; then
        # Show notes
        cat "$note_file" 2>/dev/null || echo "No notes yet"
    else
        # Add note with timestamp
        echo "$(date '+%Y-%m-%d %H:%M') - $*" >> "$note_file"
        echo "Note added"
    fi
}

timer() {
    local seconds=${1:-60}
    echo "Timer set for $seconds seconds"
    sleep $seconds
    echo "Time's up!"
    # Play sound if available
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || \
    echo -e "\a"
}
