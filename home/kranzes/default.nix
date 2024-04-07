{ inputs, lib, ... }:

{
  home.stateVersion = "22.05";

  catppuccin = {
    flavour = lib.mkDefault "macchiato";
    accent = lib.mkDefault "lavender";
  };

  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
    ./packages.nix
    ./programs.nix
    ./fonts.nix
    ./services.nix
    ./editors.nix
    ./terminal.nix
    ./ssh.nix
    ./git.nix
    ./launcher.nix
    ./keyboard.nix
    ./bspwm.nix
    ./notifications.nix
    ./polybar.nix
    ./screen-lock.nix
    ./shell.nix
    ./gtk-qt.nix
    ./devel.nix
    ./browser.nix
  ];
}
