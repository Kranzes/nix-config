{
  # Used by some programs.
  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  # Needed for some YubiKey functionalities.
  services.pcscd.enable = true;

  services.kanidm = {
    enableClient = true;
    clientSettings = {
      uri = "https://idm.ilanjoselevich.com";
      verify_ca = true;
      verify_hostnames = true;
    };
  };
}
