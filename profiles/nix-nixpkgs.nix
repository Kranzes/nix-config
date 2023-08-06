{ inputs, ... }:
{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    channel.enable = false;
    nixPath = [
      "nixpkgs=flake:nixpkgs"
    ];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "cgroups"
        "auto-allocate-uids"
        "repl-flake"
      ];
      use-cgroups = true;
      auto-allocate-uids = true;
      builders-use-substitutes = true;
      auto-optimise-store = true;
      warn-dirty = false;
      trusted-users = [
        "@wheel"
      ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
}
