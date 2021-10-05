{ config, pkgs, ... }:

{

  home-manager.users.kranzes = {
    imports = [
      ./autorandr.nix
      ./bspwm.nix
      ./shell.nix
      ./keyboard.nix
    ];
    services.mpd.musicDirectory = "/home/kranzes/Music";
  };
}
