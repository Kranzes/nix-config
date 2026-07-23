{ lib, ... }:

{
  home-manager.users.kranzes = {
    imports = [
      ./music.nix
    ];

    programs.ghostty.settings.font-size = lib.mkForce 8;

    wayland.windowManager.hyprland.settings = {
      monitor = [
        {
          output = "DP-1";
          mode = "highres";
          position = "auto";
          scale = 1;
        }
      ];

      bind = [
        {
          _args = [
            "SUPER + ALT + M"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("fuzzel-mpd")'')
          ];
        }
      ];
    };
  };
}
