sudo apt install cmake clang curl tmux tree nfs-common nfs-kernel-server ctags\
                 python3-pip silversearcher-ag xclip

sudo -H pip3 install plumbum neovim

sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update

sudo apt install asciinema neovim

vi -p ~/.byobu/keybindings.tmux ~/.tmux.conf
# f9 to set c-b as esc seq

# Map Caps Lock to Ctrl

Keyboard Preferences dialog ( System -> Preferences -> Keyboard ).
On the layout tab, click the Options... button. 
Expand the Ctrl key position section

### Juliarc location:

ln -s ~/dotfiles/.juliarc.jl ~/.julia/config/startup.jl


### For steam dec
curl -fLo ~/.var/app/io.neovim.nvim/config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -s ~/.vimrc ~/.var/app/io.neovim.nvim/config/nvim/init.vim


### Within vim, i can do 
: LspInstall pyright r_language_server
: MasonInstall black
