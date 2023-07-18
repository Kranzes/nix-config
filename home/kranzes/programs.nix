{ pkgs, ... }:

{
  # Remove when https://github.com/mlvzk/discocss/issues/26 is fixed.
  home.packages = [ (pkgs.discord.override { withOpenASAR = true; }) ];

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
      enable = false; # Disable until https://github.com/mlvzk/discocss/issues/26 is fixed.
      discordPackage = pkgs.discord.override { withOpenASAR = true; };
      css = builtins.readFile "${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/orblazer/discord-nordic/bfd1da7e7a9a4291cd8f8c3dffc6a93dfc3d39d7/nordic.theme.css";
        sha256 = "sha256-LH/bRd7J2I69vdgpFkAa/HPEGISh6CFIyoT1f5uMBI8="; }
      }";
    };

    zathura = {
      enable = true;
      options = {
        font = "JetBrains Mono 9";
        completion-bg = "#3B4252";
        completion-fg = "#ECEFF4";
        completion-group-bg = "#3B4252";
        completion-group-fg = "#88C0D0";
        completion-highlight-bg = "#4C566A";
        completion-highlight-fg = "#ECEFF4";
        default-bg = "#2E3440";
        default-fg = "#ECEFF4";
        highlight-active-color = "#5E81AC";
        highlight-color = "#88C0D0";
        index-active-bg = "#4C566A";
        index-active-fg = "#ECEFF4";
        index-bg = "#2E3440";
        index-fg = "#ECEFF4";
        inputbar-bg = "#3B4252";
        inputbar-fg = "#ECEFF4";
        notification-bg = "#2E3440";
        notification-error-bg = "#2E3440";
        notification-error-fg = "#BF616A";
        notification-fg = "#ECEFF4";
        notification-warning-bg = "#2E3440";
        notification-warning-fg = "#EBCB8B";
        recolor = true;
        recolor-darkcolor = "#D8DEE9";
        recolor-lightcolor = "#2E3440";
        render-loading-bg = "#2E3440";
        render-loading-fg = "#ECEFF4";
        selection-notification = true;
        statusbar-bg = "#3B4252";
        statusbar-fg = "#ECEFF4";
        statusbar-h-padding = 10;
        statusbar-v-padding = 10;
      };
    };
  };
}
