{
  imports = [
    ./hardware-configuration.nix
    ./xserver.nix
    ./hosted
    ./home
  ];

  system.stateVersion = "23.11";
}
