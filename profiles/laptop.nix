{ pkgs, ... }:

{
  # For changing display brightness.
  environment.systemPackages = [ pkgs.brightnessctl ];

  # For WiFi.
  networking.networkmanager.enable = true;
}
