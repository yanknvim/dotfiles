{ config, pkgs, lib, ... }:
{
  home.username = "yank";

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    deno
    kitty
    neovim
    fastfetch
    tree
    fzf
    bat
  ];

  programs.git = {
    enable = true;

    userName = "yank.nvim";
    userEmail = "yanknvim@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      v = "nvim";
    };
  };

  programs.starship.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.file = {
    ".config/nvim" = {
      source = ../../config/nvim;
      recursive = true;
    };
    ".config/kitty" = {
      source = ../../config/kitty;
      recursive = true;
    };
  };
}
