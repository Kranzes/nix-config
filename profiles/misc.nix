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

  # Home-manager requires it so it can manage GTK.
  programs.dconf.enable = config.services.xserver.enable;

  # For mounting USB drives from GUI.
  services.gvfs.enable = config.services.xserver.enable;

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
