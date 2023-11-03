{ inputs, ... }:

let
  commonProfiles = with inputs.self.nixosModules; [
    agenix
    cachix-deploy
    docs
    misc
    nix-nixpkgs
    security
    ssh
    tailscale
    users
  ];

  commonHome = [
    inputs.home-manager.nixosModule
    {
      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs; };
        users.kranzes = import "${inputs.self}/home/kranzes";
      };
    }
  ];
  nixosSystemWithDefaults = args: (inputs.nixpkgs.lib.nixosSystem ((builtins.removeAttrs args [ "hostName" ]) // ({
    specialArgs = { inherit inputs; } // args.specialArgs or { };
    modules = [
      "${inputs.self}/hosts/${args.hostName}"
      { networking = { inherit (args) hostName; }; }
    ] ++ commonProfiles ++ (args.modules or [ ]);
  })));
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
