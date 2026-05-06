{ config, pkgs, ... }:

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

  services = {
    tuned = {
      enable = true;
      ppdSettings = {
        main.default = "power-saver";
        battery = {
          inherit (config.services.tuned.ppdSettings.profiles) power-saver;
        };
      };
    };
    tlp.enable = false;
  };
}
