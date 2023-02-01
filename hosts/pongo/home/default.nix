{ pkgs, ... }:

{
  home-manager.users.kranzes = {
    imports = [
      ./music.nix
      ./bspwm.nix
      ./gaming.nix
    ];
    home.packages = with pkgs; [ lutris ];
  };
}
