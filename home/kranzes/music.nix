{ config, pkgs, inputs, ... }:

{
  services.mpd = {
    enable = true;
    dataDir = "${config.xdg.dataHome}/mpd";
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
}

