{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  home = {
    stateVersion = "22.05";
    enableNixpkgsReleaseCheck = false;
  };

  catppuccin = {
    enable = true;
    flavor = lib.mkDefault "macchiato";
    accent = lib.mkDefault "lavender";
  };

  home.file.".face".source = pkgs.fetchurl {
    url = "https://github.com/Kranzes.png";
    hash = "sha256-Am+xMAXUU7LlbsL62JyFYiNp30HktjZ5FZcD4ZhWTZU=";
  };

  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./packages.nix
    ./programs.nix
    ./fonts.nix
    ./services.nix
    ./editors.nix
    ./terminal.nix
    ./ssh.nix
    ./git.nix
    ./hyprland.nix
    ./noctalia.nix
    ./fuzzel.nix
    ./shell.nix
    ./gtk-qt.nix
    ./devel.nix
    ./browser.nix
    ./slop.nix
  ];
}
