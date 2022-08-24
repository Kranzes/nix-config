{ self, ... } @ inputs:

{
  pongo = self.lib.mkSystem {
    hostname = "pongo";
    system = "x86_64-linux";
    extraSpecialArgs.headless = false;
    home-manager = true;
    extraHomeModules = [ inputs.nix-colors.homeManagerModule inputs.discocss.hmModule ];
    deployBuildOn = "remote";
    deploySshUser = "kranzes";
  };

  pan = self.lib.mkSystem {
    hostname = "pan";
    system = "x86_64-linux";
    extraSpecialArgs.headless = false;
    home-manager = true;
    extraHomeModules = [ inputs.nix-colors.homeManagerModule inputs.discocss.hmModule ];
    deploySshUser = "kranzes";
  };

  vultr = self.lib.mkSystem {
    hostname = "vultr";
    system = "x86_64-linux";
    extraSpecialArgs.headless = true;
    deploySshUser = "kranzes";
  };
}
