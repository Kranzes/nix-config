{ inputs, ... }:

let
  commonProfiles = with inputs.self.nixosModules; [
    profiles-docs
    profiles-misc
    profiles-networking
    profiles-nix-nixpkgs
    profiles-security
    profiles-ssh
    profiles-users
  ];

  infraProfiles = with inputs.self.nixosModules; [
    profiles-systemd-creds-openbao
    profiles-tailscale
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
      hostName = "pongo";
      modules = commonHome ++ infraProfiles;
    };
    tamarin = nixosSystemWithDefaults {
      hostName = "tamarin";
      modules = commonHome ++ infraProfiles;
    };
    hetzner = nixosSystemWithDefaults {
      system = "x86_64-linux";
      hostName = "hetzner";
      modules = infraProfiles;
    };
    devbox = nixosSystemWithDefaults {
      system = "x86_64-linux";
      hostName = "devbox";
      modules = commonHome;
    };
  };
}
