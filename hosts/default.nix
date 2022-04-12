{ self, ... } @ inputs: {
  pongo = self.lib.mkSystem "pongo" "x86_64-linux";
  pan = self.lib.mkSystem "pan" "x86_64-linux";
}
