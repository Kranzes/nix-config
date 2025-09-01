{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./xserver.nix
    ./hosted
    ./home
  ]
  ++ (with inputs.self.nixosModules; [
    profiles-android
    profiles-audio
    profiles-xserver
  ]);

  services.tailscale.useRoutingFeatures = "both";

  system.stateVersion = "25.11";
}
