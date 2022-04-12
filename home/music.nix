{ config, pkgs, self, ... }:

{
  services.mpd = {
    enable = true;
    dataDir = "/home/kranzes/.config/mpd";
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
    self.packages."${pkgs.system}".rofi-mpd
  ];
}

