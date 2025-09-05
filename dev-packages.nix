{ pkgs ? import <nixpkgs> {} }:

pkgs.buildEnv {
  name = "dev-packages";
  paths = with pkgs; [
    # atuin # search history and all
    bash-language-server # for nvim
    bat # like cat with syntax highlighting
    bottom # like top/btop
    bun # instead of npm
    clang
    # cmake # migrated but not sure
    curl
    difftastic # git diff
    # direnv
    # eza # replaces `ls` with enhanced features
    # fish # new shell i want to try
    # fzf
    htop 
    lazygit # `lazygit` for git UI
    neovim
    # nixfmt-rfc-style # nix formatter # downloads a lot of haskell
    nushell # nu shell+ csv view sort, etc
    ripgrep # for fast searching  (rust)
    # ruff # formatter + isort # NOTE: comment it out because 
    shfmt # bash/zsh formatter
    tlrc # tldr for commands
    tmux
    universal-ctags
    vim
    xclip
    yazi # file explorer
    zellij # instead of tmux
    zoxide # z search instead of cd
    zsh # prio over system installed zsh, but keep it because other tools use it
    zsh-autosuggestions # ditching oh-my-zsh 
    zsh-syntax-highlighting# ditching oh-my-zsh 
  ];
}
