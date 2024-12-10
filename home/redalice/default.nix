{ pkgs, lib, ... }:
{
  imports = [
    ../base
    ../../modules/hyprland
    ../../modules/waybar
  ];

  home.homeDirectory = lib.mkForce "/home/yank";
  
  home.packages = with pkgs; [
    mako
    wofi
    waybar
    firefox
    helvum
    skktools
    feh
    grim
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [ fcitx5-skk fcitx5-gtk ];
    };
  };
}
