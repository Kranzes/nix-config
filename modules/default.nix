{ config, pkgs, inputs, ... }:

{
  imports = [
    ./ssh.nix
    ./xorg.nix
    ./nix.nix
  ];
  services.tailscale.enable = true;
  nixpkgs.overlays = [ inputs.nur.overlay ];
}
