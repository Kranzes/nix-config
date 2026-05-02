{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./gaming.nix
    ./hosted
    ./home
  ]
  ++ (with inputs.self.nixosModules; [
    profiles-android
    profiles-audio
    profiles-hyprland
  ]);

  services.tailscale.useRoutingFeatures = "both";

  system.stateVersion = "25.11";
}
