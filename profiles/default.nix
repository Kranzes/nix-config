{ lib, headless, ... }:

{
  imports = [
    ./ssh.nix
    ./nix-nixpkgs.nix
    ./tailscale.nix
  ] ++ lib.optionals (!headless) [ ./xorg.nix ];
}
