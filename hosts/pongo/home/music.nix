{ config, pkgs, inputs, lib, ... }:

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
    package = pkgs.beetsPackages.beets-minimal.override {
      pluginOverrides = lib.genAttrs config.programs.beets.settings.plugins (_: { enable = true; });
    };
    settings = {
      plugins = [ "permissions" "fetchart" "mpdupdate" ];
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

  services.easyeffects = {
    enable = true;
    preset = "SHP9500";
  };
  xdg.configFile."easyeffects/output/SHP9500.json".source = (pkgs.formats.json { }).generate "SHP9500.json" {
    output = {
      blocklist = [ ];
      "convolver#0" = {
        autogain = true;
        bypass = false;
        input-gain = 0;
        ir-width = 100;
        kernel-path = pkgs.fetchurl {
          url = "https://github.com/jaakkopasanen/AutoEq/raw/f624f4f7d0cfaf702fb206827abb5a54cf6be6ba/results/oratory1990/over-ear/Philips%20SHP9500/Philips%20SHP9500%20minimum%20phase%2048000Hz.wav";
          name = "Philips-SHP9500-minimum-phase-48000-Hz.irs";
          hash = "sha256-vZbUKMgrUDjp6X88cYEnakwMPMapXqfqlsgEE5bSN7I=";
        };
        output-gain = 0;
      };
      plugins_order = [ "convolver#0" ];
    };
  };
}
