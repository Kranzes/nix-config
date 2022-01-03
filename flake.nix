{
  description = "My nix flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nur = { url = "github:nix-community/NUR"; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nix-colors.url = "github:misterio77/nix-colors";
    discocss = { url = "github:mlvzk/discocss/flake"; inputs.nixpkgs.follows = "nixpkgs"; };
    pre-commit-hooks = { url = "github:cachix/pre-commit-hooks.nix"; inputs.nixpkgs.follows = "nixpkgs"; };
  };


  outputs = { self, nixpkgs, flake-utils, home-manager, pre-commit-hooks, ... }@inputs:

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
          ./modules/nix.nix
          ./modules/ssh.nix
        ];
      };

      hosts = {
        pongo.modules = [
          ./hosts/pongo
          ./hosts/pongo/home
          ./home
          ./modules
          home-manager.nixosModule
        ];

        pan.modules = [
          ./hosts/pan
          ./hosts/pan/home
          ./home
          ./modules
          home-manager.nixosModule
        ];

        hylobatidae.modules = [
          ./hosts/hylobatidae
        ];
      };

      overlay = import ./overlays { inherit inputs; };

      outputsBuilder = channels: with channels.nixpkgs; {
        devShell = mkShell {
          packages = [ nixpkgs-fmt lefthook ];
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };

        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks.nixpkgs-fmt.enable = true;
          hooks.shellcheck.enable = true;
        };
      };
    };
}
