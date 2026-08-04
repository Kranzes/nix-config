{ pkgs, config, ... }:

{
  xdg.enable = true;

  home.sessionVariables = {
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    font = {
      name = "Roboto";
      size = 10;
      package = pkgs.roboto;
    };
    theme = {
      name = "Colloid-Purple-Dark-Compact-Catppuccin";
      package = pkgs.colloid-gtk-theme.override {
        themeVariants = [ "purple" ];
        colorVariants = [ "dark" ];
        sizeVariants = [ "compact" ];
        tweaks = [ "catppuccin" ];
      };
    };

    gtk4.theme = config.gtk.theme;
    gtk4.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };

    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
    };

    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
      gtk-enable-event-sounds=0
      gtk-enable-input-feedback-sounds=0
    '';
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };
}
