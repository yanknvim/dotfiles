{ config, lib, pkgs, inputs, ... }:

{
  programs.zellij = {
    enable = true;
    settings = {};
  };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}
