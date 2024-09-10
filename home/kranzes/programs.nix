{
  programs = {
    bat = {
      enable = true;
      config = {
        paging = "never";
        style = "numbers";
      };
      catppuccin.enable = true;
    };

    zathura = {
      enable = true;
      options.font = "JetBrains Mono 8";
      catppuccin.enable = true;
    };

    nheko.enable = true;

    gpg = {
      enable = true;
      scdaemonSettings.disable-ccid = true;
    };
  };
}
