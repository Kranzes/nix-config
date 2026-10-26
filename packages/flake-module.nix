{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        btd700-control = pkgs.callPackage ./btd700-control { };
        btd700-latency = pkgs.callPackage ./btd700-latency { };
        btd700ctl = pkgs.callPackage ./btd700ctl { };
        fuzzel-mpd = pkgs.callPackage ./fuzzel-mpd { };
        maiao = pkgs.callPackage ./maiao { };
      };
    };

  flake.packages.${inputs.self.nixosConfigurations.pongo.pkgs.stdenv.hostPlatform.system}.neovim =
    inputs.self.nixosConfigurations.pongo.config.home-manager.users.kranzes.programs.nixvim.build.package;
}
