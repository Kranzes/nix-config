{ config, pkgs, ... }:

{
  services.mpd.musicDirectory = "/home/4TB-HDD/Media/Music";
  programs.beets = {
    enable = true;
    package = ((pkgs.beets.override {
      enableExtraFiles = true;
      enableMpd = true;
    }).overrideAttrs (_: {
      doInstallCheck = false;
    }));
    settings = {
      plugins = [ "permissions" "extrafiles" "mpdupdate" ];
      directory = "/home/4TB-HDD/Media/Music";
      library = "~/.local/share/musiclibrary.db";
      import = {
        copy = true;
        write = false;
        autotag = false;
      };
      paths = {
        default = "%upper{%left{$albumartist,1}}/$albumartist/$album/$track. $title";
      };
      permissions = {
        file = 755;
        dir = 755;
      };
      extrafiles = {
        patterns = {
          all = [ "*.*" ];
        };
      };
      mpd = {
        host = "localhost";
        port = 6600;
      };
    };
  };
}
