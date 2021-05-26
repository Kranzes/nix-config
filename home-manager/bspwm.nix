{ config, pkgs, ... }:
{

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      startupPrograms = [
        "${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${pkgs.fetchurl { url = "https://i.redd.it/4s62fcy37st61.jpg"; sha256 = "18i9l38msi3asr7wvkf3j6lvhbbgr5ms6vp5cc08m2k0f7ch1dh7"; }}"
        "pgrep -fl '$HOME/.local/bin/pidswallow -gl' || $HOME/.local/bin/pidswallow -gl"
        "nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'"
      ];
      extraConfig = ''
        # pidswallow
        export PIDSWALLOW_SWALLOW_COMMAND='bspc node $pwid --flag hidden=on'
        export PIDSWALLOW_VOMIT_COMMAND='bspc node $pwid --flag hidden=off'
        export PIDSWALLOW_PREGLUE_HOOK='bspc query -N -n $pwid.floating >/dev/null && bspc node $cwid --state floating'
      '';
      settings = {
        remove_disabled_monitors = true;
        remove_unplugged_monitors = true;
        focused_border_color = "#88C0D0";
        border_width = 2;
        window_gap = 15;
      };
      monitors = { DP-0 = [ "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "IX" "X" ]; };
      rules = {
        "Zathura" = {
          state = "tiled";
        };
      };
    };
  };

  ###-PIDSWALLOW-###

  # fetch pidswallow
  home.file.".local/bin/pidswallow" = {
    executable = true;
    source = "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Liupold/pidswallow/master/pidswallow";
        sha256 = "0x86zsd2hd6maz21b8g7gxa1qbbpdb7722x2cyprc35l1nys3qdv";
      }}";
  };

  # dependencies for pidswallow
  home.packages = with pkgs; [ xdo xorg.xev xorg.xprop xdotool getopt psmisc ps ];

}
