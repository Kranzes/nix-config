{ config, lib, headless, ... }:

{
  imports = [
    ./ssh.nix
    ./nix-nixpkgs.nix
    ./cachix-deploy.nix
  ] ++ lib.optionals (!headless) [ ./xorg.nix ];
}
