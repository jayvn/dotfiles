# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh
# If  the PATH export and sourcing bash_aliases aren't placeed on top virtualenvwrapper.sh not found error is shown

# export PATH="$HOME/.nvm/versions/node/v20.9.0/bin:$HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$PATH"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="dogenpunk","Soliah","awesomepanda","agnoster","amuse", "fino"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

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

export NVM_LAZY_LOAD=true # Lazy load zsh-nvm
plugins=(
  history-substring-search
  z
  # virtualenvwrapper
  # zsh-syntax-highlighting
  # zsh-nvm
  zsh-autosuggestions
  zsh-syntax-highlighting
  colorize
  # zsh-vi-mode
)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

DISABLE_AUTO_UPDATE="true"
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

export EDITOR='nvim'
# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -halF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

export CC=clang
export CXX=clang++
set -o vi

export ANSIBLE_INVENTORY=~/ansible_hosts

# bind UP and DOWN arrow keys
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey "^R" history-incremental-search-backward

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# [[ -n $TMUX ]] && alias vi="zsh ~/vim-tmux-open.zsh"


function _print_all_panes() {
  for pane_id in $(tmux list-panes -F '#{pane_id}'); do
    tmux capture-pane -p -J -S 0 -E - -t "$pane_id" | tr ' ' '\n' | sort -u | rg '[a-zA-Z0-9]+'
  done
}

_tmux_pane_words() {
  local current_word="${LBUFFER##* }"
  local new_rbuffer="${RBUFFER/#[^ ]##/}"
  local prompt="${LBUFFER% *} ␣ $new_rbuffer "

  local selected_word=$(_print_all_panes | fzf --query="$current_word" --prompt="$prompt" --height=20 --layout=reverse --no-sort --print-query | tail -n1)
  local new_lbuffer="${LBUFFER% *} $selected_word"
  BUFFER="$new_lbuffer$new_rbuffer"
  CURSOR="${#${new_lbuffer}}"

  zle redisplay
}

zle -N _tmux_pane_words
bindkey '^U' _tmux_pane_words

# Define lazy conda aliases as an array in zsh syntax
lazy_conda_aliases=('conda' 'Rscript' 'R' 'radian' 'x86_64-conda-linux-gnu-gcc' 'npm')

load_conda() {
  # Unalias all the lazy conda aliases
  for lazy_conda_alias in "${lazy_conda_aliases[@]}"
  do
    unalias $lazy_conda_alias 2>/dev/null
  done

  __conda_prefix="$HOME/.miniconda" # Set your conda Location

  # >>> conda initialize >>>
  __conda_setup="$('/home/jay/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "/home/jay/miniconda/etc/profile.d/conda.sh" ]; then
      # . "/home/jay/miniconda/etc/profile.d/conda.sh"  # commented out by conda initialize
    else
      # export PATH="/home/jay/miniconda/bin:$PATH"  # commented out by conda initialize
    fi
  fi
  unset __conda_setup
  # <<< conda initialize <<<

  unset __conda_prefix
  unset -f load_conda
}

# Create the lazy loading aliases
for lazy_conda_alias in "${lazy_conda_aliases[@]}"
do
  alias $lazy_conda_alias="load_conda && $lazy_conda_alias"
done


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# export R_HOME="/home/jay/miniconda/bin/R"

export SSL_CERT_FILE=~/zscaler_root_ca.crt

eval "$(direnv hook zsh)"
