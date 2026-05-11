{ inputs, ... }:

{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem =
    {
      pkgs,
      lib,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        packages = [
          inputs'.agenix.packages.agenix
          pkgs.age-plugin-yubikey
        ];
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;
        };
      };

      apps = lib.mapAttrs' (host: cfg: {
        name = "deploy-${host}";
        value.program =
          let
            args = [
              "-L"
              "--log-format"
              "multiline-with-logs"
              "-s"
              "--no-reexec"
              "--flake"
              "${inputs.self}#${host}"
              "--sudo"
              "--target-host"
              "${cfg.config.networking.hostName}"
            ]
            ++ lib.optionals (host == "pongo") [
              "--build-host"
              "${cfg.config.networking.hostName}"
            ]
            ++ lib.optional cfg.config.security.sudo.wheelNeedsPassword "--ask-sudo-password";
          in
          toString (
            pkgs.writeShellScript "deploy-${host}" ''
              if [[ -n "$1" ]]; then
                TASK="$1"
              else
                TASK="switch"
              fi
              set -x
              ${lib.getExe cfg.config.system.build.nixos-rebuild} "$TASK" ${lib.escapeShellArgs args}
            ''
          );
      }) inputs.self.nixosConfigurations;
    };
}
