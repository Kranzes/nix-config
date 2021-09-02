{ config, pkgs, ... }:

{
  home-manager.users.kranzes = {
    imports = [
      #      ./games.nix
      ./music.nix
      ./bspwm.nix
    ];
  };
}
