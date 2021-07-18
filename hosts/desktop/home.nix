{ config, pkgs, ... }:

{

  home-manager = {
    useGlobalPkgs = true;
    users = {
      kranzes = {
        imports = [
          ./home-manager/packages.nix
          ./home-manager/programs.nix
          ./home-manager/services.nix
          ./home-manager/editors.nix
          ./home-manager/music.nix
          ./home-manager/terminal.nix
          ./home-manager/ssh-gpg.nix
          ./home-manager/git.nix
          ./home-manager/launcher.nix
          ./home-manager/keyboard.nix
          ./home-manager/bspwm.nix
          ./home-manager/xresources.nix
          ./home-manager/notifications.nix
          ./home-manager/polybar.nix
          ./home-manager/screen-lock.nix
          ./home-manager/shell.nix
          ./home-manager/gtk-qt.nix
          ./home-manager/games.nix
          ./home-manager/espanso.nix
        ];
      };
    };
  };


}

