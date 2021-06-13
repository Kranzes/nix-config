{ config, pkgs, ... }:

{

  services.mpd = {
    enable = true;
    package = pkgs.mpd;
    dataDir = "/home/kranzes/.config/mpd";
    musicDirectory = "/home/4TB-HDD/Media/Music";
    network = {
      listenAddress = "any";
      port = 6600;
    };
    extraConfig = ''     
      audio_output {
        type    "pulse"
        name    "Pulseaudio"
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
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp;
    settings = {
      ncmpcpp_directory = "/home/kranzes/.config/ncmpcpp";
      lyrics_directory = "/home/kranzes/.cache/lyrics";
      progressbar_look = "▄▄";
      media_library_primary_tag = "album_artist";
      follow_now_playing_lyrics = "yes";
      screen_switcher_mode = "playlist, media_library";
      display_bitrate = "yes";
    };
  };

  home.packages = with pkgs; [
    mpc_cli
    cantata
    cava
    spek
  ];

  programs.beets = {
    enable = true;
    package = (pkgs.beets.override {
      enableExtraFiles = true;
      enableMpd = true; });
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

