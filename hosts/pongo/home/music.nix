{ config, pkgs, inputs, ... }:

{
  services.mpd = {
    enable = true;
    dataDir = "${config.xdg.dataHome}/mpd";
    musicDirectory = "/home/4TB-HDD/Media/Music";
    network = {
      listenAddress = "any";
      port = 6600;
    };
    extraConfig = ''     
      audio_output {
        type    "pipewire"
        name    "pipewire"
      }
      auto_update "yes"
    '';
  };

  systemd.user.services.yams = {
    Unit = {
      Description = "Last.FM scrobbler for MPD";
      After = [ "mpd.service" ];
    };
    Service = {
      ExecStart = "${pkgs.yams}/bin/yams -N";
      Environment = "NON_INTERACTIVE=1";
      Restart = "always";
    };
    Install.WantedBy = [ "default.target" ];
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
      lyrics_fetchers = "musixmatch, azlyrics";
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

  home.packages = with pkgs; [
    mpc_cli
    inputs.self.packages."${pkgs.system}".rofi-mpd
  ];

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
