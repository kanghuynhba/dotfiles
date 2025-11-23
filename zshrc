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

# --- CRITICAL FIX: Custom Path Definition ---
# This must be defined BEFORE sourcing oh-my-zsh.sh so plugins are found.
ZSH_CUSTOM="$HOME/.zsh"

# ==============================================================================
# 3. OH-MY-ZSH CONFIGURATION
# ==============================================================================
ZSH_THEME="powerlevel10k/powerlevel10k"

# Standard Oh-My-Zsh settings
# HYPHEN_INSENSITIVE="true"
# ENABLE_CORRECTION="true"

# Plugins to load
# Note: I added back the plugins you were trying to use earlier.
plugins=(
  git
  zsh-completions
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# ==============================================================================
# 4. USER SCRIPTS (SAFE LOADING)
# ==============================================================================
# We check if the file exists [[ -f ]] before sourcing to prevent crashes.

[[ -f ~/.shell/aliases.sh ]]   && source ~/.shell/aliases.sh
[[ -f ~/.shell/functions.sh ]] && source ~/.shell/functions.sh
[[ -f ~/.shell/bootstrap.sh ]] && source ~/.shell/bootstrap.sh
[[ -f ~/.shell/courses.sh ]]   && source ~/.shell/courses.sh

# ==============================================================================
# 5. STYLING & COLORS (CRASH PROOF)
# ==============================================================================
# Only run vivid if it is installed on the system
if command -v vivid > /dev/null; then
    export LS_COLORS="$(vivid generate molokai)"
    zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# ==============================================================================
# 6. P10K CONFIGURATION (MUST BE AT THE END)
# ==============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Change autosuggestion color to a visible gray
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'
# Accept autosuggestion with Ctrl + Space
bindkey '^ ' autosuggest-accept
