{ config, pkgs, inputs, ... }:

{
  home-manager = {
    useGlobalPkgs = true;
    sharedModules = [ inputs.nix-colors.homeManagerModule inputs.discocss.hmModule ];
    users = {
      kranzes = {
        home.stateVersion = "22.05";
        colorscheme = inputs.nix-colors.colorSchemes.nord;
        imports = [
          ./packages.nix
          ./programs.nix
          ./services.nix
          ./editors.nix
          ./music.nix
          ./terminal.nix
          ./ssh-gpg.nix
          ./git.nix
          ./launcher.nix
          ./keyboard.nix
          ./bspwm.nix
          ./xresources.nix
          ./notifications.nix
          ./polybar.nix
          ./screen-lock.nix
          ./shell.nix
          ./gtk-qt.nix
          ./devel.nix
          ./browser.nix
        ];
      };
    };
  };
}
