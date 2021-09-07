{
  description = "My NixOS configuration";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake-utils-plus
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    # rnix-lsp
    rnix-lsp.url = "github:nix-community/rnix-lsp";
  };


  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:

    flake-utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        self.overlay
      ];

      channelsConfig.allowUnfree = true;

      hostDefaults = {
        modules = [
          inputs.home-manager.nixosModule
          ./home
          ./modules
          {
            nix = {
              generateRegistryFromInputs = true;
              generateNixPathFromInputs = true;
              linkInputs = true;
            };
          }
        ];
      };

      hosts = {
        pongo.modules = [
          ./hosts/pongo
          ./hosts/pongo/home
        ];

        pan.modules = [
          ./hosts/pan
          ./hosts/pan/home
        ];
      };

      overlay = import ./overlays { inherit inputs; };
    };

}
