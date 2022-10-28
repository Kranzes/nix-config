{ lib, headless, ... }:

{
  imports = [
    ./ssh.nix
    ./nix-nixpkgs.nix
  ] ++ lib.optionals (!headless) [ ./xorg.nix ];
}
