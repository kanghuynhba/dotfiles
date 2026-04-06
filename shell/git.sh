#!/bin/bash
# ============================================================================
# git.sh - Git Workflow & Automation
# ============================================================================
# NOTE: Simple git aliases (gr, grd, gra, grad, br, st, co, di, dc, lg, aa,
# ci, ca, f, ff, save, stsh, staash, etc.) are defined in ~/.gitconfig
# [alias] and are intentionally NOT duplicated here. This file only adds
# shell functions that require real scripting logic beyond what gitconfig
# aliases can express.
# ============================================================================

# ============================================================================
# 1. VISUAL DIFF & RESTORE
# ============================================================================

# Interactively diff/restore a file against HEAD or a specific commit
# Usage: grd <file>            → diff current file against HEAD
#        grd <commit> <file>   → diff against a specific commit/branch
grd() {
    if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "Error: Not a git repository."
        return 1
    fi
    local opts="-y --extcmd=vimdiff"
    if [ $# -eq 1 ]; then
        git difftool $opts HEAD -- "$1"
    elif [ $# -eq 2 ]; then
        git difftool $opts "$1" -- "$2"
    else
        echo "Usage: grd [commit-ish] <file-path>"
        return 1
    fi
}

# ============================================================================
# 2. WORK-IN-PROGRESS (WIP) MANAGEMENT
# ============================================================================

# Snapshot all current changes as a WIP commit (safe for quick branch switching)
wip() {
    git add -A
    git commit -m "WIP: $(date +'%Y-%m-%d %H:%M:%S')" --no-verify
    echo "WIP commit created."
}

# Undo the last WIP commit, restoring changes to the working tree
unwip() {
    if [[ $(git log -1 --pretty=%s) == WIP:* ]]; then
        git reset HEAD~1
        echo "WIP commit undone. Changes are now unstaged."
    else
        echo "Error: Last commit is not a WIP commit."
    fi
}

# ============================================================================
# 3. BRANCH CLEANUP
# ============================================================================

# Delete all local branches already merged into main/master
gbclean() {
    local main_branch
    main_branch=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null \
        | sed 's@^refs/remotes/origin/@@')
    main_branch="${main_branch:-main}"
    echo "Cleaning branches merged into '$main_branch'..."
    git branch --merged "$main_branch" \
        | grep -v "\*" \
        | grep -v "$main_branch" \
        | xargs -r -n1 git branch -d
}

# ============================================================================
# 4. CONFLICT RESOLUTION
# ============================================================================

# List files with unresolved merge conflicts
gconf() {
    git diff --name-only --diff-filter=U
}

# Open all conflicted files in vim at once
geditconf() {
    local files
    files=$(gconf)
    if [ -n "$files" ]; then
        # shellcheck disable=SC2086
        vim $files
    else
        echo "No conflicts found."
    fi
}

# ============================================================================
# 5. REPO INITIALIZATION
# ============================================================================

# Init a repo with a solid .gitignore and an initial commit
ginit() {
    git init
    cat > .gitignore << 'EOF'
# macOS
.DS_Store
.AppleDouble
.LSOverride

# Build / Execution
bin/
obj/
build/
target/
execution/
*.exe
*.o
*.class

# Python
__pycache__/
*.py[cod]
*$py.class
venv/
.venv/

# Editors
*.swp
*.swo
*~
.vscode/
.idea/
EOF
    git add .
    git commit -m "Initial commit: Repository structure & .gitignore"
    echo "Git repo initialized with .gitignore."
}

# ============================================================================
# 6. BULK OPERATIONS
# ============================================================================

# Pull all git repos in the current directory (up to 2 levels deep)
gpullall() {
    find . -maxdepth 2 -name ".git" -type d \
        | rev | cut -c 6- | rev \
        | while IFS= read -r repo; do
            echo "--- Updating $repo ---"
            git -C "$repo" pull
        done
}

# ============================================================================
# 7. UTILITIES
# ============================================================================

# Open the current repo on GitHub in the browser
grepo() {
    local remote_url
    remote_url=$(git config --get remote.origin.url \
        | sed 's/\.git$//' \
        | sed 's|git@github.com:|https://github.com/|')
    if [ -n "$remote_url" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            open "$remote_url"
        else
            xdg-open "$remote_url" >/dev/null 2>&1
        fi
    else
        echo "No remote origin found."
    fi
}

# git add + commit + push in one shot. Usage: gcap "message"
gcap() {
    if [ -z "$1" ]; then
        echo "Usage: gcap \"message\""
        return 1
    fi
    git add .
    git commit -m "$1"
    git push
}

# Undo the last commit, keeping changes staged. Usage: gundo
gundo() {
    git reset --soft HEAD~1
    echo "Last commit undone. Changes are staged."
}









































































































































































































