#!/bin/bash
# nfs-common nfs-kernel-server 

curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install neovim radian

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update

sudo apt install asciinema neovim cmake clang curl tmux tree ctags ripgrep htop

#vi -p ~/.byobu/keybindings.tmux ~/.tmux.conf
# f9 to set c-b as esc seq
#
loc=`pwd`
filelocs=(
    .cvsignore
    vim-tmux-open.zsh
    # .muttrc
    .bash_aliases
    .tmux.conf
    .ctags
    .zshrc
    .gitconfig)

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#===
# steam deck nix pkg nvim
curl -L https://nixos.org/nix/install | sh
nix-env -i neovim
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s ~/.vimrc ~/.config/nvim/init.vim
#===

# --- Sometimes you have conda installed stuff that just isn't picked up by other tools (neovim in these cases)
# ln -s /home/jay/miniconda/bin/node /home/jay/.local/bin/ # uv tool install nodeenv? bun? 
# ---

#TODO: If .vim does not exist, create it
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
ln -sf ~/.vim $XDG_CONFIG_HOME/nvim
ln -sf ${loc}/init.vim $XDG_CONFIG_HOME/nvim/init.vim
ln -sf ${loc}/init.vim ~/.vimrc

ln -s ${loc}/user.lua $XDG_CONFIG_HOME/nvim/lua/plugins/user.lua

sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Add zsh plugins
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# is too much , don't use it
# git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

for i in ${filelocs[@]}; do
    ln -sf ${loc}/$i ~/$i
done

# Under System Preferences > Keyboard Layout > Options... > Ctrl key position, I checked 'Caps Lock as Ctrl'.
# xcape -e 'Control_L=Escape'
