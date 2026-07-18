{ config, lib, pkgs, inputs, ... }:

{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    polarity = "dark";

    cursor = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      size = 24;
    };

    fonts = {
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans CJK JP";
      };
      monospace = {
        package = pkgs.nerd-fonts.monaspace;
        name = "MonaspiceAr Nerd Font";
      };
      sizes = {
        applications = 11;
        desktop = 11;
        terminal = 11;
        popups = 11;
      };
    };

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
