{
  description = "My nix flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = { url = "github:hercules-ci/flake-parts"; inputs.nixpkgs-lib.follows = "nixpkgs"; };
    home-manager = { url = "github:nix-community/home-manager"; inputs.nixpkgs.follows = "nixpkgs"; };
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nix-colors.url = "github:misterio77/nix-colors";
    agenix = { url = "github:ryantm/agenix"; inputs.nixpkgs.follows = "nixpkgs"; };
    nil = { url = "github:oxalica/nil"; inputs.nixpkgs.follows = "nixpkgs"; };
    disko = { url = "github:nix-community/disko"; inputs.nixpkgs.follows = "nixpkgs"; };
    impermanence.url = "github:nix-community/impermanence";
    firefox-addons = { url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons"; inputs.nixpkgs.follows = "nixpkgs"; };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      imports = [
        ./packages
        ./lib
        ./hosts
      ];

      perSystem = { pkgs, inputs', lib, ... }: {
        devShells.default = pkgs.mkShellNoCC {
          packages = [
            inputs'.agenix.packages.agenix
            pkgs.age-plugin-yubikey
          ];
        };

        apps = lib.mapAttrs'
          (host: cfg: {
            name = "deploy-${host}";
            value.program = toString (pkgs.writeShellScript "deploy-${host}" ''
              set -x
              ${lib.getExe pkgs.nixos-rebuild} switch -s --use-remote-sudo --fast --flake ${inputs.self}#${host} \
              --target-host ${cfg.config.networking.hostName} ${lib.optionalString (host == "pongo") "--build-host ${cfg.config.networking.hostName}"}
            '');
          })
          inputs.self.nixosConfigurations;
      };
    };
}
