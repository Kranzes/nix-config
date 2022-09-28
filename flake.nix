{
  description = "My nix flake configuration";

  nixConfig.extra-substituters = [ "https://kranzes.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [ "kranzes.cachix.org-1:aZ9SqRdirTyygTRMfD95HMvIuzCoDcq2SmvNkaf9cnk=" ];

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nur.url = "github:nix-community/NUR";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nix-colors.url = "github:misterio77/nix-colors";
    discocss = { url = "github:mlvzk/discocss/flake"; inputs.nixpkgs.follows = "nixpkgs"; };
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixinate = { url = "github:MatthewCroughan/nixinate"; inputs.nixpkgs.follows = "nixpkgs"; };
    nil = { url = "github:oxalica/nil"; inputs.nixpkgs.follows = "nixpkgs"; };
    #hercules-ci-effects = { url = "github:hercules-ci/hercules-ci-effects"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      #hci-effects = inputs.hercules-ci-effects.lib.withPkgs pkgs;
    in
    {
      lib = import ./lib inputs;

      nixosConfigurations = import ./hosts inputs;

      packages.${system} = import ./packages inputs;

      apps = inputs.nixinate.nixinate.${system} self;

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [ pkgs.nixpkgs-fmt inputs.agenix.defaultPackage.${system} pkgs.age-plugin-yubikey ];
      };

      #effects = { branch, ... }: {
      #  deploy = hci-effects.runIf (branch == "master") (hci-effects.runCachixDeploy {
      #    deploy.agents = pkgs.lib.mapAttrs (_: x: x.config.system.build.toplevel) self.nixosConfigurations;
      #  });
      #};
    };
}
