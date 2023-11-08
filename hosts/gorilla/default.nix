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
    profiles-opengl
    profiles-xserver
  ]);


  time.timeZone = "Atlantic/Canary";

  system.stateVersion = "23.11";
}
