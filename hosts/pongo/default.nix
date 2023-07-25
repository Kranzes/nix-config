{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./xserver.nix
    ./hosted
    ./home
  ] ++ (with inputs.self.nixosModules; [
    android
    audio
    opengl
    security
    xserver
  ]);

  system.stateVersion = "23.11";
}
