alias rm="rm -i"

alias g=git
alias gs="git branch -a && git status"
alias ga="git add . -A"
alias gdH="git diff --color-words=\"[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\" HEAD"
alias gd="git diff --color-words "
alias grb="g rb --root -i"

alias t="tree"
alias sa="sudo apt"
alias j="julia -q"
alias v=nvim
alias vi=nvim
# alias wd="cd ~/ev/"
alias py=python3
alias vpn=/opt/cisco/anyconnect/bin/vpn

gitclean() {
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

cmps() {
    git add $(gittop) -A
    git commit -m "$*";
    git push
}

replaceword() {
    ag -lsw $1 | xargs sed -ri -e "s/\\<$1\\>/$2/g"
}

replacetext() {
    ag -ls $1 | xargs sed -ri -e "s/$1/$2/g"
}

ugits() {
    # store the current dir
    CUR_DIR=$(pwd)

    # Let the person running the script know what's going on.
    echo "\n\033[1mPulling in latest changes for all repositories...\033[0m\n"

    # Find all git repositories and update it to the master latest revision
    for i in $(find . -name ".git" | cut -c 3-); do
        echo "";
        echo "\033[33m"+$i+"\033[0m";

        # We have to go to the .git parent directory to call the pull command
        cd "$i";
        cd ..;

        # finally pull
        git pull origin master;
        gitclean # clean merged branches
        # Also update the tags
        ctags -R

        # lets get back to the CUR_DIR
        cd $CUR_DIR
    done

    echo "\n\033[32mComplete!\033[0m\n"
}

# Update the date and pull from all repos
udate()
{
    sudo apt update
    sudo date -s "$(wget -qSO- --max-redirect=0 google.com 2>&1 | grep Date: | cut -d' ' -f5-8)Z"
    # ugits
    time sudo apt -y full-upgrade
    source ~/.oh-my-zsh/tools/upgrade.sh
    julia -e "Pkg.update()"
    # R -e "update.packages()"
    sudo -H pip3 install --upgrade neovim
    nvim -c "PlugUpdate | PlugUpgrade"

    # Probably should be last because this will likely fail
    julia -e "recompile_packages()"
    # cd ~/dev
}

export TERM=screen-256color
# Set capslock to ctrl
# setxkbmap -option caps:ctrl_modifier
# setxkbmap -option ctrl:nocaps
# xcape -e 'Control_L=Escape'

set -o vi

ts() {
    # if [ -f .git ]; then
    # cd $(gittop)
    # fi
    ./testfile.sh
}

mostused() {
  history | awk '{print $2}' | sort | uniq -c | sort -nr | head
}

alias tgz='tar -zxvf'
alias tbz='tar -jxvf'
export JULIA_HOME=/home/jay/julia/bin

# export LD_LIBRARY_PATH=$PATH
export CUDA_HOME="/usr/lib/R/lib:/usr/lib/x86_64-linux-gnu:/usr/lib:/home/jay/R/x86_64-pc-linux-gnu-library/3.4/PerformanceAnalytics/libs/"
export LD_LIBRARY_PATH=${CUDA_HOME}:${LD_LIBRARY_PATH}
