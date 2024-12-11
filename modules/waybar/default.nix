{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    settings = [{
      height = 32;
      layer = "top";
      position = "top";

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "pulseaudio" "clock" ];

      "hyprland/window" = {
        format = "{}";
        rewrite = {
          "" = "Desktop";
        };
      };

      pulseaudio = {
        format = "{volume}%";
        on-click = "helvum";
      };

      clock = {
        format = "{:%H:%M}";
      };
    }];

    style = ''
    * {
      font-size: 12px;
      min-height: 0;
      border: none;
    }

    window#waybar {
      background: transparent;
      color: #eeeeee;
    }

    #workspaces {
      background: #303b39;
      border-radius: 16px;
      padding: 0px 4px;
      margin-left: 8px;
      margin-right: 8px;
    }

    #workspaces button {
      background: transparent;
      color: #888888;
      padding: 5px;
    }

    #workspaces button.active {
      background: transparent;
      color: #eeeeee;
    }

    #workspaces button:hover {
      box-shadow: inherit;
      text-shadow: inherit;
    }

    #window {
      background: #303b39;
      border-radius: 16px;
      padding: 0px 10px;
      margin-left: 8px;
      margin-right: 8px;
    }

    #pulseaudio,
    #clock {
      background: #303b39;
      border-radius: 16px;
      padding: 0px 10px;
      margin-left: 4px;
      margin-right: 4px;
    }
    '';
  };
}
