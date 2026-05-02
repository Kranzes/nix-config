{
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "JetBrainsMonoNL Nerd Font";
        size = 9;
      };
      window.padding = {
        x = 3;
        y = 3;
      };
      keyboard.bindings = [
        {
          key = "Return";
          mods = "Shift";
          chars = "\n";
        }
      ];
    };
  };
}
