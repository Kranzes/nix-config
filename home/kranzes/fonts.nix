{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    roboto
    font-awesome
    corefonts
    vistafonts
    culmus
  ];
}
