{ config, pkgs, ... }:
{
  imports = [];
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      preload = "/home/yank/.bg/bg.jpg";
      wallpaper = ", /home/yank/.bg/bg.jpg";
    };
  };

  home.file = {
    ".bg/bg.jpg" = {
      source = ../../bg/bg.jpg;      
    };
  };
}
