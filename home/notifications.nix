{ config, pkgs, ... }:

{

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        geometry = "350x20-12+50";
        max_icon_size = 32;
        indicate_hidden = false;
        shrink = false;
        separator_height = 2;
        padding = 10;
        horizontal_padding = 10;
        frame_width = 4;
        frame_color = "#4C566A";
        separator_color = "frame";
        sort = false;
        idle_threshold = 180;
        font = "JetBrains Mono 10";
        line_height = 5;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ignore_newline = false;
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = false;
        history_length = 20;
        title = "Dunst";
        class = "Dunst";
      };
      urgency_normal = {
        background = "#3b4252";
        foreground = "#eceff4";
        timeout = 10;
      };
    };
  };

  home.packages = with pkgs; [ libnotify ];

}

