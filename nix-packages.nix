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
    fzf
    lazygit
    neovim
    nushell
    ripgrep
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
