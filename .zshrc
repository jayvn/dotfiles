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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

[ -s "/home/jay/.bun/_bun" ] && source "/home/jay/.bun/_bun"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

export BUN_INSTALL="$HOME/.bun"
# Needed to find bun installed stuff
export PATH="$BUN_INSTALL/bin:$PATH"

# direnv , auto execute .envrc file in filder
eval "$(direnv hook zsh)"

eval "$(zoxide init zsh)"
# Atuin - shell history
eval "$(atuin init zsh)"
