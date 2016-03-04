alias rm="rm -i"

alias g=git
alias gs="git branch -a && git status"
alias ga="git add . -A"
alias gdH="git diff --color-words=\"[^[:space:]]|([[:alnum:]]|UTF_8_GUARD)+\" HEAD"
alias gd="git diff --color-words "
alias grb="g rb --root -i"

alias t="tree"
alias sa="sudo apt-get"
alias j="julia -q"
alias v="nvim"
alias vi="nvim"
alias wd="cd /media/disk2/"

gittop() {
    git rev-parse --show-toplevel
}

cm() {
git add  $(gittop) -A
git commit -m "$*";
}

cmps() {
git add $(gittop) -A
git commit -m "$*";
git push
}

replace() {
ag -l $1 | xargs sed -ri.bak -e "s/$1/$2/g"
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

        # lets get back to the CUR_DIR
        cd $CUR_DIR
    done

    echo "\n\033[32mComplete!\033[0m\n"
}

export TERM=screen-256color
# Set capslock to ctrl
setxkbmap -option caps:ctrl_modifier
set -o vi

# Tmux window
dev-tmux() {
cd /media/disk2/
tmux new-session -d 'vi'
tmux split-window -h 'julia'
tmux split-window -v
tmux new-window 'mutt'
tmux new-window 'cmus ~/Desktop/newND'
tmux -2 -u attach-session -d
}

alias ts='cd $(gittop) && ./testfile.sh'
