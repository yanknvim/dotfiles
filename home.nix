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
  ];

  home.file = {
    ".config/nvim" = {
      source = ./config/nvim;
      recursive = true;
    };
    ".config/kitty" = {
      source = ./config/kitty;
      recursive = true;
    };
  };
}
