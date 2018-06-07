alias rm="rm -i"

alias g=git
alias gs="git branch -a | cat && git status"
alias ga="git add . -A"
alias gdH="git diff --color-words=\"[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\" HEAD"
alias gd="git diff --color-words "
alias grb="g rb --root -i"

alias t="tree"
alias sa="sudo apt"
alias jl="julia --color=yes -q"
alias j="/home/jay/julia/bin/julia -q"
alias j2=/home/jay/ev/julia/julia
alias v=nvim
alias vi=nvim
# alias wd="cd ~/ev/"
alias py=python3
# alias vpn=/opt/cisco/anyconnect/bin/vpn

gitclean() {
    git prune
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
    julia -e "Pkg.update()"
    julia -e "recompile()"
}

# set -o vi
# mostused() {
#   history | awk '{print $2}' | sort | uniq -c | sort -nr | head
# }

alias tgz='tar -zxvf'
alias tbz='tar -jxvf'
export PATH=$PATH:~/.local/bin  # For pip installations

unset JULIA_HOME
# export JULIA_HOME=/home/jay/julia/bin
# export LD_LIBRARY_PATH=$PATH
# export CUDA_HOME="/usr/lib/R/lib:/usr/lib/x86_64-linux-gnu:/usr/lib:/home/jay/R/x86_64-pc-linux-gnu-library/3.4/PerformanceAnalytics/libs/"
# export LD_LIBRARY_PATH=${CUDA_HOME}:${LD_LIBRARY_PATH}
# export CLASSPATH=/home/jay/mysql_connectors/mysql-connector-java-5.1.45-bin.jar:$CLASSPATH

# lazyload nvm
# all props goes to http://broken-by.me/lazy-load-nvm/
# grabbed from reddit @ https://www.reddit.com/r/node/comments/4tg5jg/lazy_load_nvm_for_faster_shell_start/

# NVM stuff
# https://gist.github.com/fl0w/07ce79bd44788f647deab307c94d6922
lazynvm() {
    unset -f nvm node npm
    export NVM_DIR=~/.nvm
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}

nvm() {
    lazynvm
    nvm $@
}

node() {
    lazynvm
    node $@
}

npm() {
    lazynvm
    npm $@
}

alias iju='jupyter console --ZMQTerminalInteractiveShell.editing_mode=vi \
           --kernel=julia-0.6'
