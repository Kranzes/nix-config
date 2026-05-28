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
    };
    settings = {
      model = "opus";
      showThinkingSummaries = true;
      tui = "fullscreen";
      theme = "custom:catppuccin:catppuccin-${config.catppuccin.flavor}";
      permissions.defaultMode = "acceptEdits";
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
        };
      };
      enabledPlugins = {
        "commit-commands@claude-plugins-official" = true;
        "catppuccin@claude-themes" = true;
      };
    };
  };
}
