{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "my-packages";
  paths = with pkgs; [
    # zsh # not doing this cuz everyone looks at /bin/zsh not nix folder
    atuin
    bat
    btop
    bun
    clang
    difftastic
    direnv
    eza
    # firefox
    fzf
    lazygit
    neovim
    nushell
    # openblas
    ripgrep
    ruff
    shfmt
    tmux
    universal-ctags
    vim
    # vscode #Non free, not needed for wsl
    yazi
    zellij
    zig
    zoxide
  ];
}
