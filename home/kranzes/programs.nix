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
        url = "https://raw.githubusercontent.com/catppuccin/bat/2bafe4454d8db28491e9087ff3a1382c336e7d27/themes/Catppuccin%20Macchiato.tmTheme";
        hash = "sha256-0cSE5kHAM/ztjI6irf88A+Mkmdh7QS3PV5h5jTatAvQ=";
      };
    };

    zathura = {
      enable = true;
      options.font = "JetBrains Mono 8";
      extraConfig = ''
        include ${pkgs.fetchurl {
          url = "https://github.com/catppuccin/zathura/raw/1bda9d8274dd327b7931886ef0c5c1eb33903814/src/catppuccin-macchiato";
          hash = "sha256-tsenfgz1LToAy2cICcPFheutThKhlXEAZfDtW+MnCEk=";
        }}
      '';
    };
  };
}
