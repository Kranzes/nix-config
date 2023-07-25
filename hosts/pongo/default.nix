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
    xserver
  ]);

  system.stateVersion = "23.11";
}
