{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home
  ]
  ++ (with inputs.self.nixosModules; [
    profiles-android
    profiles-audio
    profiles-laptop
    profiles-hyprland
  ]);

  time.timeZone = null; # Set manually, because I travel often.

  system.stateVersion = "25.11";
}
