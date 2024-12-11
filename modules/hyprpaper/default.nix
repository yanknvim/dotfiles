{ config, pkgs, ... }:
{
  imports = [];
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      preload = "/home/yank/.bg.jpg";
      wallpaper = ", /home/yank/.bg.jpg";
    };
  };

  home.file = {
    ".bg.jpg" = {
      source = ./bg.jpg;      
    };
  };
}
