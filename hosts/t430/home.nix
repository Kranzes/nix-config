{ config, pkgs, ... }:

{

  home-manager = {
    useGlobalPkgs = true;
    users = {
      kranzes = {
        imports = [
          ./home-manager/packages.nix
          ./home-manager/music.nix
          ./home-manager/terminal.nix
#          ./home-manager/launcher.nix
          ./home-manager/keyboard.nix
          ./home-manager/bspwm.nix
          ./home-manager/polybar.nix
          ./home-manager/shell.nix
          ./home-manager/screen-lock.nix
          ./home-manager/gtk.nix
          ./home-manager/autorandr.nix
        ];
      };
    };
  };


}

