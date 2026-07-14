{ config, lib, pkgs, inputs, ... }:

{
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      launch_apps_as_systemd_services = true;
      wallpaper = {
        enabled = true;
        default.path = "/home/yank/Pictures/mousou_angel2.jpg";
      };
    };
  };
}
