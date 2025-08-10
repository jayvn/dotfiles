{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "my-packages";
  paths = with pkgs; [
    bun
    clang
    direnv
    eza
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
