{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        btd700ctl = pkgs.callPackage ./btd700ctl { };
        fuzzel-mpd = pkgs.callPackage ./fuzzel-mpd { };
      };
    };

  flake.packages.${inputs.self.nixosConfigurations.pongo.pkgs.stdenv.hostPlatform.system}.neovim =
    inputs.self.nixosConfigurations.pongo.config.home-manager.users.kranzes.programs.nixvim.build.package;
}
