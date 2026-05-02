{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Why is Nano even the default???
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # For mounting USB drives from GUI.
  services.gvfs.enable = config.services.graphical-desktop.enable;

  # Packages that shoulds always be available.
  environment.systemPackages = with pkgs; [
    wget
    gitMinimal
    tree
    htop
  ];

  # I live in Israel still :(
  time.timeZone = lib.mkDefault "Asia/Jerusalem";
}
