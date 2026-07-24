{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.regreet = {
    enable = true;
    font = {
      package = pkgs.roboto;
      name = "Roboto";
    };
  };

  security.pam.services.hyprlock = { };

  services.gnome.evolution-data-server.enable = true;
}
