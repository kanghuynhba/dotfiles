# Development Environment Setup

## Quick Start

```bash
# 0. Set up SSH key first (required for git clone)
ssh-keygen -t ed25519 -C "your@email.com"
cat ~/.ssh/id_ed25519.pub
# Add the public key to GitHub: https://github.com/settings/keys

# 1. Clone dotfiles
git clone git@github.com:kanghuynhba/dotfiles.git ~/Config/dotfiles

# 2. Run installer
cd ~/Config/dotfiles
./install-tools.sh
```

## Supported Platforms

| OS | Package Manager | Status |
|----|-----------------|--------|
| macOS | Homebrew | ✅ Supported |
| Ubuntu | apt | ✅ Supported |
| Debian | apt | ✅ Supported |

## What Gets Installed

### Core Packages (Automatic)

No prompts needed, always installed:

| Package | Purpose |
|---------|---------|
| `git` | Version control |
| `curl`, `wget` | HTTP downloads |
| `zsh` | Shell |
| `tmux` | Terminal multiplexer |
| `ripgrep` | Fast grep |
| `bat` | Cat with syntax highlighting |
| `eza` | Modern ls replacement |
| `tree` | Directory tree view |
| `tldr` | Simplified man pages |
| `neovim` | Text editor |
| `cmake`, `make` | Build tools |
| `rclone` | Cloud storage sync |
| `mycli` | MySQL CLI with autocomplete |
| `coreutils` | GNU coreutils |
| JetBrains Mono | Dev font |

### Heavy Packages (Prompted)

You'll be asked for each package during installation:

| Package | Size | Purpose |
|---------|------|---------|
| `openjdk` | 500MB | Java development (design_patterns, practice) |
| `maven` | 200MB | Java build tool |
| `postgresql` | 100MB | Relational database |
| `mariadb` | 100MB | MySQL-compatible database |
| `redis` | 50MB | Cache and session storage |
| `gcloud-cli` | 1GB | Google Cloud management |
| `azure-cli` | 200MB | Azure cloud management |
| `gcc` | 500MB | GNU C/C++ compiler |
| `llvm` | 2GB | Clang compiler and LLVM tools |

### Language Tools (Automatic)

Installed after core packages:

| Language | Tool | Purpose |
|----------|------|---------|
| Python | `uv` | Fast package manager |
| Python | `black`, `ruff`, `mypy` | Linting/formatting |
| Python | `pytest` | Testing framework |
| Node.js | `nvm` + LTS | JavaScript runtime |
| Rust | `rustup` | Rust toolchain |

## Installer Options

```bash
./install-tools.sh              # Interactive (default) - prompts for heavy packages
./install-tools.sh --yes        # Install ALL packages without prompts
./install-tools.sh --no        # Skip ALL heavy packages
./install-tools.sh --core-only  # Install core only, skip languages
./install-tools.sh --skip-dotfiles  # Skip dotfiles installation
./install-tools.sh --help      # Show help
```

## Installation Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│  1. Detect OS (macOS/Ubuntu)                                           │
├─────────────────────────────────────────────────────────────────────────┤
│  2. Check prerequisites                                                 │
│     - macOS: Install Homebrew if missing                              │
│     - Ubuntu: Update apt, install build-essential                     │
├─────────────────────────────────────────────────────────────────────────┤
│  3. Install CORE packages (automatic)                                 │
│     git, curl, wget, zsh, tmux, ripgrep, bat, eza, tree, tldr         │
│     neovim, cmake, make, rclone, mycli, JetBrains Mono                │
├─────────────────────────────────────────────────────────────────────────┤
│  4. Prompt for HEAVY packages                                         │
│     ┌─────────────────────────────────────────────────────────┐       │
│     │  ╔══════════════════════════════════════════════════════╗│       │
│     │  ║  Heavy Package: openjdk                             ║│       │
│     │  ║  Description: Java Development Kit                  ║│       │
│     │  ║  Size: ~500MB                                       ║│       │
│     │  ║  Reason: Needed for Java projects                  ║│       │
│     │  ╠══════════════════════════════════════════════════════╣│       │
│     │  ║  Install? [y/N]:                                     ║│       │
│     │  ╚══════════════════════════════════════════════════════╝│       │
│     └─────────────────────────────────────────────────────────┘       │
├─────────────────────────────────────────────────────────────────────────┤
│  5. Install language tools                                             │
│     Python (uv + packages) → Node.js (nvm) → Rust (rustup)            │
├─────────────────────────────────────────────────────────────────────────┤
│  6. Run dotfiles installer                                            │
│     ./install (Dotbot symlinks configs)                               │
├─────────────────────────────────────────────────────────────────────────┤
│  7. Summary                                                            │
│     ✓ Core installed                                                   │
│     ✓ Heavy packages: openjdk, postgresql                             │
│     ✓ Languages: Python, Node.js, Rust                                │
│     ✓ Dotfiles linked                                                 │
└─────────────────────────────────────────────────────────────────────────┘
```

## Post-Installation

### 1. Set Default Shell to zsh

```bash
chsh -s $(which zsh)
```

### 2. Restart Terminal or Source Configs

```bash
# For zsh
source ~/.zshrc

# For bash
source ~/.bashrc
```

### 3. Load nvm (Node.js)

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

### 4. Verify Installations

```bash
tmux -V           # Should show tmux version
nvim --version    # Should show Neovim version
uv --version      # Should show uv version
node --version    # Should show Node.js version
rustc --version   # Should show Rust version
```

## Tmux Workflow

The installer sets up tmux sessions with standard windows:

```bash
tp                    # Fuzzy-find project and create session
tnew                  # Create session for current directory
tnew myproject        # Create session named "myproject"
tn                    # Alias for tnew

# In tmux:
# - ai: OpenCode AI assistant
# - code: Neovim
# - exec: Shell execution
# - git: Git operations
# - test: Testing
```

## Vim Plugins

Installed via git submodules:

| Plugin | Purpose |
|--------|---------|
| `ale` | Linting engine |
| `coc.nvim` | LSP client |
| `fzf.vim` | Fuzzy finder |
| `vim-markdown` | Markdown support |
| `vim-polyglot` | Language syntax |
| `github-nvim-theme` | Color scheme |
| `rust.vim` | Rust support |
| `copilot.vim` | GitHub Copilot |

### Vim Keybindings

| Key | Action |
|-----|--------|
| `<C-p>` | Fuzzy file search (FZF) |
| `<leader>b` | Buffer list |
| `<leader>h` | History |
| `<leader>g` | Ripgrep search |
| `<leader>tl` | Close tabs to left |
| `<leader>tr` | Close tabs to right |
| `<leader>to` | Close other tabs |
| `J` / `K` | Previous/next tab |
| `tt` | New tab |
| `tx` | Close tab |
| `<leader>rr` | Run current file |
| `<leader>rt` | Run tests |
| `<leader>bb` | Build project |

## Remove Duplicates (Before Installing on New Machine)

If migrating from macOS with Homebrew:

```bash
# Remove duplicate Python versions
brew uninstall python@3.12 python@3.14
brew uninstall icu4c@77

# Remove openjdk (keep temurin)
brew uninstall openjdk

# Remove silver searcher (use ripgrep instead)
brew uninstall the_silver_searcher

# Clean up
brew cleanup
brew doctor
```

## Customization

### Add a New Package

1. **Core package** (no prompt): Edit `packages/core.sh`

```bash
install_core_ubuntu() {
    # ... existing code ...
    sudo apt-get install -y my-new-tool
}
```

2. **Heavy package** (with prompt): Edit `packages/heavy.sh`

```bash
install_mypackage() {
    local os="$1"
    if [[ "$os" == "macos" ]]; then
        brew install mypackage
    elif [[ "$os" == "ubuntu" ]]; then
        sudo apt-get install -y mypackage
    fi
}
```

Then add to `install-tools.sh` in `install_heavy_packages()`:

```bash
if prompt_yes_no "mypackage" "My Package" "100MB" "Why it's needed"; then
    install_mypackage "$os"
fi
```

### Skip Specific Package

If you don't need a core package, comment it out in `packages/core.sh`.

## Troubleshooting

### Homebrew not found

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Permission denied (Ubuntu)

```bash
sudo apt-get update
sudo apt-get install -y build-essential
```

### nvm not loaded

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

Add to `~/.zshrc` or `~/.bashrc` to persist.

### Rust not found

```bash
source "$HOME/.cargo/env"
```

Add to shell config to persist.

### tmux not working

```bash
# Check tmux version
tmux -V

# If old version, upgrade
brew upgrade tmux        # macOS
sudo apt-get install tmux  # Ubuntu
```

### neovim plugins not loading

```bash
nvim +PlugInstall +UpdateRemotePlugins +qall
```

Or use `:PlugUpdate` inside neovim.

## Project Structure

```
dotfiles/
├── install              # Dotbot installer
├── install-tools.sh     # Main cross-platform installer
├── packages/
│   ├── core.sh          # Core packages
│   ├── heavy.sh         # Heavy packages
│   └── languages.sh     # Language tools
├── shell/
│   ├── load_all.sh      # Shell config loader
│   ├── core.sh          # Core aliases
│   ├── tmux.sh          # Tmux session management
│   ├── git.sh           # Git workflows
│   └── dev.sh           # Dev tools
├── vim/
│   └── pack/            # Vim plugins (submodules)
└── zsh/
    ├── plugins/         # Zsh plugins (submodules)
    └── themes/          # Zsh themes
```

## Uninstall

To remove installed packages:

```bash
# macOS (Homebrew)
brew uninstall <package-name>
brew cleanup

# Ubuntu (apt)
sudo apt-get remove --purge <package-name>
sudo apt-get autoremove

# Remove dotfiles symlinks
cd ~/Config/dotfiles
git clean -fdX
```

## License

This is your personal dotfiles configuration. Customize freely!
