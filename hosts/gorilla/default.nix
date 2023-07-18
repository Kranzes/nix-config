{
  imports = [
    ./hardware-configuration.nix
    ./xserver.nix
    ./home
  ];

  system.stateVersion = "23.11";
}
