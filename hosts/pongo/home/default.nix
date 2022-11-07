{ pkgs, ... }:

{
  home-manager.users.kranzes = {
    imports = [
      ./music.nix
      ./bspwm.nix
    ];
    home.packages = with pkgs; [ lutris ];
  };
}
