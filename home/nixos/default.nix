{ pkgs, lib, ... }: {
  imports = [
    ../base
  ];

  home.homeDirectory = lib.mkForce "/home/yank";
}
