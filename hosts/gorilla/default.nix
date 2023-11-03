{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./xserver.nix
    ./home
  ] ++ (with inputs.self.nixosModules; [
    android
    audio
    laptop
    opengl
    xserver
  ]);


  time.timeZone = "Atlantic/Canary";

  system.stateVersion = "23.11";
}
