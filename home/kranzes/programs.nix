{ config, pkgs, ... }:

{
  programs = {
    bat = {
      enable = true;
      config = {
        paging = "never";
        style = "numbers";
        theme = "Nord";
      };
    };

    discocss = {
      enable = true;
      css = builtins.readFile "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/orblazer/discord-nordic/612c74295c5466c5dc00d624d188ffc3f213da3d/base.css";
        sha256 = "sha256-ur70DweeeLZBtHrF9k0+SDVPQjrTKTj7zL+cp45WyM0="; }
      }";
    };

    newsboat = {
      enable = true;
      autoReload = true;
      extraConfig = ''
        include ${pkgs.newsboat}/share/doc/newsboat/contrib/colorschemes/nord
      '';
      urls = [
        {
          title = "Repology feed for personal@ilanjoselevich.com";
          url = "https://repology.org/maintainer/personal%40ilanjoselevich.com/feed-for-repo/nix_unstable/atom";
        }
      ];
    };

    zathura = {
      enable = true;
      options = let inherit (config.colorscheme) colors; in
        {
          font = "JetBrains Mono 9";

          default-fg = "#${colors.base06}";
          default-bg = "#${colors.base00}";

          completion-bg = "#${colors.base01}";
          completion-fg = "#${colors.base06}";
          completion-highlight-bg = "#${colors.base03}";
          completion-highlight-fg = "#${colors.base06}";
          completion-group-bg = "#${colors.base01}";
          completion-group-fg = "#${colors.base0C}";

          statusbar-fg = "#${colors.base06}";
          statusbar-bg = "#${colors.base01}";
          statusbar-h-padding = 10;
          statusbar-v-padding = 10;

          notification-bg = "#${colors.base00}";
          notification-fg = "#${colors.base06}";
          notification-error-bg = "#${colors.base00}";
          notification-error-fg = "#${colors.base08}";
          notification-warning-bg = "#${colors.base00}";
          notification-warning-fg = "#${colors.base0A}";
          selection-notification = true;

          inputbar-fg = "#${colors.base06}";
          inputbar-bg = "#${colors.base01}";

          recolor = true;
          recolor-lightcolor = "#${colors.base00}";
          recolor-darkcolor = "#${colors.base04}";

          index-fg = "#${colors.base06}";
          index-bg = "#${colors.base00}";
          index-active-fg = "#${colors.base06}";
          index-active-bg = "#${colors.base03}";

          render-loading-bg = "#${colors.base00}";
          render-loading-fg = "#${colors.base06}";

          highlight-color = "#${colors.base0C}";
          highlight-active-color = "#${colors.base0F}";
        };
    };
  };
}
