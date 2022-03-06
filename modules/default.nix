{ config, pkgs, ... }:

{
  imports = [
    ./ssh.nix
    ./xorg.nix
    ./nix.nix
  ];
  services.tailscale.enable = true;
}
