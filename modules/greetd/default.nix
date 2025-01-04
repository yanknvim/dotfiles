{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        user = "yank";
        command = "Hyprland";
      };
      default_session = {
        user = "yank";
        command = "Hyprland";
      };
    };
  };
}
