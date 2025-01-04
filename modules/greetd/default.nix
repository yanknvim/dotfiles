{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "yank";
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
      };
    };
  };
}
