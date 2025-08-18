## Repository Overview
This is a dotfiles repository for a development environment with comprehensive configurations for Neovim, tmux, git, and modern CLI tools. The repository uses symbolic linking for deployment 

## Common Commands

### Setup and Distribution
- `./distribute.sh` - Main setup script that installs dependencies, configures tools, and creates symlinks

### System Updates
- `udate` - Comprehensive update function that updates apt packages, oh-my-zsh, neovim plugins, and Julia packages

### Git Workflows
- `cm "message"` - Quick commit function (adds all files and commits)
- `gitclean()` - Clean up merged branches locally and remotely

### Development
- `nvim` or `vi` - Opens Neovim
- `l` - Enhanced ls with icons and git status (using eza)
- `pytestvi` - Run pytest and open results in vim with formatting
- `lg` - Open lazygit

## Architecture and Structure

### File Organization
- **Root Level**: Contains all configuration files (.bash_aliases, .gitconfig, .tmux.conf, etc.)
- **distribute.sh**: Central setup script that handles installation and symbolic linking, also has some notes at the end

### Key Configurations
1. **Shell Environment**: 
   - Zsh with Oh-My-Zsh framework
   - Extensive bash aliases and functions in `.bash_aliases`

2. **Editor Stack**:
   - Neovim as primary editor with  lazy; mapped to vi
   - backup old school vim; vim-plug for plugin management ; mapped to vim 
   - GitHub Copilot integration
   - tmux-vim navigation integration
   - Language servers configured via Mason and native LSP

3. **Git Configuration**:
   - Advanced diff/merge tools (difftastic, nbdiff for Jupyter)
   - Extensive aliases for common operations
   - Performance optimizations (histogram algorithm, rerere)

4. **Modern CLI Tools**:
   - `eza` replaces `ls` with enhanced features
   - `batcat` replaces `cat` with syntax highlighting
   - `ripgrep` for fast searching
   - `lazygit` for git UI

### Deployment Strategy
The repository uses symbolic links created by `distribute.sh`:
1. Dotfiles remain in the git repository
2. Symlinks are created in the home directory
3. Changes are made in the repository and deployed via the script
4. This allows easy version control and updates

### Special Considerations
- Steam Deck compatibility checks in setup script
- Python environment managed via UV instead of pip
- File safety aliases (`rm -i`, `cp -i`, `mv -i`) to prevent accidental deletions

# Steam Deck Nix GUI Apps Fix

Nix Qt apps (krita, calibre, kdenlive) crash with "Could not initialize GLX" on Steam Deck due to graphics driver mismatch. Solution: copy read-only Nix .desktop files to `~/.local/share/applications/` and patch them to use `QT_XCB_GL_INTEGRATION=none` for software rendering.

Script copies all Nix desktop files locally, patches Qt apps with the environment variable, and makes them executable - local files override Nix ones via XDG_DATA_DIRS precedence.
(XDG_DATA_DIRS used to be adding applications/ folder from nix, but i disabled it , redundant now )
 aand calibre works now

`nix-env -iA nixpkgs.Rorsomepkgs` In WSL no download from homeoffice . Timeouts
