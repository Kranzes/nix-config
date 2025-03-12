{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "133.0";
    hash = "sha256-Uu/a5t74GGvMIJP5tptqbiFiA+x2hw98irPdl8ynGoE=";
  };
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.overrideAttrs (old: {
      makeWrapperArgs = old.makeWrapperArgs ++ [
        "--set"
        "MOZ_USE_XINPUT2"
        "1"
      ];
    });
    profiles.default = {
      extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
        ublock-origin
        clearurls
        facebook-container
        istilldontcareaboutcookies
        privacy-badger
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

        # Graphics
        "gfx.webrender.all" = true;
        "gfx.x11-egl.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "widget.dmabuf.force-enabled" = true;
      };
    };
  };
}
