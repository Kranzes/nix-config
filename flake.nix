{
  description = "My nix flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    nur.url = "github:nix-community/NUR";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nix-colors.url = "github:misterio77/nix-colors";
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nixinate = { url = "github:MatthewCroughan/nixinate"; inputs.nixpkgs.follows = "nixpkgs"; };
    nil = { url = "github:oxalica/nil"; inputs.nixpkgs.follows = "nixpkgs"; };
    disko = { url = "github:nix-community/disko"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      lib = import ./lib inputs;

      nixosConfigurations = import ./hosts inputs;

      packages.${system} = import ./packages inputs;

      apps = inputs.nixinate.nixinate.${system} inputs.self;

      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [ pkgs.nixpkgs-fmt inputs.agenix.packages.${system}.agenix pkgs.age-plugin-yubikey ];
      };
    };
}
