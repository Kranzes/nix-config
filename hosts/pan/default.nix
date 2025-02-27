{ inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./xserver.nix
      ./home
    ]
    ++ (with inputs.self.nixosModules; [
      profiles-android
      profiles-audio
      profiles-laptop
      profiles-xserver
    ]);

  system.stateVersion = "24.05";
}
