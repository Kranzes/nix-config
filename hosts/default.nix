{ inputs, ... }:

{
  flake.nixosConfigurations = {
    pongo = inputs.self.lib.mkSystem {
      hostname = "pongo";
      system = "x86_64-linux";
      extraSpecialArgs.headless = false;
      home-manager = true;
      extraHomeModules = [ inputs.nix-colors.homeManagerModule ];
    };

    pan = inputs.self.lib.mkSystem {
      hostname = "pan";
      system = "x86_64-linux";
      extraSpecialArgs.headless = false;
      home-manager = true;
      extraHomeModules = [ inputs.nix-colors.homeManagerModule ];
    };

    gorilla = inputs.self.lib.mkSystem {
      hostname = "gorilla";
      system = "x86_64-linux";
      extraSpecialArgs.headless = false;
      home-manager = true;
      extraHomeModules = [ inputs.nix-colors.homeManagerModule ];
    };

    hetzner = inputs.self.lib.mkSystem {
      hostname = "hetzner";
      system = "x86_64-linux";
      extraSpecialArgs.headless = true;
    };
  };
}
