{ config, pkgs, lib, ... }:
{
  home.username = "yank";
  home.homeDirectory = lib.mkForce "/Users/yank";

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    kitty
    neovim
    fastfetch
  ];
}
