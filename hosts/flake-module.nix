{ inputs, ... }:

let
  commonProfiles = with inputs.self.nixosModules; [
    docs
    misc
    nix-nixpkgs
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
in

{
  flake.nixosConfigurations = {
    pongo = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        "${inputs.self}/hosts/pongo"
        { networking.hostName = "pongo"; }
      ] ++ commonProfiles ++ commonHome;
    };
    gorilla = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        "${inputs.self}/hosts/gorilla"
        { networking.hostName = "gorilla"; }
      ] ++ commonProfiles ++ commonHome;
    };
    pan = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        "${inputs.self}/hosts/pan"
        { networking.hostName = "pan"; }
      ] ++ commonProfiles ++ commonHome;
    };
    hetzner = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        "${inputs.self}/hosts/hetzner"
        { networking.hostName = "hetzner"; }
      ] ++ commonProfiles;
    };
  };
}
