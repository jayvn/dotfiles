{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "dev-packages";
  paths = with pkgs; [
    zsh # prio over pacman installed
    atuin
    bash-language-server # for nvim
    bat # `batcat` replaces `cat` with syntax highlighting
    btop
    bun
    clang
    difftastic
    direnv
    eza # replaces `ls` with enhanced features
    fish # prio over pacman installed fish (i want updates)
    fzf
    gawk
    lazygit # `lazygit` for git UI
    neovim
    nushell
    ripgrep # for fast searching  (rust)
    ruff
    shfmt
    tmux
    universal-ctags
    vim
    yazi
    zellij
    zig
    zoxide
  ];
}
