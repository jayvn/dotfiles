alias g=git
alias gs="git status"
alias ga="git add . -A"
alias gdH="git diff --color-words=\"[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\" HEAD"
alias gd="git ddiff"
alias grb="g rb --root -i"

# alias mysql=mycli
alias t="tree"
alias vi=nvim

# alias wd="cd ~/ev/"
alias py=python3
alias ag='grep -Rn'
gitclean() {
  git checkout master
  git remote prune origin
  git branch --merged master | grep -v master | xargs -n 1 git branch -d
  git branch -r --merged master | grep -v master | sed 's/origin\///' | xargs -n 1 git push --delete origin
}

gittop() {
  git rev-parse --show-toplevel
}

cm() {
  git add $(gittop) -A
  git commit -m "$*"
}

replaceword() {
  rg -lsw $1 | xargs sed -ri -e "s/\\<$1\\>/$2/g"
}

replacetext() {
  rg -ls $1 | xargs sed -ri -e "s/$1/$2/g"
}

# set -o vi
# mostused() {
#   history | awk '{print $2}' | sort | uniq -c | sort -nr | head
# }

alias tgz='tar -zxvf'
alias tbz='tar -jxvf'
export PATH=$PATH:~/.local/bin # For pip installed packages
export PATH=$PATH:/usr/bin     # For pip installed packages

# When using nix package manager and want to load it in start menu
# export XDG_DATA_DIRS="expand(~)/.nix-profile/share"

## Node stuff
function extract() {
  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case "$archive" in
      *.tar.bz2) tar xvjf "$archive" ;;
      *.tar.gz) tar xvzf "$archive" ;;
      *.tar) tar xvf "$archive" ;;
      *.zip) unzip "$archive" ;;
      *.gz) gunzip "$archive" ;;
      *.rar) unrar x "$archive" ;;
      *) echo "$archive cannot be extracted via extract()" ;;
      esac
    else
      echo "$archive is not a valid file"
    fi
  done
}
alias myip='curl ifconfig.me'

alias cp='cp -i' # prompt for confirmation before overwriting or deleting files.
alias mv='mv -i'
alias rm='rm -i'

alias ls='eza --icons'
alias ll='eza -l --git'  # long format with git status
alias la='eza -la --git' # long format, all files
alias tree='eza --tree --git-ignore'
alias l='eza -lah --icons --git --group-directories-first --time-style=relative --sort=modified --accessed --hyperlink --color-scale'

# Runs pytest, captures output, and opens it in Vi with specific settings.
pytestvi() {
  local outfile="1.out.py"
  python -m unittest "$@" >"$outfile" 2>&1
  # pytest -s "$@" > "$outfile" 2>&1;
  vi -c 'lua vim.diagnostic.config({virtual_text=false})' \
    -c 'setlocal nowrap' \
    -c 'AnsiEsc' \
    -c 'setlocal filetype=python' \
    "$outfile"
}

alias r="radian"
alias lg=lazygit
alias z=zoxide

export PYTHONSTARTUP="$HOME/.config/python/startup.py" # For colorful errormsgs
