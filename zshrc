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
