# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# "dogenpunk","Soliah","awesomepanda","agnoster","amuse", "fino", powerlevel10k/powerlevel10k"
ZSH_THEME="awesomepanda" #

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# history-substring-search

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  colorize
)

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

export EDITOR='nvim'
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# fi

#

# Add an "alert" alias for long running commands.  Use like so:
# sleep 10; alert

export CC=clang
export CXX=clang++
set -o vi

# Atuin handles history search

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# [[ -n $TMUX ]] && alias vi="zsh ~/vim-tmux-open.zsh"

# ----

# export R_HOME="/home/jay/miniconda/bin/R"
# export SSL_CERT_FILE=~/zscaler_root_ca.crt

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export PATH="$HOME/.bun/bin:$PATH"


# direnv , auto execute .envrc file in filder
eval "$(direnv hook zsh)"

eval "$(zoxide init zsh)"
# Atuin - shell history
eval "$(atuin init zsh)"

. "$HOME/.local/bin/env"
