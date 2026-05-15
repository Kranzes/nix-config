{
  pkgs,
  lib,
  inputs,
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
      permissions.defaultMode = "acceptEdits";
      attribution = {
        commit = "";
        pr = "";
      };
      enabledPlugins = {
        "commit-commands@claude-plugins-official" = true;
      };
    };
  };

  home.sessionVariables.CLAUDE_CODE_NO_FLICKER = 1;
}
