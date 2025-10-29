#!/bin/bash

curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install neovim radian black ruff basedpyright

loc=$(pwd)
filelocs=(
    .gitignore_global
    vim-tmux-open.zsh
    # .muttrc
    .bash_aliases
    .tmux.conf
    .ctags
    .zshrc
    .gitconfig)

# ========== VIM SETUP ==========
# Create Vim directory
mkdir -p ~/.vim

# Setup vim-plug for Vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Link Vim config (init.vim as ~/.vimrc)
ln -sf ${loc}/init.vim ~/.vimrc

# ========== NEOVIM SETUP ==========
# Create Neovim config directory
mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
mkdir -p $XDG_CONFIG_HOME/nvim

# Link Neovim config (init.lua in config directory)
ln -sf ${loc}/init.lua $XDG_CONFIG_HOME/nvim/init.lua

# Link lazygit config
mkdir -p $XDG_CONFIG_HOME/lazygit
ln -sf ${loc}/lazygit-config.yml $XDG_CONFIG_HOME/lazygit/config.yml

# Link fish config
mkdir -p $XDG_CONFIG_HOME/fish
ln -sf ${loc}/config.fish $XDG_CONFIG_HOME/fish/config.fish

# curl -L https://nixos.org/nix/install | sh

# --- Sometimes you have installed stuff that just isn't picked up by other tools (neovim in these cases)
# ln -s $(which bun) ~/.bun/bin/node
# ---
# Install bun somehow
# bun install -g prettier @anthropic-ai/claude-code 

for i in ${filelocs[@]}; do
    ln -sf ${loc}/$i ~/$i
done

# Link Claude Code settings
mkdir -p ~/.claude
ln -sf ${loc}/claude_settings.json ~/.claude/settings.json

# Link Gemini settings
mkdir -p ~/.gemini
ln -sf ${loc}/gemini_settings.json ~/.gemini/settings.json

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# Map Caps Lock to Ctrl
# Under System Preferences > Keyboard Layout > Options... > Ctrl key position, I checked 'Caps Lock as Ctrl'.
# xcape -e 'Control_L=Escape'

### Within vim, i can do
# : LspInstall r_language_server
