{ inputs, ... }:

let
  commonProfiles = with inputs.self.nixosModules; [
    android
    audio
    docs
    misc
    nix-nixpkgs
    opengl
    security
    ssh
    tailscale
    users
    xserver
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
        inputs.self.nixosModules.laptop
      ] ++ commonProfiles ++ commonHome;
    };
    pan = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        "${inputs.self}/hosts/pan"
        { networking.hostName = "pan"; }
        inputs.self.nixosModules.laptop
      ] ++ commonProfiles ++ commonHome;
    };
  };
}
