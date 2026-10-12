{ pkgs, ... }:

let
  configFile = pkgs.writeText "navidrome.json" (builtins.toJSON {
    MusicFolder = "/home/yank/Music";
    DataFolder = "/home/yank/.local/share/navidrome";
    Address = "0.0.0.0";
  });
in
{
  systemd.user.services.navidrome = {
    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = "${pkgs.navidrome}/bin/navidrome --configfile ${configFile}";
      Restart = "on-failure";
    };
  };
}
