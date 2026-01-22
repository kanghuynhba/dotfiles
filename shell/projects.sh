#!/bin/bash
# ============================================================================
# Project Management Functions
# ============================================================================

# Base project path
PROJECT_PATH=~/Work/Projects/projects

# ============================================================================
# LANGUAGE-SPECIFIC PROJECT NAVIGATION
# ============================================================================

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
# NEW PROJECT CREATION
# ============================================================================

newproject() {
    local name=$1
    local type=${2:-"general"}
    
    if [ -z "$name" ]; then
        echo "Error: Project name required"
        echo "Usage: newproject <name> [cpp|java|python|rust]"
        return 1
    fi
    
    case "$type" in
        cpp|c++)
            mkdir -p "$PROJECT_PATH/cpp-projects/$name"/{src,include,tests}
            echo "C++ project created: $name"
            ;;
        java)
            cd "$PROJECT_PATH/java-projects"
            mvnInit "$name"
            ;;
        python|py)
            mkdir -p "$PROJECT_PATH/py-projects/$name"
            cd "$PROJECT_PATH/py-projects/$name"
            python3 -m venv venv
            echo "Python project created: $name"
            ;;
        rust)
            cd "$PROJECT_PATH/rust-projects"
            cargo new "$name"
            echo "Rust project created: $name"
            ;;
        *)
            mkdir -p "$PROJECT_PATH/$name"
            echo "General project created: $name"
            ;;
    esac
}

# ============================================================================
# BUILD ARTIFACT CLEANUP
# ============================================================================

clean() {
    echo "Cleaning build artifacts..."
    
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
    
    echo "Cleanup complete"
}
