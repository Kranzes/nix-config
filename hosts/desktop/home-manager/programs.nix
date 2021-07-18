{ config, pkgs, ... }:

{

  programs = {
    texlive = {
      enable = true;
      extraPackages = tpkgs: { inherit (tpkgs) scheme-full; };
    };

    zathura = {
      enable = true;
      options = {
        font = "JetBrains Mono 9";

        default-fg = "#eceff4";
        default-bg = "#2e3440";

        completion-bg = "#3b4252";
        completion-fg = "#eceff4";
        completion-highlight-bg = "#4c566a";
        completion-highlight-fg = "#eceff4";
        completion-group-bg = "#3b4252";
        completion-group-fg = "#88c0d0";

        statusbar-fg = "#eceff4";
        statusbar-bg = "#3b4252";
        statusbar-h-padding = 10;
        statusbar-v-padding = 10;

        notification-bg = "#2e3440";
        notification-fg = "#eceff4";
        notification-error-bg = "#2e3440";
        notification-error-fg = "#bf616a";
        notification-warning-bg = "#2e3440";
        notification-warning-fg = "#ebcb8b";
        selection-notification = true;

        inputbar-fg = "#eceff4";
        inputbar-bg = "#3b4252";

        recolor = true;
        recolor-lightcolor = "#2e3440";
        recolor-darkcolor = "#d8dee9";

        index-fg = "#eceff4";
        index-bg = "#2e3440";
        index-active-fg = "#eceff4";
        index-active-bg = "#4c566a";

        render-loading-bg = "#2e3440";
        render-loading-fg = "#eceff4";

        highlight-color = "#88c0d0";
        highlight-active-color = "#5e81ac";
      };
    };

  };

}
