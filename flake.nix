{
  description = "My nix flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nur = { url = "github:nix-community/NUR"; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim-nightly = { url = "github:nix-community/neovim-nightly-overlay"; inputs.nixpkgs.follows = "nixpkgs"; };
    nix-colors.url = "github:misterio77/nix-colors";
    discocss = { url = "github:mlvzk/discocss/flake"; inputs.nixpkgs.follows = "nixpkgs"; };
  };


  outputs = { self, nixpkgs, flake-utils, ... }@inputs:

    flake-utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        self.overlay
        inputs.nur.overlay
        inputs.neovim-nightly.overlay
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
