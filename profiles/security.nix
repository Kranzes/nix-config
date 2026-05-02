{ config, pkgs, ... }:

{
  # Used by some programs.
  security.pam.services.greetd.enableGnomeKeyring = config.services.greetd.enable;
  services.gnome.gnome-keyring.enable = config.services.greetd.enable;
  services.gnome.gcr-ssh-agent.enable = false;

  # Needed for some YubiKey functionalities.
  services.pcscd.enable = config.services.graphical-desktop.enable;

  services.kanidm = {
    package = pkgs.kanidm_1_9;
    client = {
      enable = true;
      settings = {
        uri = "https://idm.ilanjoselevich.com";
        verify_ca = true;
        verify_hostnames = true;
      };
    };
  };
}
