#!/usr/bin/env bash
# ============================================================================
# install-tools.sh - Cross-Platform Development Environment Installer
# ============================================================================
# Supports: macOS (Homebrew), Ubuntu/Debian (apt)
#
# Usage:
#   ./install-tools.sh              Interactive (default)
#   ./install-tools.sh --yes        Install all heavy packages
#   ./install-tools.sh --no         Skip all heavy packages
#   ./install-tools.sh --core-only  Install core only, skip languages
# ============================================================================

set -e

# Security: Do not run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "Error: Do not run install-tools.sh as root."
    echo "Use your regular user account. Packages will request sudo when needed."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$SCRIPT_DIR/packages"
LOG_FILE="$SCRIPT_DIR/install-$(date +%Y%m%d-%H%M%S).log"

FORCE_YES=""
FORCE_NO=""
CORE_ONLY=""
SKIP_DOTFILES=""

print_header() {
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  $1"
    echo "╚══════════════════════════════════════════════════════════════════╝"
}

print_step() {
    echo ""
    echo "━━━ $1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

log() {
    echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ -f /etc/debian_version ]] || command -v apt-get &> /dev/null 2>&1; then
        echo "ubuntu"
    else
        echo "unsupported"
    fi
}

check_ prerequisites() {
    print_step "Checking prerequisites"
    
    local os="$1"
    
    if [[ "$os" == "macos" ]]; then
        if ! command -v brew &> /dev/null; then
            print_header "Homebrew not found! Installing..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            log "Homebrew installed"
        else
            log "Homebrew already installed: $(brew --version | head -1)"
        fi
    elif [[ "$os" == "ubuntu" ]]; then
        log "Updating apt cache..."
        sudo apt-get update -qq
        
        if ! command -v sudo &> /dev/null; then
            log "Installing sudo..."
            apt-get install -y sudo
        fi
        
        log "Installing build-essential..."
        sudo apt-get install -y build-essential curl wget software-properties-common
    fi
    
    log "Prerequisites check complete"
}

prompt_yes_no() {
    local package="$1"
    local description="$2"
    local size="$3"
    local reason="$4"
    
    if [[ "$FORCE_YES" == "true" ]]; then
        log "Installing $package (--yes flag)"
        return 0
    fi
    
    if [[ "$FORCE_NO" == "true" ]]; then
        log "Skipping $package (--no flag)"
        return 1
    fi
    
    echo ""
    echo "╔══════════════════════════════════════════════════════════════════╗"
    echo "║  Heavy Package: $package"
    echo "║  Description: $description"
    echo "║  Size: ~$size"
    if [[ -n "$reason" ]]; then
    echo "║  Reason: $reason"
    fi
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo -n "║  Install? [y/N]: "
    read -r answer
    echo "╚══════════════════════════════════════════════════════════════════╝"
    
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        log "Installing $package"
        return 0
    else
        log "Skipping $package"
        return 1
    fi
}

install_core() {
    print_step "Installing CORE packages"
    
    source "$PACKAGES_DIR/core.sh"
    local os="$1"
    
    if [[ "$os" == "macos" ]]; then
        install_core_macos
    elif [[ "$os" == "ubuntu" ]]; then
        install_core_ubuntu
    fi
    
    log "Core packages installed"
}

install_heavy_packages() {
    print_step "Installing HEAVY packages"
    
    source "$PACKAGES_DIR/heavy.sh"
    local os="$1"
    local installed=""
    local skipped=""
    
    if prompt_yes_no "openjdk" "Java Development Kit" "500MB" "Needed for Java projects (design_patterns, practice)"; then
        install_openjdk "$os" && installed+=" openjdk" || true
    fi
    
    if prompt_yes_no "maven" "Java build tool" "200MB" "Build tool for Java projects"; then
        install_maven "$os" && installed+=" maven" || true
    fi
    
    if prompt_yes_no "postgresql" "PostgreSQL database" "100MB" "Relational database for development"; then
        install_postgresql "$os" && installed+=" postgresql" || true
    fi
    
    if prompt_yes_no "mariadb" "MySQL database" "100MB" "Database for PHP/JS projects"; then
        install_mariadb "$os" && installed+=" mariadb" || true
    fi
    
    if prompt_yes_no "redis" "Redis cache database" "50MB" "Cache and session storage"; then
        install_redis "$os" && installed+=" redis" || true
    fi
    
    if prompt_yes_no "gcloud-cli" "Google Cloud CLI" "1GB" "GCP management and deployment"; then
        install_gcloud "$os" && installed+=" gcloud-cli" || true
    fi
    
    if prompt_yes_no "azure-cli" "Azure CLI" "200MB" "Azure cloud management"; then
        install_azure "$os" && installed+=" azure-cli" || true
    fi
    
    if prompt_yes_no "gcc" "GNU Compiler Collection" "500MB" "C/C++ compiler (required for g++ builds)"; then
        install_gcc "$os" && installed+=" gcc" || true
    fi
    
    if prompt_yes_no "llvm" "LLVM toolchain" "2GB" "Clang compiler and tools"; then
        install_llvm "$os" && installed+=" llvm" || true
    fi
    
    if [[ -n "$installed" ]]; then
        log "Heavy packages installed:$installed"
    else
        log "No heavy packages installed (skipped or --no flag used)"
    fi
}

install_languages() {
    print_step "Installing language tools"
    
    source "$PACKAGES_DIR/languages.sh"
    
    install_python
    install_nodejs
    install_rust
    
    log "Language tools installed"
}

install_dotfiles() {
    if [[ "$SKIP_DOTFILES" == "true" ]]; then
        log "Skipping dotfiles installation (--skip-dotfiles flag)"
        return
    fi
    
    print_step "Installing dotfiles"
    
    cd "$SCRIPT_DIR"
    
    if [[ -f "./install" ]]; then
        chmod +x ./install
        ./install
        log "Dotfiles installed"
    else
        log "Warning: install script not found"
    fi
}

print_summary() {
    print_header "Installation Summary"
    
    echo "║"
    echo "║  ✓ Core packages installed"
    echo "║  ✓ Language tools installed"
    if [[ "$FORCE_NO" == "true" ]]; then
    echo "║  ○ Heavy packages skipped (--no flag)"
    elif [[ "$FORCE_YES" == "true" ]]; then
    echo "║  ✓ All heavy packages installed (--yes flag)"
    else
    echo "║  ○ Heavy packages: review prompts above"
    fi
    echo "║  ✓ Dotfiles linked"
    echo "║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║  Log file: $LOG_FILE"
    echo "║"
    echo "╠══════════════════════════════════════════════════════════════════╣"
    echo "║  Next steps:"
    echo "║  1. Restart terminal or: source ~/.zshrc"
    echo "║  2. Verify: tmux -V && nvim --version && uv --version"
    echo "║  3. For Node.js: export NVM_DIR=\"\$HOME/.nvm\" && source \"\$NVM_DIR/nvm.sh\""
    echo "║"
    echo "╚══════════════════════════════════════════════════════════════════╝"
}

main() {
    local os
    
    print_header "Development Environment Installer"
    echo "║"
    echo "║  Script directory: $SCRIPT_DIR"
    echo "║  Log file: $LOG_FILE"
    echo "║"
    echo "║  Options:"
    [[ "$FORCE_YES" == "true" ]] && echo "║  - Install all heavy packages"
    [[ "$FORCE_NO" == "true" ]] && echo "║  - Skip all heavy packages"
    [[ "$CORE_ONLY" == "true" ]] && echo "║  - Core only (skip languages)"
    [[ "$SKIP_DOTFILES" == "true" ]] && echo "║  - Skip dotfiles"
    echo "║"
    
    os=$(detect_os)
    
    if [[ "$os" == "unsupported" ]]; then
        echo "║  ✗ Unsupported OS"
        echo "║  Supported: macOS, Ubuntu/Debian"
        exit 1
    fi
    
    echo "║  Detected OS: $os"
    echo "╚══════════════════════════════════════════════════════════════════╝"
    
    check_ prerequisites "$os"
    install_core "$os"
    
    if [[ "$CORE_ONLY" != "true" ]]; then
        install_heavy_packages "$os"
    fi
    
    install_languages
    install_dotfiles
    print_summary
}

for arg in "$@"; do
    case $arg in
        --yes) FORCE_YES="true";;
        --no)  FORCE_NO="true";;
        --core-only) CORE_ONLY="true";;
        --skip-dotfiles) SKIP_DOTFILES="true";;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --yes          Install all heavy packages (no prompts)"
            echo "  --no           Skip all heavy packages"
            echo "  --core-only    Install core only, skip heavy & languages"
            echo "  --skip-dotfiles Skip dotfiles installation"
            echo "  --help, -h     Show this help"
            exit 0
            ;;
    esac
done

main
