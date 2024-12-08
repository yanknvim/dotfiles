{ pkgs, lib, ... }: {
  imports = [
    ../base
  ];

  home.homeDirectory = lib.mkForce "/home/yank";
  
  home.packages = with pkgs; [
    mako
    wofi
    waybar
    luakit
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      exec-once = [
        "waybar"
        "mako"
      ];

      "$mainMod" = "SUPER";
      "$terminal" = "kitty";
      "$browser" = "WEBKIT_DISABLE_COMPOSITING_MODE=1 luakit";
      "$menu" = "wofi --show drun";

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, d, exec, $menu"
        "$mainMod, b, exec, $browser"
        "$mainMod SHIFT, q, killactive"
        "$mainMod, mouse:274, killactive"
        "$mainMod SHIFT, e, exit"
        "$mainMod, f, fullscreen"
        "$mainMod SHIFT, f, togglefloating"

        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, r"
        "$mainMod, SPACE, cyclenext"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        "col.active_border" = "rgba(adebb3ee)";
        "col.inactive_border" = "rgba(595959aa)";
        
        layout = "dwindle";
        allow_tearing = false;
      };

      decoration = {
        rounding = 10;
        
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = [{
      height = 20;
      layer = "top";
      position = "top";

      modules-left = [ "hyprland/workspaces" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "clock" ];

      clock = {
        format = "{:%H:%M}";
      };
    }];
  };
}
