{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
    settings.substituters = [
      "https://nix-community.cachix.org"
    ];
    settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';
  };
}
