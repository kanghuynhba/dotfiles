# ============================================================================
# Language-Specific Tools
# ============================================================================
# Python (uv), Node.js (nvm), Rust (rustup)
# ============================================================================

install_python() {
    echo ""
    echo "  Installing Python tools..."
    
    # Install uv (fast Python package manager)
    if command -v uv &> /dev/null; then
        echo "    → uv already installed: $(uv --version)"
    else
        echo "    → Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        
        # Add to PATH for current session
        export PATH="$HOME/.local/bin:$PATH"
        source ~/.local/bin/env 2>/dev/null || true
    fi
    
    # Install Python packages
    echo "    → Installing Python packages..."
    uv pip install --system black isort ruff mypy pytest pydantic python-dotenv
    
    echo "    ✓ Python tools installed"
    echo "    → uv, black, isort, ruff, mypy, pytest, pydantic"
}

install_nodejs() {
    echo ""
    echo "  Installing Node.js via nvm..."
    
    # Install nvm if not present
    export NVM_DIR="$HOME/.nvm"
    
    if [[ ! -d "$NVM_DIR" ]]; then
        echo "    → Installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    else
        echo "    → nvm already installed: $(nvm --version 2>/dev/null || echo 'version unknown')"
    fi
    
    # Load nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    # Install LTS version
    echo "    → Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*
    
    # Install global npm packages
    echo "    → Installing global npm packages..."
    npm install -g npm-check-updates
    
    echo "    ✓ Node.js installed: $(node --version)"
    echo "    → To load nvm in new terminal, add to ~/.bashrc or ~/.zshrc:"
    echo "      export NVM_DIR=\"\$HOME/.nvm\""
    echo "      [ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\""
}

install_rust() {
    echo ""
    echo "  Installing Rust via rustup..."
    
    if command -v rustc &> /dev/null; then
        echo "    → Rust already installed: $(rustc --version)"
    else
        echo "    → Installing rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        
        # Load cargo
        source "$HOME/.cargo/env"
    fi
    
    # Install common tools
    echo "    → Installing cargo tools..."
    source "$HOME/.cargo/env" 2>/dev/null || true
    cargo install cargo-watch cargo-audit
    
    echo "    ✓ Rust installed: $(rustc --version)"
    echo "    → Tools: cargo-watch, cargo-audit"
}
