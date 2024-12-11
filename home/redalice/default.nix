{ pkgs, lib, ... }:
{
  imports = [
    ../base
    ../../modules/waybar
    ../../modules/hyprland
    ../../modules/hyprpaper
  ];

  home.homeDirectory = lib.mkForce "/home/yank";
  
  home.packages = with pkgs; [
    mako
    wofi
    waybar
    hyprpaper
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
