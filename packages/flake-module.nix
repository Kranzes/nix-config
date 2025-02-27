{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        rofi-mpd = pkgs.callPackage ./rofi-mpd { };
      };
    };

  flake.packages.${inputs.self.nixosConfigurations.pongo.config.nixpkgs.system}.neovim =
    inputs.self.nixosConfigurations.pongo.config.home-manager.users.kranzes.programs.neovim.finalPackage.override
      { wrapRc = true; };
}
