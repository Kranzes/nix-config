{ pkgs, ... }:

{
  # For changing display brightness.
  environment.systemPackages = [ pkgs.brightnessctl ];

  # For WiFi.
  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        ControllerMode = "dual";
        Experimental = true;
      };
    };
  };
}
