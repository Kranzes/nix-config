inputs:

{
  pongo = inputs.self.lib.mkSystem {
    hostname = "pongo";
    system = "x86_64-linux";
    extraSpecialArgs.headless = false;
    home-manager = true;
    extraHomeModules = [ inputs.nix-colors.homeManagerModule ];
    deployBuildOn = "remote";
    deploySshUser = "kranzes";
  };

  pan = inputs.self.lib.mkSystem {
    hostname = "pan";
    system = "x86_64-linux";
    extraSpecialArgs.headless = false;
    home-manager = true;
    extraHomeModules = [ inputs.nix-colors.homeManagerModule ];
    deploySshUser = "kranzes";
  };

  vultr = inputs.self.lib.mkSystem {
    hostname = "vultr";
    system = "x86_64-linux";
    extraSpecialArgs.headless = true;
    deploySshUser = "kranzes";
  };
}
