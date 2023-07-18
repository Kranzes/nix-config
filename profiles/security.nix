{
  # Used by some programs.
  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;

  # Needed for some YubiKey functionalities.
  services.pcscd.enable = true;
}
