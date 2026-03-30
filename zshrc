# ==============================================================================
# 1. POWERLEVEL10K INSTANT PROMPT (MUST BE AT THE TOP)
# ==============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================================================================
# 2. PATH & ENVIRONMENT
# ==============================================================================
export ZSH="$HOME/.oh-my-zsh"

# Custom ZSH configuration location (FIXED PATH)
ZSH_CUSTOM="$HOME/Config/dotfiles/zsh"

# ==============================================================================
# 3. OH-MY-ZSH CONFIGURATION
# ==============================================================================
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins to load
plugins=(
  git
  zsh-completions
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 4. USER SCRIPTS (FIXED PATHS)
# ==============================================================================
SHELL_PATH="$HOME/Config/dotfiles/shell"

[[ -f $SHELL_PATH/aliases.sh ]]   && source $SHELL_PATH/aliases.sh
[[ -f $SHELL_PATH/load_all.sh ]]   && source $SHELL_PATH/load_all.sh
[[ -f $SHELL_PATH/functions.sh ]] && source $SHELL_PATH/functions.sh
[[ -f $SHELL_PATH/bootstrap.sh ]] && source $SHELL_PATH/bootstrap.sh
[[ -f $SHELL_PATH/courses.sh ]]   && source $SHELL_PATH/courses.sh

# # ==============================================================================
# # 5. STYLING & COLORS
# # ==============================================================================
if command -v vivid > /dev/null; then
    export LS_COLORS="$(vivid generate molokai)"
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# ==============================================================================
# 6. P10K CONFIGURATION (MUST BE AT THE END)
# ==============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Autosuggestion styling
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

# Accept autosuggestion with Ctrl + Space
bindkey '^ ' autosuggest-accept

export PATH="$HOME/.cargo/bin:$PATH"

# Ensure Homebrew binaries are prioritized
export PATH="/opt/homebrew/bin:$PATH"

# Force 'vim' to use the Homebrew version with Python support
alias vim='/opt/homebrew/bin/vim'
alias vi='/opt/homebrew/bin/vim'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# 1. Point to your submodule path
export FZF_BASE=~/Config/dotfiles/zsh/plugins/fzf
# 2. Add the fzf binary to your PATH
export PATH="$PATH:$FZF_BASE/bin"

# 3. Use Ripgrep (rg) for searching (ignores .git and node_modules automatically)
if (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git/*"'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# 4. Source the fuzzy completion and keybindings
source "$FZF_BASE/shell/completion.zsh"
source "$FZF_BASE/shell/key-bindings.zsh"
# Professional "One Dark" style colors for fzf
export FZF_DEFAULT_OPTS='--color=fg:-1,bg:-1,hl:#5f87af,fg+:#afaf00,bg+:#262626,hl+:#5fd7ff --color=info:#afaf87,prompt:#d7005f,pointer:#af5f00,marker:#87ff00,header:#87afaf'
# Make bat match your Monokai Charcoal theme
export BAT_THEME="Monokai Extended"
