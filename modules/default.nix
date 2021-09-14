{ config, pkgs, ... }:

{
  imports = [
    ./ssh.nix
    ./xorg.nix
  ];
}
