{ config, pkgs, ... }:
{

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      startupPrograms = [
        "${pkgs.feh}/bin/feh --no-fehbg --bg-scale ${pkgs.fetchurl { url = "https://i.redd.it/4s62fcy37st61.jpg"; sha256 = "18i9l38msi3asr7wvkf3j6lvhbbgr5ms6vp5cc08m2k0f7ch1dh7"; }}"
        "pgrep $HOME/.local/bin/bspswallow || $HOME/.local/bin/bspswallow"
      ];
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

  # fetch pidswallow
  home.file.".local/bin/bspswallow" = {
    executable = true;
    source = "${pkgs.fetchurl {
        url = "https://github.com/JopStro/bspswallow/raw/master/bspswallow";
        sha256 = "1wpi8r7b4xfz8868rc6likv8ac0wjwhmdda6s14m5p2jvfk7jrcq";
      }}";
    };
  home.file.".config/bspwm/terminals".text = "Alacritty";


}
