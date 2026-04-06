#!/bin/bash
# ============================================================================
# projects.sh - Project Navigation & Management
# ============================================================================

PROJECT_PATH="$HOME/Work/Projects/projects"

# ============================================================================
# LANGUAGE-SPECIFIC SHORTCUTS
# ============================================================================

cppProject()   { cd "$PROJECT_PATH/cpp-projects/$1"   && [ -n "$1" ] && _tmux_switch "$PWD" "$1"; }
javaProject()  { cd "$PROJECT_PATH/java-projects/$1"  && [ -n "$1" ] && _tmux_switch "$PWD" "$1"; }
pyProject()    { cd "$PROJECT_PATH/py-projects/$1"    && [ -n "$1" ] && _tmux_switch "$PWD" "$1"; }
rustProject()  { cd "$PROJECT_PATH/rust-projects/$1"  && [ -n "$1" ] && _tmux_switch "$PWD" "$1"; }
swiftProject() { cd "$PROJECT_PATH/swift-projects/$1" && [ -n "$1" ] && _tmux_switch "$PWD" "$1"; }

# ============================================================================
# SMART NAVIGATION
# ============================================================================

# Navigate to a project by language prefix and open in tmux
# Usage: pproj <lang> <project-name>   e.g. pproj cpp bustub
pproj() {
    if [ $# -lt 2 ]; then
        echo "Usage: pproj <lang> <project-name>"
        echo "       e.g.  pproj cpp bustub"
        return 1
    fi
    local lang_dir="$1-projects"
    local proj_name="$2"
    local target="$PROJECT_PATH/$lang_dir/$proj_name"

    if [ -d "$target" ]; then
        _tmux_switch "$target" "$proj_name"
    else
        echo "Project '$proj_name' not found in '$lang_dir'"
        echo "Expected: $target"
        return 1
    fi
}

# List all projects, optionally filtered by language
# Usage: lsproj [lang]
lsproj() {
    if [ -n "$1" ]; then
        local dir="$PROJECT_PATH/$1-projects"
        if [ -d "$dir" ]; then
            echo "[$1 projects]"
            ls "$dir"
        else
            echo "No '$1-projects' folder found."
            return 1
        fi
    else
        for dir in "$PROJECT_PATH"/*/; do
            local lang
            lang=$(basename "$dir" | sed 's/-projects//')
            echo "[$lang]"
            ls "$dir" 2>/dev/null
            echo ""
        done
    fi
}

# ============================================================================
# PROJECT CREATION
# ============================================================================

# Create a new project with boilerplate. Usage: newproject <name> [lang]
newproject() {
    local name="$1"
    local type="${2:-general}"
    if [[ -z "$name" ]]; then
        echo "Usage: newproject <name> [cpp|java|py|rust|swift]"
        return 1
    fi

    local lang_folder
    case "$type" in
        cpp|c++) lang_folder="cpp-projects"  ;;
        java)    lang_folder="java-projects" ;;
        py|python) lang_folder="py-projects" ;;
        rust)    lang_folder="rust-projects" ;;
        swift)   lang_folder="swift-projects" ;;
        *)       lang_folder="general"       ;;
    esac

    local full_path="$PROJECT_PATH/$lang_folder/$name"
    mkdir -p "$full_path"

    case "$type" in
        rust)      cd "$full_path" && cargo init ;;
        py|python) python3 -m venv "$full_path/venv" ;;
        cpp|c++)   mkdir -p "$full_path"/{src,include} ;;
    esac

    echo "Project '$name' created at: $full_path"
    _tmux_switch "$full_path" "$name"
}

# ============================================================================
# CLEANUP
# ============================================================================

# Remove build artifacts in the current project
clean() {
    [[ "$PWD" == "$HOME" ]] && echo "Refusing to clean HOME." && return 1
    echo "Cleaning $PWD..."
    find . -type d \( -name "build" -o -name "target" -o -name "__pycache__" -o -name "node_modules" \) \
        -exec rm -rf {} + 2>/dev/null
    find . -type f \( -name "*.o" -o -name "*.class" -o -name "*.pyc" \) -delete 2>/dev/null
    echo "Done."
}

# ============================================================================
# LEGACY ALIASES
# ============================================================================

alias bustub="pproj cpp bustub-private"
