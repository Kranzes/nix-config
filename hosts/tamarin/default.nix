{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home
    inputs.self.nixosModules.hosted-podman
  ]
  ++ (with inputs.self.nixosModules; [
    profiles-android
    profiles-audio
    profiles-laptop
    profiles-hyprland
  ]);

  system.etc.overlay.enable = true;

  time.timeZone = null; # Set manually, because I travel often.

  system.stateVersion = "25.11";
}
