### Development
- `nvim` or `vi` - Opens Neovim
- `l` - Enhanced ls with icons and git status (using eza)
- `pytestvi` - Run pytest and open results in vim with formatting
- `lg` - Open lazygit

### File Organization
- **Root Level**: Contains all configuration files (.bash_aliases, .gitconfig, .tmux.conf, etc.)
- **distribute.sh**: Central setup script that handles installation and symbolic linking in `~`, also has some notes at the end

### Key Configurations
1. **Shell Environment**: 
   - Zsh + Oh-My-Zsh framework
   - bash aliases and functions in `.bash_aliases`

2. **Editor Stack**:
   - Neovim + lazy plugin manager ; mapped to vi
   - backup editor : vim +  vim-plug ; mapped to vim 
   - Language servers configured via Mason and native LSP


# Steam Deck Nix GUI Apps Fix

Nix Qt apps (krita, calibre, kdenlive) crash with "Could not initialize GLX" on Steam Deck due to graphics driver mismatch.
Solution: copy read-only Nix .desktop files to `~/.local/share/applications/` and patch them to use `QT_XCB_GL_INTEGRATION=none` for software rendering.

`qt-packages-post-install.sh` Script copies all Nix desktop files locally, patches Qt apps with the environment variable, and makes them executable - local files override Nix ones via XDG_DATA_DIRS precedence.
(XDG_DATA_DIRS used to be adding applications/ folder from nix, but i disabled it , redundant now )
 aand calibre works now

`nix-env -iA nixpkgs.Rorsomepkgs` In WSL doesn't download from homeoffice . Timeouts

# SteamOS update
sudo chown -R deck:deck /nix
