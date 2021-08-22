{
  description = "My NixOS configuration";

  inputs = {
    # nixpkgs-unstable
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # home-manager-unstable
    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # flake-utils-plus
    flake-utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";

    # rnix-lsp
    rnix-lsp.url = "github:nix-community/rnix-lsp";
  };


  outputs = { self, nixpkgs-unstable, home-manager-unstable, flake-utils, ... }@inputs:

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
