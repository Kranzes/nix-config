{
  inputs,
  lib,
  osConfig,
  ...
}:

{
  home = {
    stateVersion = "22.05";
    enableNixpkgsReleaseCheck = false;
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = lib.mkDefault "macchiato";
    accent = lib.mkDefault "lavender";
  };

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./editors.nix
    ./git.nix
    ./shell.nix
    ./devel.nix
    ./slop.nix
  ]
  ++ lib.optionals osConfig.services.graphical-desktop.enable [
    ./packages.nix
    ./programs.nix
    ./fonts.nix
    ./services.nix
    ./terminal.nix
    ./ssh.nix
    ./hyprland.nix
    ./noctalia.nix
    ./fuzzel.nix
    ./gtk-qt.nix
    ./browser.nix
  ];
}
