{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "150.0";
    hash = "sha256-elGsTJu+eSzyS9IAnQuEppyhdDkRQwggUP7aypuXRh8=";
  };
in
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    package = pkgs.firefox.overrideAttrs (old: {
      makeWrapperArgs = old.makeWrapperArgs ++ [
        "--set"
        "MOZ_USE_XINPUT2"
        "1"
      ];
    });
    profiles.default = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
        clearurls
        facebook-container
        istilldontcareaboutcookies
        sponsorblock
        translate-web-pages
        (flagfox.overrideAttrs { meta.license.free = true; })
      ];
      preConfig = lib.concatMapStringsSep "\n" builtins.readFile [
        "${betterfox}/Fastfox.js"
        "${betterfox}/Securefox.js"
        "${betterfox}/Peskyfox.js"
        "${betterfox}/Smoothfox.js"
      ];
      settings = {
        # General
        "accessibility.typeaheadfind.enablesound" = false;
        "browser.search.suggest.enabled" = true;
        "browser.tabs.inTitlebar" = 0;
        "browser.uidensity" = 1;
        "dom.security.https_only_mode" = true;
        "permissions.default.desktop-notification" = 0;
        "privacy.trackingprotection.allow_list.convenience.enabled" = true;

        # Graphics
        "gfx.webrender.all" = true;
        "gfx.x11-egl.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
      };
    };
  };

  catppuccin.firefox.profiles.default.enable = false;
}
