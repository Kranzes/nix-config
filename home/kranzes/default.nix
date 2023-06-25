{ inputs, ... }:

{
  home.stateVersion = "22.05";
  colorscheme = inputs.nix-colors.colorSchemes.nord;
  imports = [
    ./packages.nix
    ./programs.nix
    ./services.nix
    ./editors.nix
    ./terminal.nix
    ./ssh.nix
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
}
