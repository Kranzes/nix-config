{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./xserver.nix
    ./hosted
    ./home
  ] ++ (with inputs.self.nixosModules; [
    profiles-android
    profiles-audio
    profiles-xserver
  ]);

  system.stateVersion = "23.11";
}
