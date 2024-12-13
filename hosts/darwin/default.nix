{ pkgs, ... }:
{
  imports = [
    ../../modules/yabai
    ../../modules/skhd
  ];
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  system.stateVersion = 5;
}
