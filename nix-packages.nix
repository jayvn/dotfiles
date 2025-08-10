{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "my-packages";
  paths = with pkgs; [
    # zsh # not doing this cuz everyone looks at /bin/zsh
    bat
    btop
    bun
    clang
    difftastic
    direnv
    eza
    firefox
    fzf
    lazygit
    neovim
    openblas
    ripgrep
    ruff
    shfmt
    tmux
    universal-ctags
    vim
    vscode
    yazi
    zig
    zoxide
  ];
}
