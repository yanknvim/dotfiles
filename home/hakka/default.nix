{ pkgs, lib, ...}:
{
  imports = [
    ../base
    ../../modules/hyprland
    ../../modules/hyprpaper
  ];

  home.homeDirectory = lib.mkForce "/home/yank";
}
