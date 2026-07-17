{ config, lib, pkgs, inputs, ... }:

{
  stylix = {
    targets = {
      neovim.enable = true;
      ghostty.enable = true;
      btop.enable = true;
      gtk.enable = true;
      yazi.enable = true;
      zellij.enable = true;
    };

    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    opacity = {
      terminal = 0.70;
    };
  };
}
