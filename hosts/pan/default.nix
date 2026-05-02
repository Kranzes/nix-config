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

  system.stateVersion = "24.05";
}
