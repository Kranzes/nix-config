{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  programs.regreet.enable = true;

  security.pam.services.hyprlock = { };
}
