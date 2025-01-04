{ pkgs, lib, ...}:
{
  imports = [
    ../base
    ../../modules/hyprland
    ../../modules/hyprpaper
    ../../modules/tofi
    ../../modules/waybar
  ];

  home.homeDirectory = lib.mkForce "/home/yank";

  home.packages = with pkgs; [
    webcord
    helvum
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-skk
      fcitx5-gtk
    ];
  };
}
