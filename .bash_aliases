alias rm="rm -i"

alias g=git
alias gs="git branch -a | cat && git status"
alias ga="git add . -A"
alias gdH="git diff --color-words=\"[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\" HEAD"
alias gd="git diff --color-words "
alias grb="g rb --root -i"

# alias mysql=mycli
alias t="tree"
alias sa="sudo apt"
alias r2=radian
# alias nvim="flatpak run io.neovim.nvim"
# alias v=nvim
alias vi=nvim
alias firefox="flatpak run org.mozilla.firefox"

# alias wd="cd ~/ev/"
alias py=python3
# alias vpn=/opt/cisco/anyconnect/bin/vpn
# alias iju='jupyter console --ZMQTerminalInteractiveShell.editing_mode=vi \
#            --kernel=julia-0.6'
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
    git commit -m "$*";
}

replaceword() {
    ag -lsw $1 | xargs sed -ri -e "s/\\<$1\\>/$2/g"
}

replacetext() {
    # rpl
    ag -ls $1 | xargs sed -ri -e "s/$1/$2/g"
}

# ugits() {
#     # store the current dir
#     CUR_DIR=$(pwd)
#
#     # Let the person running the script know what's going on.
#     echo "\n\033[1mPulling in latest changes for all repositories...\033[0m\n"
#
#     # Find all git repositories and update it to the master latest revision
#     for i in $(find . -name ".git" | cut -c 3-); do
#         echo "";
#         echo "\033[33m"+$i+"\033[0m";
#
#         # We have to go to the .git parent directory to call the pull command
#         cd "$i";
#         cd ..;
#
#         # finally pull
#         git pull origin master;
#         gitclean # clean merged branches
#         # Also update the tags
#         ctags -R
#
#         # lets get back to the CUR_DIR
#         cd $CUR_DIR
#     done
#
#     echo "\n\033[32mComplete!\033[0m\n"
# }

# Update the date and pull from all repos
udate()
{
    sudo apt update
    sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
    # ugits
    time sudo apt -y full-upgrade
    source ~/.oh-my-zsh/tools/upgrade.sh
    # R -e "update.packages()"
    # pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install -U --user

    nvim -c "PlugUpdate | PlugUpgrade"

    # Probably should be last because this can fail
    julia -e "using Pkg; Pkg.update()"
    julia -e "recompile()"
}

# set -o vi
# mostused() {
#   history | awk '{print $2}' | sort | uniq -c | sort -nr | head
# }

alias tgz='tar -zxvf'
alias tbz='tar -jxvf'
export PATH=$PATH:~/.local/bin  # For pip installed packages
export PATH=$PATH:/usr/bin  # For pip installed packages

export PLOTS_DEFAULT_BACKEND=PyPlot


## Node stuff
# Add every binary that requires nvm, npm or node to run to an array of node globals
# NODE_GLOBALS=(`find ~/.nvm/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
# NODE_GLOBALS+=("node")
# NODE_GLOBALS+=("nvm")
# 
# # Lazy-loading nvm + npm on node globals call
# load_nvm () {
#   export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
#   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# }
# 
# # Making node global trigger the lazy loading
# for cmd in "${NODE_GLOBALS[@]}"; do
#   eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
# done


source /usr/share/bash-completion/completions/flatpak
