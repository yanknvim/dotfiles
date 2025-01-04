{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";

      modules-center = [ "hyprland/workspaces" "clock" ];

      "hyprland/workspaces" = {
        format = "{icon}";
        tooltip = false;
        all-outputs = true;
        format-icons = {
          active = "";
          default = "";
        };
      };

      clock = {
        format = "{:%H:%M}";
      };
    }];

    style = ''
    * {
      font-size: 16px;
      border: none;
    }

    window#waybar {
      background: transparent;
    }

    #workspaces {
      border-radius: 10px;
      background-color: #11111b;
      color: #b4befe;
      margin-top: 8px;
      margin-left: 15px;
      margin-right: 15px;
      padding-top: 1px;
      padding-bottom: 1px;
      padding-left: 10px;
      padding-right: 10px;
    }

    #workspaces button {
      background: #11111b;
      color: #b4befe;
    }

    #clock, #backlight, #pulseaudio, #bluetooth, #network, #battery{
      border-radius: 10px;
      background-color: #11111b;
      color: #cdd6f4;
      margin-top: 8px;
      padding-top: 1px;
      padding-bottom: 1px;
      padding-left: 10px;
      padding-right: 10px;
      margin-right: 15px;
    }
    '';
  };
}
