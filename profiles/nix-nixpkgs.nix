{ pkgs, inputs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      home-manager.flake = inputs.home-manager;
    };
    nixPath = [
      "nixpkgs=flake:nixpkgs"
      "home-manager=flake:home-manager"
    ];
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "cgroups"
        "auto-allocate-uids"
        "repl-flake"
        "no-url-literals"
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
