{
  programs = {
    bat = {
      enable = true;
      config = {
        paging = "never";
        style = "numbers";
      };
    };

    zathura = {
      enable = true;
      options.font = "JetBrains Mono 8";
    };

    nheko.enable = true;

    gpg = {
      enable = true;
      scdaemonSettings.disable-ccid = true;
    };
  };
}
