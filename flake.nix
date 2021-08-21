{
  description = "My NixOS configuration";

  inputs = {
    # nixpkgs-unstable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nixpkgs-2105
    nixpkgs-2105.url = "github:NixOS/nixpkgs/nixos-21.05";

    # flake-utils-plus
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";

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

    # rnix-lsp
    rnix-lsp.url = "github:nix-community/rnix-lsp";
  };


  outputs = { self, nixpkgs-unstable, nixpkgs-2105, flake-utils, home-manager-unstable, home-manager-2105, ... }@inputs:

    flake-utils.lib.mkFlake {
      inherit self inputs;

      sharedOverlays = [
        self.overlay
      ];

      channelsConfig.allowUnfree = true;

      hostDefaults = {
        channelName = "nixpkgs-unstable";
        modules = [
          inputs.home-manager-unstable.nixosModule
          ./home
          ./modules
          { nix.generateRegistryFromInputs = true; }
        ];
      };

      hosts.desktop.modules = [
        ./hosts/desktop
        ./hosts/desktop/home
      ];

      hosts.t430.modules = [
        ./hosts/t430
        ./hosts/t430/home
      ];

      overlay = import ./overlays { inherit inputs; };
    };

}
