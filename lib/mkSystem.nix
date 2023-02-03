inputs:

{ hostname
, system
, extraSpecialArgs ? { }
, extraModules ? [ ]
, home-manager ? false
, extraHomeModules ? [ ]
, deployBuildOn ? "remote"
, deploySshUser
}:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; } // extraSpecialArgs;
  modules = [
    "${inputs.self}/hosts/${hostname}"
    "${inputs.self}/profiles"
    inputs.agenix.nixosModules.age
    {
      networking.hostName = hostname;
      _module.args.nixinate = {
        host = hostname;
        sshUser = deploySshUser;
        buildOn = deployBuildOn;
        substituteOnTarget = true;
      };
    }
  ] ++ inputs.nixpkgs.lib.optionals home-manager [
    inputs.home-manager.nixosModule
    "${inputs.self}/home"
    "${inputs.self}/hosts/${hostname}/home"
    {
      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs; } // extraSpecialArgs;
        sharedModules = extraHomeModules;
      };
    }
  ] ++ extraModules;
}
