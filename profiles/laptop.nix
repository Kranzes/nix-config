{
  # For changing display brightness.
  programs.light.enable = true;

  # For WiFi.
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # Set the time zone automatically when travelling.
  services.tzupdate.enable = true;
}
