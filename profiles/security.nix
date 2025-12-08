{ config, pkgs, ... }:

{
  # Used by some programs.
  security.pam.services.lightdm.enableGnomeKeyring = config.services.xserver.enable;
  services.gnome.gnome-keyring.enable = config.services.xserver.enable;

  # Needed for some YubiKey functionalities.
  services.pcscd.enable = config.services.xserver.enable;

  services.kanidm = {
    package = pkgs.kanidm_1_8;
    enableClient = true;
    clientSettings = {
      uri = "https://idm.ilanjoselevich.com";
      verify_ca = true;
      verify_hostnames = true;
    };
  };
}
