#!/bin/bash
# ============================================================================
# utilities.sh - General Purpose Helpers
# ============================================================================

# ============================================================================
# DIRECTORY OPERATIONS
# ============================================================================

# Go up N directories. Usage: up [n]
up() {
    local count=${1:-1}
    if ! [[ $count =~ ^[0-9]+$ ]]; then
        echo "Error: Argument must be a number"
        return 1
    fi
    local path=""
    for ((i = 0; i < count; i++)); do
        path="../$path"
    done
    cd "$path" || return 1
}

# Make dir and cd into it. Usage: mcd <name>
mcd() {
    if [ -z "$1" ]; then
        echo "Error: Directory name required"
        return 1
    fi
    mkdir -p "$1" && cd "$1" || return 1
    echo "Created and entered: $1"
}

# cd to the directory of a given file. Usage: jump <file>
jump() {
    if [ -z "$1" ]; then
        echo "Error: File path required"
        return 1
    fi
    cd "$(dirname "$1")" || return 1
}

# ============================================================================
# SEARCH OPERATIONS
# ============================================================================

# Find files by name (case-insensitive). Usage: findfile <pattern>
findfile() {
    if [ -z "$1" ]; then
        echo "Usage: findfile <pattern>"
        return 1
    fi
    find . -iname "*$1*" 2>/dev/null
}

# Search text recursively. Usage: findtext <pattern> [path]
findtext() {
    if [ -z "$1" ]; then
        echo "Usage: findtext <pattern> [path]"
        return 1
    fi
    grep -r -i "$1" "${2:-.}" 2>/dev/null
}

# ============================================================================
# ARCHIVE EXTRACTION
# ============================================================================

# Extract any archive format. Usage: extract <file>
extract() {
    if [ -z "$1" ]; then
        echo "Usage: extract <archive>"
        return 1
    fi
    if [ ! -f "$1" ]; then
        echo "Error: '$1' not found"
        return 1
    fi
    case "$1" in
        *.tar.bz2 | *.tbz2) tar xjf "$1" ;;
        *.tar.gz  | *.tgz)  tar xzf "$1" ;;
        *.tar)               tar xf  "$1" ;;
        *.bz2)               bunzip2     "$1" ;;
        *.gz)                gunzip      "$1" ;;
        *.rar)               unrar x     "$1" ;;
        *.zip)               unzip       "$1" ;;
        *.Z)                 uncompress  "$1" ;;
        *.7z)                7z x        "$1" ;;
        *) echo "Unknown archive format: $1"; return 1 ;;
    esac
}

# ============================================================================
# CLIPBOARD UTILITIES
# ============================================================================

if [[ "$OSTYPE" == "darwin"* ]]; then
    alias copy='pbcopy'
    alias paste='pbpaste'
elif grep -q Microsoft /proc/version 2>/dev/null; then
    alias copy='clip.exe'
    alias paste='powershell.exe -command "Get-Clipboard"'
else
    if command -v xclip &>/dev/null; then
        alias copy='xclip -selection clipboard'
        alias paste='xclip -selection clipboard -o'
    elif command -v wl-copy &>/dev/null; then
        alias copy='wl-copy'
        alias paste='wl-paste'
    fi
fi

# Copy current directory path to clipboard
alias cpwd='pwd | copy && echo "Copied: $(pwd)"'

# Copy a file's contents to clipboard. Usage: copyfile <file>
copyfile() {
    if [ -z "$1" ]; then
        echo "Error: File required"
        return 1
    fi
    if [ ! -f "$1" ]; then
        echo "Error: '$1' not found"
        return 1
    fi
    copy < "$1"
    echo "Copied contents of: $1"
}

# ============================================================================
# PRODUCTIVITY HELPERS
# ============================================================================

# Show top 10 most used shell commands
top10() {
    history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
}

# Search shell history. Usage: hgrep <pattern>
hgrep() {
    if [ -z "$1" ]; then
        echo "Usage: hgrep <pattern>"
        return 1
    fi
    history | grep -i "$1"
}

# Get weather. Usage: weather [city]
weather() {
    curl -s "wttr.in/${1:-DaNang}?format=3"
}

# Quick notes. Usage: note [text]  (no args = show notes)
note() {
    local note_file="$HOME/Work/Learning/Documentation/quick-notes.md"
    if [ -z "$1" ]; then
        cat "$note_file" 2>/dev/null || echo "No notes yet"
    else
        echo "$(date '+%Y-%m-%d %H:%M') - $*" >> "$note_file"
        echo "Note added"
    fi
}

# Countdown timer. Usage: timer [seconds]
timer() {
    local seconds=${1:-60}
    echo "Timer set for ${seconds}s..."
    sleep "$seconds"
    echo "Time's up!"
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || echo -e "\a"
}

# ============================================================================
# NETWORK UTILITIES
# ============================================================================

# Show SSH connection info for this machine
ssh_info() {
    local current_user="$USER"
    local current_ip=""

    if [[ "$OSTYPE" == "darwin"* ]]; then
        current_ip=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)
    else
        current_ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    fi

    echo "---------------------------------------"
    echo "   SSH Info for this machine"
    echo "---------------------------------------"
    if [ -z "$current_ip" ]; then
        echo "  Could not find a local IP address."
        echo "  Are you connected to a network?"
    else
        echo "  To connect TO this machine, run on the other:"
        echo ""
        echo "    ssh ${current_user}@${current_ip}"
        echo ""
    fi
    echo "---------------------------------------"
}

# Show all open listening ports
alias ports='ss -tulanp 2>/dev/null || netstat -tulanp'

# Quick HTTP server in current directory. Usage: serve [port]
serve() {
    local port="${1:-8080}"
    echo "Serving $(pwd) on http://localhost:${port}"
    python3 -m http.server "$port"
}

# ============================================================================
# FILE UTILITIES
# ============================================================================

# Show disk usage of items in current dir, sorted
alias usage='du -sh -- * | sort -h'

# Backup a file with a timestamp. Usage: bak <file>
bak() {
    if [ -z "$1" ]; then
        echo "Usage: bak <file>"
        return 1
    fi
    cp "$1" "${1}.bak.$(date +%Y%m%d_%H%M%S)"
    echo "Backup created: ${1}.bak.$(date +%Y%m%d_%H%M%S)"
}

# Count lines/words/chars. Usage: stats [file]
stats() {
    if [ -z "$1" ]; then
        echo "Usage: stats <file>"
        return 1
    fi
    echo "Lines : $(wc -l < "$1")"
    echo "Words : $(wc -w < "$1")"
    echo "Chars : $(wc -c < "$1")"
}

# ============================================================================
# CODE LOGGING
# ============================================================================
 
# Dump all source code from a directory into a single readable log file.
# Skips dependencies, build artifacts, binaries, and media by default.
#
# Usage:
#   codelog                          # log current dir → ./code.log
#   codelog src/                     # log a specific dir
#   codelog src/ out.txt             # custom output filename
#   codelog . out.txt vendor,dist    # also exclude vendor/ and dist/
#
# Default ignores: node_modules, venv, .venv, vendor, plugins, __pycache__,
#   .git, build, target, dist, .idea, .vscode, *.min.js, *.min.css,
#   *.lock, *.sum, binaries, images, fonts, archives
codelog() {
    local copy_to_clipboard=false
    
    # 1. Parse for -c flag
    if [[ "$1" == "-c" ]]; then
        copy_to_clipboard=true
        shift # Remove -c from arguments
    fi

    local dir="${1:-.}"
    local out="${2:-code.log}"
    local extra_ignores="${3:-}"

    # Default ignores
    local ignore_dirs=(
        node_modules venv .venv vendor plugins __pycache__
        .git build target dist .idea .vscode coverage .cache
    )
    local ignore_files=(
        "*.min.js" "*.min.css"
        "package-lock.json" "yarn.lock" "*.lock" "*.sum" "*.mod"
        "*.png" "*.jpg" "*.jpeg" "*.gif" "*.svg" "*.ico" "*.webp"
        "*.ttf" "*.woff" "*.woff2" "*.eot"
        "*.zip" "*.tar" "*.gz" "*.rar"
        "*.pdf" "*.bin" "*.exe" "*.o" "*.class" "*.pyc"
        "code.log" "git.log"
    )

    local ag_args=()
    for d in "${ignore_dirs[@]}"; do ag_args+=(--ignore-dir="$d"); done
    for f in "${ignore_files[@]}"; do ag_args+=(--ignore="$f"); done

    if [ -n "$extra_ignores" ]; then
        IFS=',' read -ra extras <<< "$extra_ignores"
        for e in "${extras[@]}"; do
            e="${e// /}"
            ag_args+=(--ignore-dir="$e" --ignore="$e")
        done
    fi

    # 2. Execution logic
    if [ "$copy_to_clipboard" = true ]; then
        echo "Logging '$dir' to clipboard..."
        ag --nocolor "${ag_args[@]}" . "$dir" | pbcopy
        echo "Done. Context copied to clipboard."
    else
        echo "Logging '$dir' → '$out' ..."
        ag --nocolor "${ag_args[@]}" . "$dir" > "$out"
        echo "Done. $(wc -l < "$out") lines written to '$out'"
    fi
}
