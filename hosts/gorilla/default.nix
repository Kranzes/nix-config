{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./xserver.nix
    ./home
  ] ++ (with inputs.self.nixosModules; [
    profiles-android
    profiles-audio
    profiles-laptop
    profiles-xserver
  ]);

  time.timeZone = null; # Set manually, because I travel often.

  system.stateVersion = "23.11";
}
