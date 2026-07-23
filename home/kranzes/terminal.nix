{ config, ... }:
{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrainsMonoNL Nerd Font";
      font-size = 9;
      window-padding-x = 3;
      window-padding-y = 3;
      resize-overlay = "never";
      confirm-close-surface = false;
      quit-after-last-window-closed = false;
      shell-integration-features = "ssh-env,ssh-terminfo";
      app-notifications = false;
      keybind = [ "shift+enter=text:\\n" ];
    };
  };

  xdg.configFile."systemd/user/graphical-session.target.wants/app-com.mitchellh.ghostty.service".source =
    "${config.programs.ghostty.package}/share/systemd/user/app-com.mitchellh.ghostty.service";
}
