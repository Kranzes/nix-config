{
  description = "My nix flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nur.url = "github:nix-community/NUR";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nix-colors.url = "github:misterio77/nix-colors";
    discocss = { url = "github:mlvzk/discocss/flake"; inputs.nixpkgs.follows = "nixpkgs"; };
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixinate = { url = "github:MatthewCroughan/nixinate"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = { self, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      lib = import ./lib inputs;

      nixosConfigurations = import ./hosts inputs;

      packages.${system} = import ./packages inputs;

      apps = inputs.nixinate.nixinate.${system} self;

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [ pkgs.nixpkgs-fmt inputs.agenix.defaultPackage.${system} pkgs.age-plugin-yubikey ];
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
