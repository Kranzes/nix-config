{ inputs, ... }:

{
  perSystem = { pkgs, lib, ... }: {
    packages = lib.genAttrs (lib.remove "default.nix" (lib.attrNames (builtins.readDir ./.))) (p: pkgs.callPackage ./${p} { });
  };

  flake.packages.${inputs.self.nixosConfigurations.pongo.config.nixpkgs.system}.neovim = inputs.self.nixosConfigurations.pongo.config.home-manager.users.kranzes.programs.neovim.finalPackage.override { wrapRc = true; };
}
