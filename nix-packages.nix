{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "my-packages";
  paths = with pkgs; [
    bun
    clang
    shfmt
    direnv
    eza
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
