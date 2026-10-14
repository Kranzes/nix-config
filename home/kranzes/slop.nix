{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:

{
  programs.mcp = {
    enable = true;
    servers = {
      nixos.command = lib.getExe pkgs.mcp-nixos;
    };
  };

  programs.claude-code = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    enableMcpIntegration = true;
    lspServers = {
      nix = {
        command = "nixd";
        extensionToLanguage.".nix" = "nix";
      };
      rust = {
        command = "rust-analyzer";
        extensionToLanguage.".rs" = "rust";
      };
      go = {
        command = "gopls";
        extensionToLanguage.".go" = "go";
      };
    };
    skills.herdr = "${config.programs.herdr.package}/share/skills/herdr/herdr";
    settings = {
      model = "opus";
      effortLevel = "xhigh";
      showThinkingSummaries = true;
      tui = "fullscreen";
      theme = "custom:catppuccin:catppuccin-${config.catppuccin.flavor}";
      permissions.defaultMode = "auto";
      env.FORCE_AUTOUPDATE_PLUGINS = "1";
      attribution = {
        commit = "";
        pr = "";
      };
      extraKnownMarketplaces = {
        claude-themes = {
          source = {
            source = "github";
            repo = "matcra587/claude-themes";
          };
          autoUpdate = true;
        };
      };
      hooks.SessionStart = [
        {
          matcher = "^(startup|resume|clear|compact|fork)$";
          hooks = [
            {
              type = "command";
              command = "${
                lib.getExe (
                  pkgs.writeShellApplication {
                    name = "herdr-claude-hook";
                    runtimeInputs = [ pkgs.python3 ];
                    text = ''exec sh ${config.programs.herdr.package}/share/herdr/integrations/claude/herdr-agent-state.sh "$@"'';
                  }
                )
              } session";
              timeout = 10;
            }
          ];
        }
      ];
      enabledPlugins = {
        "commit-commands@claude-plugins-official" = true;
        "exa@claude-plugins-official" = true;
        "catppuccin@claude-themes" = true;
      };
    };
  };

  programs.herdr = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
    mutableSettings = true;
    settings = {
      onboarding = false;
      update.version_check = false;
      ui = {
        confirm_close = false;
        prompt_new_tab_name = false;
        agent_panel_sort = "priority";
        pane_scrollbars = false;
        hide_tab_bar_when_single_tab = true;
        toast.delivery = "system";
        sound.enabled = false;
      };
      theme.custom.accent = "#b7bdf8";
    };
  };

  home.packages = [
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop
    pkgs.python3
  ];
}
