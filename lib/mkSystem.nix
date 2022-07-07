{ self, ... } @ inputs:

{ hostname
, system
, extraModules ? [ ]
, home-manager
, extraHomeModules ? [ ]
, deployBuildOn ? "local"
, deploySshUser
}:

inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs self; };
  modules = [
    "${self}/hosts/${hostname}"
    "${self}/modules"
    inputs.agenix.nixosModule
    {
      _module.args.nixinate = {
        host = hostname;
        sshUser = deploySshUser;
        buildOn = deployBuildOn;
        substituteOnTarget = true;
      };
    }
  ] ++ inputs.nixpkgs.lib.optionals home-manager [
    inputs.home-manager.nixosModule
    "${self}/home"
    "${self}/hosts/${hostname}/home"
    {
      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs self; };
        sharedModules = extraHomeModules;
      };
    }
  ] ++ extraModules;
}
