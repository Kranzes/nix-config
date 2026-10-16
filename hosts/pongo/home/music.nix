{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{
  services.mpd = {
    enable = true;
    dataDir = "${config.xdg.dataHome}/mpd";
    musicDirectory = "/home/4TB-HDD/Media/Music";
    extraConfig = ''
      audio_output {
        type    "pipewire"
        name    "pipewire"
      }
      auto_update "yes"
    '';
  };

  services.rescrobbled = {
    enable = true;
    settings = {
      lastfm-key-file = "${config.xdg.configHome}/rescrobbled/lastfm-key";
      lastfm-secret-file = "${config.xdg.configHome}/rescrobbled/lastfm-token";
      player-whitelist = [ "^mpd$" ];
    };
  };

  programs.ncmpcpp = {
    enable = true;
    settings = {
      screen_switcher_mode = "playlist, media_library";
      media_library_primary_tag = "album_artist";
      progressbar_look = "▄▄";
      display_bitrate = "yes";
      lyrics_directory = "${config.xdg.cacheHome}/lyrics";
      follow_now_playing_lyrics = "yes";
    };
  };

  services.mpd-discord-rpc = {
    enable = true;
    settings = {
      format = {
        details = "$title";
        state = "$artist";
        large_text = "$album";
        small_image = "";
      };
    };
  };

  services.mpdris2-rs.enable = true;

  home.packages = with pkgs; [
    mpc
    inputs.self.packages."${pkgs.stdenv.hostPlatform.system}".fuzzel-mpd
  ];

  programs.beets = {
    enable = true;
    package = pkgs.python3.pkgs.toPythonApplication (
      pkgs.python3.pkgs.beets-minimal.override {
        pluginOverrides = lib.genAttrs config.programs.beets.settings.plugins (_: {
          enable = true;
        });
      }
    );
    settings = {
      plugins = [
        "permissions"
        "fetchart"
        "mpdupdate"
      ];
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
