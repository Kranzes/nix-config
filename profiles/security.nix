{ config, pkgs, ... }:

{
  security.sudo.enable = false;

  security.run0 = {
    enable = true;
    sudo-shim.enable = true;
    persistentAuth = {
      enable = true;
      enableRemote = true;
    };
  };

  # Cache auth for 30s
  security.polkit.settings.Polkitd.ExpirationSeconds = 30;

  system.tools.nixos-rebuild.enableRun0Elevation = true;

  # Used by some programs.
  security.pam.services.greetd.enableGnomeKeyring = config.services.greetd.enable;
  services.gnome.gnome-keyring.enable = config.services.greetd.enable;
  services.gnome.gcr-ssh-agent.enable = false;

  # Needed for some YubiKey functionalities.
  services.pcscd.enable = config.services.graphical-desktop.enable;

  security.tpm2.enable = true;

  services.kanidm = {
    package = pkgs.kanidm_1_10;
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
