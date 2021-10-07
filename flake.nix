{
  description = "My nix flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nur = { url = "github:nix-community/NUR"; inputs.nixpkgs.follows = "nixpkgs"; };
  };


  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:

    flake-utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        self.overlay
        inputs.nur.overlay
      ];

      channelsConfig.allowUnfree = true;

      hostDefaults = {
        modules = [
          inputs.home-manager.nixosModule
          ./home
          ./modules
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

      outputsBuilder = channels: with channels.nixpkgs;{
        devShell = mkShell {
          buildInputs = [ nixpkgs-fmt lefthook ];
        };
      };
    };
}
