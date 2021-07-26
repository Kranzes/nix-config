{ config, pkgs, ... }:

{

  home-manager = {
    useGlobalPkgs = true;
    users = {
      kranzes = {
        imports = [
          ./home-manager/autorandr.nix
          ./home-manager/bspwm.nix
          ./home-manager/editors.nix
          ./home-manager/git.nix
          ./home-manager/gtk-qt.nix
          ./home-manager/keyboard.nix
          ./home-manager/launcher.nix
          ./home-manager/music.nix
          ./home-manager/notifications.nix
          ./home-manager/packages.nix
          ./home-manager/polybar.nix
          ./home-manager/programs.nix
          ./home-manager/screen-lock.nix
          ./home-manager/services.nix
          ./home-manager/shell.nix
          ./home-manager/ssh-gpg.nix
          ./home-manager/terminal.nix
          ./home-manager/xresources.nix
        ];
      };
    };
  };


}

