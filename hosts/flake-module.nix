{ inputs, ... }:

let
  commonProfiles = with inputs.self.nixosModules; [
    profiles-agenix
    profiles-cachix-deploy
    profiles-docs
    profiles-misc
    profiles-networking
    profiles-nix-nixpkgs
    profiles-security
    profiles-ssh
    profiles-tailscale
    profiles-users
  ];

  commonHome = [
    inputs.home-manager.nixosModules.default
    {
      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs; };
        users.kranzes = import ../home/kranzes;
      };
    }
  ];
  nixosSystemWithDefaults =
    args:
    (inputs.nixpkgs.lib.nixosSystem (
      (builtins.removeAttrs args [ "hostName" ])
      // {
        specialArgs = {
          inherit inputs;
        }
        // args.specialArgs or { };
        modules = [
          ./${args.hostName}
          { networking = { inherit (args) hostName; }; }
        ]
        ++ commonProfiles
        ++ (args.modules or [ ]);
      }
    ));
in

{
  flake.nixosConfigurations = {
    pongo = nixosSystemWithDefaults {
      system = "x86_64-linux";
      hostName = "pongo";
      modules = commonHome;
    };
    gorilla = nixosSystemWithDefaults {
      system = "x86_64-linux";
      hostName = "gorilla";
      modules = commonHome;
    };
    pan = nixosSystemWithDefaults {
      system = "x86_64-linux";
      hostName = "pan";
      modules = commonHome;
    };
    hetzner = nixosSystemWithDefaults {
      system = "x86_64-linux";
      hostName = "hetzner";
    };
  };
}
