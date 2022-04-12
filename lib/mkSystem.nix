{ self, ... } @ inputs: name: system: inputs.nixpkgs.lib.nixosSystem (
  {
    inherit system;
    specialArgs = { inherit inputs self; };
    modules = [
      "${self}/hosts/${name}"
      "${self}/modules"
      "${self}/hosts/${name}/home"
      "${self}/home"
      inputs.home-manager.nixosModule
    ];
  }
)
