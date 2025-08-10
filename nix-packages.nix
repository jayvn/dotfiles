{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "my-packages";
  paths = with pkgs; [
    bun
    clang
    shfmt
    bat
    firefox
    direnv
    eza
    tmux
    vim
    zsh
    ripgrep
    btop
    zoxide
    difftastic
    lazygit
    neovim
    openblas
    ruff
    universal-ctags
    vscode
    yazi
    zig
  ];
}
