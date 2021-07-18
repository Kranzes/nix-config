{
  description = "My NixOS configuration";

  inputs = {
    # nixpkgs-unstable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs-2105
    nixpkgs-2105.url = "github:NixOS/nixpkgs/nixos-21.05";

    # home-manager-unstable
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # home-manager-2105
    home-manager-2105 = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs-2105";
    };
  };

  outputs = { nixpkgs-unstable, nixpkgs-2105, home-manager-unstable, home-manager-2105, ... }@inputs:

  {
    nixosConfigurations = import ./hosts inputs;
  };
}
