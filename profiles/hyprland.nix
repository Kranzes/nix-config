{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = pkgs.hyprland.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        (pkgs.fetchpatch {
          name = "hyprland-refocus.patch";
          url = "https://github.com/hyprwm/Hyprland/commit/ab718d8ae71875804222f5ad3f80d8f2cd592330.patch";
          includes = [ "src/desktop/state/FocusState.cpp" ];
          hash = "sha256-Un728vGoK1vCnBf4BKE8jeSgR0b8Ad/dO+/tHuu02n8=";
        })
      ];
    });
  };

  programs.regreet.enable = true;

  security.pam.services.hyprlock = { };
}
