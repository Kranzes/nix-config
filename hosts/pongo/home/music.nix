{ pkgs, ... }:

{
  services.mpd.musicDirectory = "/home/4TB-HDD/Media/Music";
  programs.beets = {
    enable = true;
    package = pkgs.beets.override {
      pluginOverrides = {
        fetchart.enable = true;
        mpdupdate.enable = true;
      };
    };
    settings = {
      plugins = [ "permissions" "mpdupdate" "fetchart" ];
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
      fetchart = {
        sources = [ "filesystem" ];
      };
      mpd = {
        host = "localhost";
        port = 6600;
      };
    };
  };
}
