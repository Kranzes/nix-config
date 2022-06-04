{ config, pkgs, inputs, ... }:

{
  imports = [
    ./ssh.nix
    ./xorg.nix
    ./nix-nixpkgs.nix
  ];
  services.tailscale.enable = true;
  services.pcscd.enable = true;
}
