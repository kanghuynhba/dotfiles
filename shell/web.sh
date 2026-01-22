#!/bin/bash
# ============================================================================
# Web Shortcuts & Online Resources
# ============================================================================

# ============================================================================
# WEB SEARCH
# ============================================================================

google() {
    if [ -z "$*" ]; then
        open "https://www.google.com"
    else
        local query=$(echo "$*" | sed 's/ /+/g')
        open "https://www.google.com/search?q=$query"
    fi
}

# ============================================================================
# PERSONAL & CODING PLATFORMS
# ============================================================================

# GitHub
alias github='open https://github.com/kanghuynhba'
alias myrepos='open https://github.com/kanghuynhba?tab=repositories'

# LeetCode
alias leetweb='open https://leetcode.com/problemset/'

# ============================================================================
# LEARNING PLATFORMS
# ============================================================================

alias bilibili='open https://space.bilibili.com/400647031/lists/389026?type=series'
alias coursera='open https://www.coursera.org'
alias udemy='open https://www.udemy.com'

# ============================================================================
# DOCUMENTATION
# ============================================================================

alias javadoc='open https://docs.oracle.com/en/java/javase/17/docs/api/'
alias cppreference='open https://en.cppreference.com'
alias pythondoc='open https://docs.python.org/3/'
alias rustdoc='open https://doc.rust-lang.org/std/'

# ============================================================================
# WEB UTILITIES
# ============================================================================

alias mirrorsite='wget -m -k -K -E -e robots=off'
