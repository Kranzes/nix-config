{ config, pkgs, ... }:
{
  imports = [ ../custom-modules/espanso ];

  services.espanso = {
    enable = true;
    settings = {
      matches = [
        {
          trigger = "ty";
          replace = "thank you";
          word = true;
        }
      ];
    };
    matches = {
      wdym = "what do you mean";
      btw = "by the way";
      tbh = "to be honest";
      iirc = "if i remember correctly";
      idk = "I don't know";
    };
  };

}




















