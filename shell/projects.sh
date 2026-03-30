#!/bin/bash
# ============================================================================
# projects.sh - Language Logic
# ============================================================================

PROJECT_PATH="$HOME/Work/Projects/projects"

# Smart Navigation: Works for any language
# Usage: pproj cpp my-api
pproj() {
    local lang_dir="$1-projects"
    local proj_name="$2"
    local target="$PROJECT_PATH/$lang_dir/$proj_name"

    if [ -d "$target" ]; then
        _tmux_switch "$target" "$proj_name"
    else
        echo "Project $proj_name not found in $lang_dir"
    fi
}

# New Project Creation
newproject() {
    local name="$1"
    local type="${2:-"general"}"
    [[ -z "$name" ]] && return 1

    local lang_folder="general"
    case "$type" in
        cpp|c++)   lang_folder="cpp-projects" ;;
        java)      lang_folder="java-projects" ;;
        py|python) lang_folder="py-projects" ;;
        rust)      lang_folder="rust-projects" ;;
    esac

    local full_path="$PROJECT_PATH/$lang_folder/$name"
    mkdir -p "$full_path"

    # Run init commands
    case "$type" in
        rust) cd "$full_path" && cargo init ;;
        py)   python3 -m venv "$full_path/venv" ;;
        cpp)  mkdir -p "$full_path"/{src,include} ;;
    esac

    _tmux_switch "$full_path" "$name"
}

# Unified Cleanup
clean() {
    [[ "$PWD" == "$HOME" ]] && return 1
    echo "Cleaning $PWD..."
    find . -type d \( -name "build" -o -name "target" -o -name "__pycache__" -o -name "node_modules" \) -exec rm -rf {} + 2>/dev/null
    find . -type f \( -name "*.o" -o -name "*.class" -o -name "*.pyc" \) -delete
}

# Legacy Aliases (pointing to the new engine)
alias bustub="pproj cpp bustub-private"
