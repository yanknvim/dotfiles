{ config, lib, pkgs, ... }:

let
  colors = {
    base00 = "#191724";
    base01 = "#1f1d2e";
    base02 = "#26233a";
    base03 = "#6e6a86";
    base04 = "#908caa";
    base05 = "#e0def4";
    base06 = "#e0def4";
    base07 = "#524f67";
    base08 = "#eb6f92";
    base09 = "#f6c177";
    base0A = "#ebbcba";
    base0B = "#31748f";
    base0C = "#9ccfd8";
    base0D = "#c4a7e7";
    base0E = "#f6c177";
    base0F = "#524f67";
  };
in
{
  home.pointerCursor = {
    package = pkgs.rose-pine-cursor;
    name = "rose-pine";
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine";
    };
    iconTheme = {
      package = pkgs.rose-pine-icon-theme;
      name = "rose-pine";
    };
  };

  # GTK4 の設定も統一
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "rose-pine";
      icon-theme = "rose-pine";
      cursor-theme = "rose-pine";
      cursor-size = 24;
    };
  };
}
