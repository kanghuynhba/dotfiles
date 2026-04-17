# ============================================================================
# Core Packages - Always installed (no prompt)
# ============================================================================
# These packages are lightweight and essential for development workflow.
# ============================================================================

log_install() {
    echo "    → Installing: $1"
}

log_done() {
    echo "    ✓ $1 installed"
}

install_core_macos() {
    echo ""
    echo "  Installing macOS core packages via Homebrew..."
    echo ""
    
    log_install "git, curl, wget, zsh, tmux"
    brew install git curl wget zsh tmux
    
    log_install "ripgrep, bat, eza, tree, tldr"
    brew install ripgrep bat eza tree tldr coreutils
    
    log_install "neovim, cmake, make"
    brew install neovim cmake make
    
    log_install "rclone, mycli"
    brew install rclone mycli
    
    log_install "font JetBrains Mono"
    brew install --cask font-jetbrains-mono
    
    log_done "Core packages"
}

install_core_ubuntu() {
    echo ""
    echo "  Installing Ubuntu/Debian core packages via apt..."
    echo ""
    
    log_install "build tools: git, curl, wget, zsh, tmux"
    sudo apt-get install -y \
        git curl wget zsh tmux \
        build-essential autoconf automake libssl-dev
    
    log_install "ripgrep, bat, eza, tree, tldr"
    sudo apt-get install -y ripgrep bat tree tldr
    
    # Install eza (modern ls)
    if ! command -v eza &> /dev/null; then
        log_install "eza (from GitHub release)"
        local eza_version="0.18.10"
        curl -L "https://github.com/eza-community/eza/releases/download/v${eza_version}/eza_${eza_version}_$(uname -m)-unknown-linux-gnu.tar.gz" -o /tmp/eza.tar.gz
        sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin eza
        rm /tmp/eza.tar.gz
    fi
    
    log_install "neovim, cmake, make"
    sudo apt-get install -y neovim cmake make
    
    log_install "rclone"
    sudo apt-get install -y rclone
    
    log_install "mycli (MySQL CLI)"
    pip install mycli || sudo apt-get install -y mycli
    
    log_install "font JetBrains Mono"
    mkdir -p ~/.local/share/fonts
    curl -L "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip" -o /tmp/jetbrains.zip
    unzip -q /tmp/jetbrains.zip -d ~/.local/share/fonts
    rm /tmp/jetbrains.zip
    fc-cache -f -v ~/.local/share/fonts
    
    log_done "Core packages"
}
