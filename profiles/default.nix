{ lib, headless, ... }:

{
  imports = [
    ./ssh.nix
    ./nix-nixpkgs.nix
    ./tailscale.nix
    ./cachix-deploy.nix
  ] ++ lib.optionals (!headless) [ ./xorg.nix ];
}
