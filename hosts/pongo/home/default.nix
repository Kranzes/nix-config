{ lib, ... }:

{
  home-manager.users.kranzes = {
    imports = [
      ./music.nix
    ];

    programs.alacritty.settings.font.size = lib.mkForce 8;

    wayland.windowManager.hyprland.settings.bind = [
      "$mod ALT, M, exec, fuzzel-mpd"
    ];
  };
}
