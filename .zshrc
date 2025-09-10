# Minimal Zsh configuration (no Oh My Zsh)

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt HIST_REDUCE_BLANKS

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source ~/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source ~/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Completion system
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Key bindings
bindkey -e  # Emacs mode (change to -v for vi mode)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Simple prompt (customize as needed)
# Format: user@host:dir $
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '

# Git info in prompt with dirty status
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats ' %b%c%u'
precmd() { vcs_info }
setopt PROMPT_SUBST
RPROMPT='${vcs_info_msg_0_}'

# Load aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Environment variables
export EDITOR='nvim'
export CC=clang
export CXX=clang++

# Vi mode
set -o vi

# FZF keybindings and completion
eval "$(fzf --zsh)"

# Bun
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export PATH="$HOME/.bun/bin:$PATH"

# Direnv - auto execute .envrc file in folder
eval "$(direnv hook zsh)"

# Zoxide - smarter cd
eval "$(zoxide init zsh)"

# Atuin - shell history
# eval "$(atuin init zsh)"

# Local environment (I think `uv` needs this  - auto added at some point)
. "$HOME/.local/bin/env"
