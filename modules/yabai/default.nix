{ config, pkgs, ... }:
{
  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";
      window_gap = 5;
      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
    };
  };
}
