{
  programs.alacritty = {
    enable = true;
    settings = {
      env.WINIT_X11_SCALE_FACTOR = "1";
      font = {
        normal.family = "JetBrains Mono";
        size = 9;
      };
    };
    catppuccin.enable = true;
  };
}
