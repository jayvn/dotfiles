#!/bin/bash
loc=`pwd`
filelocs=(
.cvsignore
vim-tmux-open.zsh
.muttrc
.bash_aliases
.tmux.conf
.ctags
.zshrc
.gitconfig)

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#TODO: If .vim does not exist, create it
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
ln -sf ~/.vim $XDG_CONFIG_HOME/nvim
ln -sf ${loc}/init.vim $XDG_CONFIG_HOME/nvim/init.vim
ln -sf ${loc}/init.vim ~/.vimrc

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

for i in ${filelocs[@]}; do
    ln -sf ${loc}/$i ~/$i
done

# Under System Preferences > Keyboard Layout > Options... > Ctrl key position, I checked 'Caps Lock as Ctrl'.
# xcape -e 'Control_L=Escape'
