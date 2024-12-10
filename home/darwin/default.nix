{ pkgs, lib, ... }:
{
  imports = [
    ../base
  ];

  home.homeDirectory = lib.mkForce "/Users/yank";
}
