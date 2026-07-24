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
              "--print-build-logs"
              "--log-format"
              "multiline-with-logs"
              "--use-substitutes"
              "--no-reexec"
              "--flake"
              "${inputs.self}#${host}"
              "--elevate=run0"
            ]
            ++ lib.optional cfg.config.security.run0.wheelNeedsPassword "--ask-elevate-password";
          in
          lib.getExe (
            pkgs.writeShellApplication {
              name = "deploy-${host}";
              text = ''
                TASK="''${1:-switch}"
                shift || true
                TARGET="${cfg.config.networking.hostName}"
                if [[ "$HOSTNAME" == "$TARGET" ]]; then
                  TARGET=""
                fi
                set -x
                ${lib.getExe cfg.config.system.build.nixos-rebuild} "$TASK" ${lib.escapeShellArgs args} --target-host "$TARGET" ${
                  lib.optionalString (host != "hetzner") ''--build-host "$TARGET"''
                } "$@"
              '';
            }
          );
      }) inputs.self.nixosConfigurations;
    };
}
