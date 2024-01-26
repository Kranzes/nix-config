{ pkgs, ... }:

{
  programs = {
    bat = {
      enable = true;
      config = {
        paging = "never";
        style = "numbers";
        theme = "catppuccin";
      };
      themes.catppuccin.src = pkgs.fetchurl {
        url = "https://github.com/catppuccin/bat/raw/477622171ec0529505b0ca3cada68fc9433648c6/Catppuccin-macchiato.tmTheme";
        hash = "sha256-76fS4lq8obgOAYaKSVqBc2wOP+RLUCeTQL69vrUfs3k=";
      };
    };

    zathura = {
      enable = true;
      options = {
        font = "JetBrains Mono 8";
        recolor = true;
      };
      extraConfig = ''
        include ${pkgs.fetchurl {
          url = "https://github.com/catppuccin/zathura/raw/b409a2077744e612f61d2edfd9efaf972e155c5f/src/catppuccin-macchiato";
          hash = "sha256-cuR2W/Iwd57XZ+rE/ldIhIPZOQcHZNLtQEl2rUpC4Ek=";
        }}
      '';
    };
  };
}
